{ lib
, bison
, buildPackages
, directx-headers
, elfutils
, expat
, fetchCrate
, fetchFromGitLab
, fetchpatch
, file
, flex
, glslang
, spirv-tools
, intltool
, jdupes
, libdrm
, libglvnd
, libomxil-bellagio
, libunwind
, libva-minimal
, libvdpau
, llvmPackages
, lm_sensors
, meson
, ninja
, pkg-config
, python3Packages
, rust-bindgen
, rust-cbindgen
, rustPlatform
, rustc
, spirv-llvm-translator
, stdenv
, udev
, valgrind-light
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, xcbutilkeysyms
, xorg
, zstd
, enablePatentEncumberedCodecs ? true
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light

, galliumDrivers ? [
    "d3d12" # WSL emulated GPU (aka Dozen)
    "iris" # new Intel (Broadwell+)
    "llvmpipe" # software renderer
    "nouveau" # Nvidia
    "r300" # very old AMD
    "r600" # less old AMD
    "radeonsi" # new AMD (GCN+)
    "softpipe" # older software renderer
    "svga" # VMWare virtualized GPU
    "virgl" # QEMU virtualized GPU (aka VirGL)
    "zink" # generic OpenGL over Vulkan, experimental
  ] ++ lib.optionals (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32) [
    "etnaviv" # Vivante GPU designs (mostly NXP/Marvell SoCs)
    "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
    "lima" # ARM Mali 4xx
    "panfrost" # ARM Mali Midgard and up (T/G series)
    "vc4" # Broadcom VC4 (Raspberry Pi 0-3)
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "tegra" # Nvidia Tegra SoCs
    "v3d" # Broadcom VC5 (Raspberry Pi 4)
  ] ++ lib.optionals stdenv.hostPlatform.isx86 [
    "crocus" # Intel legacy, x86 only
    "i915" # Intel extra legacy, x86 only
  ]
, vulkanDrivers ? [
    "amd" # AMD (aka RADV)
    "intel" # new Intel (aka ANV)
    "microsoft-experimental" # WSL virtualized GPU (aka DZN/Dozen)
    "nouveau" # Nouveau (aka NVK)
    "swrast" # software renderer (aka Lavapipe)
  ] ++ lib.optionals (stdenv.hostPlatform.isAarch -> lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6") [
    # QEMU virtualized GPU (aka VirGL)
    # Requires ATOMIC_INT_LOCK_FREE == 2.
    "virtio"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "broadcom" # Broadcom VC5 (Raspberry Pi 4, aka V3D)
    "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
    "imagination-experimental" # PowerVR Rogue (currently N/A)
    "panfrost" # ARM Mali Midgard and up (T/G series)
  ] ++ lib.optionals stdenv.hostPlatform.isx86 [
    "intel_hasvk" # Intel Haswell/Broadwell, "legacy" Vulkan driver (https://www.phoronix.com/news/Intel-HasVK-Drop-Dead-Code)
  ]
, eglPlatforms ? [ "x11" "wayland" ]
, vulkanLayers ? [
    "device-select"
    "overlay"
    "intel-nullhw"
  ]
, mesa
, makeSetupHook
}:

