{
  lib,
  bison,
  buildPackages,
  directx-headers,
  elfutils,
  expat,
  fetchCrate,
  fetchFromGitLab,
  file,
  flex,
  glslang,
  spirv-tools,
  intltool,
  jdupes,
  libdisplay-info,
  libdrm,
  libgbm,
  libglvnd,
  libpng,
  libunwind,
  libva-minimal,
  llvmPackages,
  lm_sensors,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  runCommand,
  rust-bindgen,
  rust-cbindgen,
  rustc,
  spirv-llvm-translator,
  stdenv,
  udev,
  valgrind-light,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xcbutilkeysyms,
  xorg,
  zstd,
  enablePatentEncumberedCodecs ? true,
  withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light,
  withOpenCL ? lib.meta.availableOn stdenv.hostPlatform llvmPackages.clang,
  # Check if we have a VA gallium driver enabled
  # See https://gitlab.freedesktop.org/mesa/mesa/-/blob/25.2/meson.build?ref_type=heads#L675-681
  withVa ? lib.any (
    x:
    lib.elem x [
      "r600"
      "radeonsi"
      "nouveau"
      "d3d12"
      "virgl"
    ]
  ) galliumDrivers,

  # We enable as many drivers as possible here, to build cross tools
  # and support emulation use cases (emulated x86_64 on aarch64, etc)
  galliumDrivers ? [
    "asahi" # Apple AGX
    "crocus" # Intel legacy
    "d3d12" # WSL emulated GPU (aka Dozen)
    "etnaviv" # Vivante GPU designs (mostly NXP/Marvell SoCs)
    "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
    "i915" # Intel extra legacy
    "iris" # new Intel (Broadwell+)
    "lima" # ARM Mali 4xx
    "llvmpipe" # software renderer
    "nouveau" # Nvidia
    "panfrost" # ARM Mali Midgard and up (T/G series)
    "r300" # very old AMD
    "r600" # less old AMD
    "radeonsi" # new AMD (GCN+)
    "softpipe" # older software renderer
    "svga" # VMWare virtualized GPU
    "tegra" # Nvidia Tegra SoCs
    "v3d" # Broadcom VC5 (Raspberry Pi 4)
    "vc4" # Broadcom VC4 (Raspberry Pi 0-3)
    "virgl" # QEMU virtualized GPU (aka VirGL)
    "zink" # generic OpenGL over Vulkan, experimental
  ]
  ++ lib.optionals stdenv.hostPlatform.is64bit [
    "ethosu" # ARM Ethos NPU, does not build on 32-bit
    "rocket" # Rockchip NPU, probably horribly broken on 32-bit
  ],
  vulkanDrivers ? [
    "amd" # AMD (aka RADV)
    "asahi" # Apple AGX
    "broadcom" # Broadcom VC5 (Raspberry Pi 4, aka V3D)
    "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
    "gfxstream" # Android virtualized GPU
    "imagination" # PowerVR Rogue (currently N/A)
    "intel_hasvk" # Intel Haswell/Broadwell, "legacy" Vulkan driver (https://www.phoronix.com/news/Intel-HasVK-Drop-Dead-Code)
    "intel" # new Intel (aka ANV)
    "microsoft-experimental" # WSL virtualized GPU (aka DZN/Dozen)
    "nouveau" # Nouveau (aka NVK)
    "panfrost" # ARM Mali Midgard and up (T/G series)
    "swrast" # software renderer (aka Lavapipe)
  ]
  ++
    lib.optionals
      (stdenv.hostPlatform.isAarch -> lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6")
      [
        # QEMU virtualized GPU (aka VirGL)
        # Requires ATOMIC_INT_LOCK_FREE == 2.
        "virtio"
      ],
  eglPlatforms ? [
    "x11"
    "wayland"
  ],
  vulkanLayers ? [
    "anti-lag"
    "device-select"
    "intel-nullhw"
    "overlay"
    "screenshot"
    "vram-report-limit"
  ],
  mesa,
  mesa-gl-headers,
  makeSetupHook,
}:

let
  rustDeps = lib.importJSON ./wraps.json;

  fetchDep =
    dep:
    fetchCrate {
      inherit (dep) pname version hash;
      unpack = false;
    };

  toCommand = dep: "ln -s ${dep} $out/${dep.pname}-${dep.version}.tar.gz";

  packageCacheCommand = lib.pipe rustDeps [
    (map fetchDep)
    (map toCommand)
    (lib.concatStringsSep "\n")
  ];

  packageCache = runCommand "mesa-rust-package-cache" { } ''
    mkdir -p $out
    ${packageCacheCommand}
  '';

  needNativeCLC = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  common = import ./common.nix { inherit lib fetchFromGitLab; };

  withDozen = lib.elem "d3d12" galliumDrivers;
in
stdenv.mkDerivation {
  inherit (common)
    pname
    version
    src
    meta
    ;

  patches = [
    ./opencl.patch
    ./musl.patch
  ];

  postPatch = ''
    patchShebangs .

    for header in ${toString mesa-gl-headers.headers}; do
      if ! diff -q $header ${mesa-gl-headers}/$header; then
        echo "File $header does not match between mesa and mesa-gl-headers, please update mesa-gl-headers first!"
        exit 42
      fi
    done
  '';

  outputs = [
    "out"
  ]
  # OpenCL drivers pull in ~1G of extra LLVM stuff, so don't install them
  # if the user didn't explicitly ask for it
  ++ lib.optional withOpenCL "opencl"
  ++ lib.optionals (!needNativeCLC) [
    # tools for the host platform to be used when cross-compiling.
    # mesa builds these only when not already built. hence:
    # - for a non-cross build (needNativeCLC = false), we do not provide mesa
    #   with any `*-clc` binaries, so it builds them and installs them.
    # - for a cross build (needNativeCLC = true), we provide mesa with `*-clc`
    #   binaries, so it skips building & installing any new CLC files.
    "cross_tools"
  ]
  # the Dozen drivers depend on libspirv2dxil, but link it statically, and
  # libspirv2dxil itself is pretty chonky, so relocate it to its own output in
  # case anything wants to use it at some point
  ++ lib.optional withDozen "spirv2dxil";

  # Keep build-ids so drivers can use them for caching, etc.
  # Also some drivers segfault without this.
  separateDebugInfo = true;
  __structuredAttrs = true;

  # Needed to discover llvm-config for cross
  preConfigure = ''
    PATH=${lib.getDev llvmPackages.libllvm}/bin:$PATH
  '';

  env.MESON_PACKAGE_CACHE_DIR = packageCache;

  mesonFlags = [
    "--sysconfdir=/etc"

    # What to build
    (lib.mesonOption "platforms" (lib.concatStringsSep "," eglPlatforms))
    (lib.mesonOption "gallium-drivers" (lib.concatStringsSep "," galliumDrivers))
    (lib.mesonOption "vulkan-drivers" (lib.concatStringsSep "," vulkanDrivers))
    (lib.mesonOption "vulkan-layers" (lib.concatStringsSep "," vulkanLayers))

    # Enable glvnd for dynamic libGL dispatch
    (lib.mesonEnable "glvnd" true)
    (lib.mesonEnable "gbm" true)
    (lib.mesonBool "libgbm-external" true)

    (lib.mesonBool "teflon" true) # TensorFlow frontend

    # Enable all freedreno kernel mode drivers. (For example, virtio can be
    # used with a virtio-gpu device supporting drm native context.) This option
    # is ignored when freedreno is not being built.
    (lib.mesonOption "freedreno-kmds" "msm,kgsl,virtio,wsl")

    # Rusticl, new OpenCL frontend
    (lib.mesonBool "gallium-rusticl" withOpenCL)
    (lib.mesonOption "gallium-rusticl-enable-drivers" "auto")

    # Enable more sensors in gallium-hud
    (lib.mesonBool "gallium-extra-hud" true)

    # Disable valgrind on targets where it's not available
    (lib.mesonEnable "valgrind" withValgrind)

    # Enable Intel RT stuff when available
    (lib.mesonEnable "intel-rt" (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64))

    # Enable VA-API
    (lib.mesonEnable "gallium-va" withVa)

    # meson auto_features enables these, but we do not want them
    (lib.mesonEnable "gallium-mediafoundation" false) # Windows only
    (lib.mesonEnable "android-libbacktrace" false) # Android only
    (lib.mesonEnable "microsoft-clc" false) # Only relevant on Windows (OpenCL 1.2 API on top of D3D12)
    (lib.mesonEnable "gallium-vdpau" false) # Gone in 25.3
  ]
  ++ lib.optionals enablePatentEncumberedCodecs [
    (lib.mesonOption "video-codecs" "all")
  ]
  ++ lib.optionals (!needNativeCLC) [
    # Build and install extra tools for cross
    (lib.mesonOption "tools" "asahi,panfrost")
    (lib.mesonBool "install-mesa-clc" true)
    (lib.mesonBool "install-precomp-compiler" true)
  ]
  ++ lib.optionals needNativeCLC [
    (lib.mesonOption "mesa-clc" "system")
    (lib.mesonOption "precomp-compiler" "system")
  ]
  ++ lib.optionals withOpenCL [
    # Required for OpenCL
    (lib.mesonOption "clang-libdir" "${lib.getLib llvmPackages.clang-unwrapped}/lib")
  ];

  strictDeps = true;

  buildInputs =
    with xorg;
    [
      directx-headers
      elfutils
      expat
      spirv-tools
      libdisplay-info
      libdrm
      libgbm
      libglvnd
      libpng
      libunwind
      libva-minimal
      libX11
      libxcb
      libXext
      libXfixes
      libXrandr
      libxshmfence
      libXxf86vm
      lm_sensors
      python3Packages.python # for shebang
      spirv-llvm-translator
      udev
      vulkan-loader
      wayland
      wayland-protocols
      xcbutilkeysyms
      xorgproto
      zstd
    ]
    ++ lib.optionals withValgrind [
      valgrind-light
    ]
    ++ lib.optionals withOpenCL [
      llvmPackages.clang
      llvmPackages.clang-unwrapped
      llvmPackages.libclc
      llvmPackages.libllvm
    ];

  depsBuildBuild = [
    pkg-config
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    intltool
    bison
    flex
    file
    python3Packages.python
    python3Packages.packaging
    python3Packages.pycparser
    python3Packages.mako
    python3Packages.ply
    python3Packages.pyyaml
    jdupes
    # Use bin output from glslang to not propagate the dev output at
    # the build time with the host glslang.
    (lib.getBin glslang)
    rustc
    rust-bindgen
    rust-cbindgen
    wayland-scanner
  ]
  ++ lib.optionals needNativeCLC [
    # `or null` to not break eval with `attribute missing` on darwin to linux cross
    (buildPackages.mesa.cross_tools or null)
  ];

  disallowedRequisites = lib.optional (
    needNativeCLC && buildPackages.mesa ? cross_tools
  ) buildPackages.mesa.cross_tools;

  doCheck = false;

  postInstall = ''
    moveToOutput bin/asahi_clc $cross_tools
    moveToOutput bin/intel_clc $cross_tools
    moveToOutput bin/mesa_clc $cross_tools
    moveToOutput bin/panfrost_compile $cross_tools
    moveToOutput bin/panfrost_texfeatures $cross_tools
    moveToOutput bin/panfrostdump $cross_tools
    moveToOutput bin/pco_clc $cross_tools
    moveToOutput bin/vtn_bindgen2 $cross_tools

    ${lib.optionalString withOpenCL ''
      moveToOutput "lib/lib*OpenCL*" $opencl
      # Construct our own .icd file that contains an absolute path.
      mkdir -p $opencl/etc/OpenCL/vendors/
      echo $opencl/lib/libRusticlOpenCL.so > $opencl/etc/OpenCL/vendors/rusticl.icd
    ''}

    moveToOutput bin/spirv2dxil $spirv2dxil
    moveToOutput "lib/libspirv_to_dxil*" $spirv2dxil
  '';

  postFixup = ''
    # set full path in EGL driver manifest
    for js in $out/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace-fail '"libEGL_' '"'"$out/lib/libEGL_"
    done

    # and in Vulkan layer manifests
    for js in $out/share/vulkan/{im,ex}plicit_layer.d/*.json; do
      substituteInPlace "$js" --replace '"libVkLayer_' '"'"$out/lib/libVkLayer_"
    done

    # remove DRI pkg-config file, provided by dri-pkgconfig-stub
    rm -f $out/lib/pkgconfig/dri.pc

    # remove headers moved to mesa-gl-headers
    for header in ${toString mesa-gl-headers.headers}; do
      rm -f $out/$header
    done

    # clean up after removing stuff
    find $out -type d -empty -delete

    # Don't depend on build python
    patchShebangs --host --update $out/bin/*

    # NAR doesn't support hard links, so convert them to symlinks to save space.
    jdupes --hard-links --link-soft --recurse "$out"

    # add RPATH here so Zink can find libvulkan.so
    patchelf --add-rpath ${vulkan-loader}/lib $out/lib/libgallium*.so
  '';

  passthru = {
    inherit (libglvnd) driverLink;
    inherit llvmPackages;
    inherit
      eglPlatforms
      galliumDrivers
      vulkanDrivers
      vulkanLayers
      ;

    # for compatibility
    drivers = lib.warn "`mesa.drivers` is deprecated, use `mesa` instead" mesa;

    tests.outDoesNotDependOnLLVM = stdenv.mkDerivation {
      name = "mesa-does-not-depend-on-llvm";
      buildCommand = ''
        echo ${mesa} >>$out
      '';
      disallowedRequisites = [ llvmPackages.llvm ];
    };

    llvmpipeHook = makeSetupHook {
      name = "llvmpipe-hook";
      substitutions.mesa = mesa;
    } ./llvmpipe-hook.sh;
  };
}