let
  rustDeps = [
    {
      pname = "paste";
      version = "1.0.14";
      hash = "sha256-+J1h7New5MEclUBvwDQtTYJCHKKqAEOeQkuKy+g0vEc=";
    }
    {
      pname = "proc-macro2";
      version = "1.0.86";
      hash = "sha256-9fYAlWRGVIwPp8OKX7Id84Kjt8OoN2cANJ/D9ZOUUZE=";
    }
    {
      pname = "quote";
      version = "1.0.33";
      hash = "sha256-VWRCZJO0/DJbNu0/V9TLaqlwMot65YjInWT9VWg57DY=";
    }
    {
      pname = "syn";
      version = "2.0.68";
      hash = "sha256-nGLBbxR0DFBpsXMngXdegTm/o13FBS6QsM7TwxHXbgQ=";
    }
    {
      pname = "unicode-ident";
      version = "1.0.12";
      hash = "sha256-KX8NqYYw6+rGsoR9mdZx8eT1HIPEUUyxErdk2H/Rlj8=";
    }
  ];

  copyRustDep = dep: ''
    cp -R --no-preserve=mode,ownership ${fetchCrate dep} subprojects/${dep.pname}-${dep.version}
    cp -R subprojects/packagefiles/${dep.pname}/* subprojects/${dep.pname}-${dep.version}/
  '';

  copyRustDeps = lib.concatStringsSep "\n" (builtins.map copyRustDep rustDeps);

  needNativeCLC = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  common = import ./common.nix { inherit lib fetchFromGitLab; };
in stdenv.mkDerivation {
  inherit (common) pname version src meta;

  patches = [
    ./opencl.patch
  ];

  postPatch = ''
    patchShebangs .

    # The drirc.d directory cannot be installed to $drivers as that would cause a cyclic dependency:
    substituteInPlace src/util/xmlconfig.c --replace \
      'DATADIR "/drirc.d"' '"${placeholder "out"}/share/drirc.d"'
    substituteInPlace src/util/meson.build --replace \
      "get_option('datadir')" "'${placeholder "out"}/share'"
    substituteInPlace src/amd/vulkan/meson.build --replace \
      "get_option('datadir')" "'${placeholder "out"}/share'"

    ${copyRustDeps}
  '';

  outputs = [
    "out" "dev" "drivers" "driversdev" "opencl" "teflon" "osmesa"
    # the Dozen drivers depend on libspirv2dxil, but link it statically, and
    # libspirv2dxil itself is pretty chonky, so relocate it to its own output in
    # case anything wants to use it at some point
    "spirv2dxil"
  ];

  # Keep build-ids so drivers can use them for caching, etc.
  # Also some drivers segfault without this.
  separateDebugInfo = true;

  # Needed to discover llvm-config for cross
  preConfigure = ''
    PATH=${llvmPackages.libllvm.dev}/bin:$PATH
  '';

  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "drivers"}/share"

    # What to build
    (lib.mesonOption "platforms" (lib.concatStringsSep "," eglPlatforms))
    (lib.mesonOption "gallium-drivers" (lib.concatStringsSep "," galliumDrivers))
    (lib.mesonOption "vulkan-drivers" (lib.concatStringsSep "," vulkanDrivers))
    (lib.mesonOption "vulkan-layers" (builtins.concatStringsSep "," vulkanLayers))

    # Make sure we know where to find all the drivers
    (lib.mesonOption "dri-drivers-path" "${placeholder "drivers"}/lib/dri")
    (lib.mesonOption "vdpau-libs-path" "${placeholder "drivers"}/lib/vdpau")
    (lib.mesonOption "omx-libs-path" "${placeholder "drivers"}/lib/bellagio")
    (lib.mesonOption "va-libs-path" "${placeholder "drivers"}/lib/dri")
    (lib.mesonOption "d3d-drivers-path" "${placeholder "drivers"}/lib/d3d")

    # Set search paths for non-Mesa drivers (e.g. Nvidia)
    (lib.mesonOption "dri-search-path" "${libglvnd.driverLink}/lib/dri")
    (lib.mesonOption "gbm-backends-path" "${libglvnd.driverLink}/lib/gbm:${placeholder "out"}/lib/gbm")

    # Enable glvnd for dynamic libGL dispatch
    (lib.mesonEnable "glvnd" true)

    (lib.mesonBool "gallium-nine" true) # Direct3D in Wine
    (lib.mesonBool "osmesa" true) # used by wine
    (lib.mesonBool "teflon" true) # TensorFlow frontend

    # Enable Intel RT stuff when available
    (lib.mesonBool "install-intel-clc" true)
    (lib.mesonEnable "intel-rt" stdenv.hostPlatform.isx86_64)
    (lib.mesonOption "clang-libdir" "${llvmPackages.clang-unwrapped.lib}/lib")

    # Clover, old OpenCL frontend
    (lib.mesonOption "gallium-opencl" "icd")
    (lib.mesonBool "opencl-spirv" true)

    # Rusticl, new OpenCL frontend
    (lib.mesonBool "gallium-rusticl" true)

    # meson auto_features enables this, but we do not want it
    (lib.mesonEnable "android-libbacktrace" false)
    (lib.mesonEnable "microsoft-clc" false) # Only relevant on Windows (OpenCL 1.2 API on top of D3D12)
    (lib.mesonEnable "valgrind" withValgrind)
  ] ++ lib.optionals enablePatentEncumberedCodecs [
    (lib.mesonOption "video-codecs" "all")
  ] ++ lib.optionals needNativeCLC [
    (lib.mesonOption "intel-clc" "system")
  ];

  strictDeps = true;

  buildInputs = with xorg; [
    directx-headers
    elfutils
    expat
    spirv-tools
    libglvnd
    libomxil-bellagio
    libunwind
    libva-minimal
    libvdpau
    libX11
    libxcb
    libXext
    libXfixes
    libXrandr
    libxshmfence
    libXxf86vm
    llvmPackages.clang
    llvmPackages.clang-unwrapped
    llvmPackages.libclc
    llvmPackages.libllvm
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
  ] ++ lib.optionals withValgrind [
    valgrind-light
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
    rustPlatform.bindgenHook
    wayland-scanner
  ] ++ lib.optionals needNativeCLC [
    # `or null` to not break eval with `attribute missing` on darwin to linux cross
    (buildPackages.mesa.driversdev or null)
  ];

  disallowedRequisites = lib.optionals needNativeCLC [
    (buildPackages.mesa.driversdev or null)
  ];

  propagatedBuildInputs = [ libdrm ];

  doCheck = false;

  postInstall = ''
    # Move driver-related bits to $drivers
    moveToOutput "lib/lib*_mesa*" $drivers
    moveToOutput "lib/libpowervr_rogue*" $drivers
    moveToOutput "lib/libxatracker*" $drivers
    moveToOutput "lib/libvulkan_*" $drivers

    # Update search path used by glvnd (it's pointing to $out but drivers are in $drivers)
    for js in $drivers/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace-fail '"libEGL_' '"'"$drivers/lib/libEGL_"
    done

    # And same for Vulkan
    for js in $drivers/share/vulkan/icd.d/*.json; do
      substituteInPlace "$js" --replace-fail "$out" "$drivers"
    done

    # Move Vulkan layers to $drivers and update manifests
    moveToOutput "lib/libVkLayer*" $drivers
    for js in $drivers/share/vulkan/{im,ex}plicit_layer.d/*.json; do
      substituteInPlace "$js" --replace '"libVkLayer_' '"'"$drivers/lib/libVkLayer_"
    done

    # Construct our own .icd files that contain absolute paths.
    mkdir -p $opencl/etc/OpenCL/vendors/
    echo $opencl/lib/libMesaOpenCL.so > $opencl/etc/OpenCL/vendors/mesa.icd
    echo $opencl/lib/libRusticlOpenCL.so > $opencl/etc/OpenCL/vendors/rusticl.icd

    moveToOutput bin/intel_clc $driversdev
    moveToOutput lib/gallium-pipe $opencl
    moveToOutput "lib/lib*OpenCL*" $opencl
    moveToOutput "lib/libOSMesa*" $osmesa
    moveToOutput bin/spirv2dxil $spirv2dxil
    moveToOutput "lib/libspirv_to_dxil*" $spirv2dxil
    moveToOutput lib/libteflon.so $teflon
  '';

  postFixup = ''
    # set the default search path for DRI drivers; used e.g. by X server
    for pc in lib/pkgconfig/{dri,d3d}.pc; do
      [ -f "$dev/$pc" ] && substituteInPlace "$dev/$pc" --replace "$drivers" "${libglvnd.driverLink}"
    done

    # remove pkgconfig files for GL/EGL; they are provided by libGL.
    rm -f $dev/lib/pkgconfig/{gl,egl}.pc

    # Move development files for libraries in $drivers to $driversdev
    mkdir -p $driversdev/include
    mv $dev/include/xa_* $dev/include/d3d* -t $driversdev/include || true
    mkdir -p $driversdev/lib/pkgconfig
    for pc in lib/pkgconfig/{xatracker,d3d}.pc; do
      if [ -f "$dev/$pc" ]; then
        substituteInPlace "$dev/$pc" --replace $out $drivers
        mv $dev/$pc $driversdev/$pc
      fi
    done

    # Don't depend on build python
    patchShebangs --host --update $out/bin/*

    # NAR doesn't support hard links, so convert them to symlinks to save space.
    jdupes --hard-links --link-soft --recurse "$drivers"

    # add RPATH so the drivers can find the moved libgallium and libdricore9
    # moved here to avoid problems with stripping patchelfed files
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done

    # add RPATH here so Zink can find libvulkan.so
    patchelf --add-rpath ${vulkan-loader}/lib $out/lib/libgallium*.so
  '';

  env.NIX_CFLAGS_COMPILE = toString ([
    "-UPIPE_SEARCH_DIR"
    "-DPIPE_SEARCH_DIR=\"${placeholder "opencl"}/lib/gallium-pipe\""
  ]);

  passthru = {
    inherit (libglvnd) driverLink;
    inherit llvmPackages;

    tests.devDoesNotDependOnLLVM = stdenv.mkDerivation {
      name = "mesa-dev-does-not-depend-on-llvm";
      buildCommand = ''
        echo ${mesa.dev} >>$out
      '';
      disallowedRequisites = [ llvmPackages.llvm mesa.drivers ];
    };

    llvmpipeHook = makeSetupHook {
      name = "llvmpipe-hook";
      substitutions.drivers = mesa.drivers;
    } ./llvmpipe-hook.sh;
  };
}
