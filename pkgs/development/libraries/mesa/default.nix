{ stdenv, lib, fetchurl, fetchpatch, fetchCrate, buildPackages
, meson, pkg-config, ninja
, intltool, bison, flex, file, python3Packages, wayland-scanner
, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages, libffi, libomxil-bellagio, libva-minimal
, elfutils, libvdpau
, libglvnd, libunwind, lm_sensors
, vulkan-loader, glslang
, galliumDrivers ?
  if stdenv.isLinux then
    [
      "d3d12" # WSL emulated GPU (aka Dozen)
      "kmsro" # special "render only" driver for GPUs without a display controller
      "nouveau" # Nvidia
      "radeonsi" # new AMD (GCN+)
      "r300" # very old AMD
      "r600" # less old AMD
      "swrast" # software renderer (aka LLVMPipe)
      "svga" # VMWare virtualized GPU
      "virgl" # QEMU virtualized GPU (aka VirGL)
      "zink" # generic OpenGL over Vulkan, experimental
    ] ++ lib.optionals (stdenv.isAarch64 || stdenv.isAarch32) [
      "etnaviv" # Vivante GPU designs (mostly NXP/Marvell SoCs)
      "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
      "lima" # ARM Mali 4xx
      "panfrost" # ARM Mali Midgard and up (T/G series)
      "vc4" # Broadcom VC4 (Raspberry Pi 0-3)
    ] ++ lib.optionals stdenv.isAarch64 [
      "tegra" # Nvidia Tegra SoCs
      "v3d" # Broadcom VC5 (Raspberry Pi 4)
    ] ++ lib.optionals stdenv.hostPlatform.isx86 [
      "iris" # new Intel, could work on non-x86 with PCIe cards, but doesn't build as of 22.3.4
      "crocus" # Intel legacy, x86 only
      "i915" # Intel extra legacy, x86 only
    ]
  else [ "auto" ]
, vulkanDrivers ?
  if stdenv.isLinux then
    [
      "amd" # AMD (aka RADV)
      "microsoft-experimental" # WSL virtualized GPU (aka DZN/Dozen)
      "nouveau-experimental" # Nouveau (aka NVK)
      "swrast" # software renderer (aka Lavapipe)
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch -> lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6") [
      # QEMU virtualized GPU (aka VirGL)
      # Requires ATOMIC_INT_LOCK_FREE == 2.
      "virtio"
    ]
    ++ lib.optionals stdenv.isAarch64 [
      "broadcom" # Broadcom VC5 (Raspberry Pi 4, aka V3D)
      "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
      "imagination-experimental" # PowerVR Rogue (currently N/A)
      "panfrost" # ARM Mali Midgard and up (T/G series)
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [
      "intel" # Intel (aka ANV), could work on non-x86 with PCIe cards, but doesn't build
      "intel_hasvk" # Intel Haswell/Broadwell, "legacy" Vulkan driver (https://www.phoronix.com/news/Intel-HasVK-Drop-Dead-Code)
    ]
  else [ "auto" ]
, eglPlatforms ? [ "x11" ] ++ lib.optionals stdenv.isLinux [ "wayland" ]
, vulkanLayers ? lib.optionals (!stdenv.isDarwin) [ "device-select" "overlay" "intel-nullhw" ] # No Vulkan support on Darwin
, OpenGL, Xplugin
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light && !valgrind-light.meta.broken, valgrind-light
, withLibunwind ? lib.meta.availableOn stdenv.hostPlatform libunwind
, enableGalliumNine ? stdenv.isLinux
, enableOSMesa ? stdenv.isLinux
, enableOpenCL ? stdenv.isLinux && stdenv.isx86_64
, enablePatentEncumberedCodecs ? true
, jdupes
, rustPlatform
, rust-bindgen
, rustc
, spirv-llvm-translator
, zstd
, directx-headers
, udev
}:

# When updating this package, please verify at least these build (assuming x86_64-linux):
# nix build .#mesa .#pkgsi686Linux.mesa .#pkgsCross.aarch64-multiplatform.mesa .#pkgsMusl.mesa

let
  version = "24.0.3";
  hash = "sha256-d67JoqN7fTWW6hZAs8xT0LXZs7Uqvtid4H43F+kb/b4=";

  # Release calendar: https://www.mesa3d.org/release-calendar.html
  # Release frequency: https://www.mesa3d.org/releasing.html#schedule
  branch = lib.versions.major version;

  withLibdrm = lib.meta.availableOn stdenv.hostPlatform libdrm;

  haveWayland = lib.elem "wayland" eglPlatforms;
  haveZink = lib.elem "zink" galliumDrivers;
  haveDozen = (lib.elem "d3d12" galliumDrivers) || (lib.elem "microsoft-experimental" vulkanDrivers);

  rustDeps = [
    {
      pname = "proc-macro2";
      version = "1.0.70";
      hash = "sha256-e4ZgyZUTu5nAtaH5QVkLelqJQX/XPj/rWkzf/g2c+1g=";
    }
    {
      pname = "quote";
      version = "1.0.33";
      hash = "sha256-VWRCZJO0/DJbNu0/V9TLaqlwMot65YjInWT9VWg57DY=";
    }
    {
    pname = "syn";
      version = "2.0.39";
      hash = "sha256-Mjen2L/omhVbhU/+Ao65mogs3BP3fY+Bodab3uU63EI=";
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

self = stdenv.mkDerivation {
  pname = "mesa";
  inherit version;

  src = fetchurl {
    urls = [
      "https://archive.mesa3d.org/mesa-${version}.tar.xz"
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
    ];
    inherit hash;
  };

  patches = [
    ./opencl.patch

    # Backport crash fix for Radeon (legacy) kernel driver
    # see https://gitlab.freedesktop.org/mesa/mesa/-/issues/10613
    # FIXME: remove when merged upstream
    ./backport-radeon-crash-fix.patch
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

  outputs = [ "out" "dev" "drivers" ]
    ++ lib.optional enableOSMesa "osmesa"
    ++ lib.optional stdenv.isLinux "driversdev"
    ++ lib.optional enableOpenCL "opencl"
    # the Dozen drivers depend on libspirv2dxil, but link it statically, and
    # libspirv2dxil itself is pretty chonky, so relocate it to its own output
    # in case anything wants to use it at some point
    ++ lib.optional haveDozen "spirv2dxil";

  # Keep build-ids so drivers can use them for caching, etc.
  # Also some drivers segfault without this.
  separateDebugInfo = true;

  # Needed to discover llvm-config for cross
  preConfigure = ''
    PATH=${llvmPackages.libllvm.dev}/bin:$PATH
  '';

  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "drivers"}/share" # Vendor files

    # Don't build in debug mode
    # https://gitlab.freedesktop.org/mesa/mesa/blob/master/docs/meson.html#L327
    "-Db_ndebug=true"

    "-Ddri-search-path=${libglvnd.driverLink}/lib/dri"

    "-Dplatforms=${lib.concatStringsSep "," eglPlatforms}"
    "-Dgallium-drivers=${lib.concatStringsSep "," galliumDrivers}"
    "-Dvulkan-drivers=${lib.concatStringsSep "," vulkanDrivers}"

    "-Ddri-drivers-path=${placeholder "drivers"}/lib/dri"
    "-Dvdpau-libs-path=${placeholder "drivers"}/lib/vdpau"
    "-Domx-libs-path=${placeholder "drivers"}/lib/bellagio"
    "-Dva-libs-path=${placeholder "drivers"}/lib/dri"
    "-Dd3d-drivers-path=${placeholder "drivers"}/lib/d3d"

    "-Dgallium-nine=${lib.boolToString enableGalliumNine}" # Direct3D in Wine
    "-Dosmesa=${lib.boolToString enableOSMesa}" # used by wine
    "-Dmicrosoft-clc=disabled" # Only relevant on Windows (OpenCL 1.2 API on top of D3D12)

    # To enable non-mesa gbm backends to be found (e.g. Nvidia)
    "-Dgbm-backends-path=${libglvnd.driverLink}/lib/gbm:${placeholder "out"}/lib/gbm"

    # meson auto_features enables these features, but we do not want them
    "-Dandroid-libbacktrace=disabled"

  ] ++ lib.optionals stdenv.isLinux [
    "-Dglvnd=true"

    # Enable RT for Intel hardware
    # https://gitlab.freedesktop.org/mesa/mesa/-/issues/9080
    (lib.mesonEnable "intel-clc" (stdenv.buildPlatform == stdenv.hostPlatform))
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable features that are explicitly unsupported on the platform
    "-Dgbm=disabled"
    "-Dxlib-lease=disabled"
    "-Degl=disabled"
    "-Dgallium-vdpau=disabled"
    "-Dgallium-va=disabled"
    "-Dgallium-xa=disabled"
    "-Dlmsensors=disabled"
  ] ++ lib.optionals enableOpenCL [
    # Clover, old OpenCL frontend
    "-Dgallium-opencl=icd"
    "-Dopencl-spirv=true"

    # Rusticl, new OpenCL frontend
    "-Dgallium-rusticl=true"
    "-Dclang-libdir=${llvmPackages.clang-unwrapped.lib}/lib"
  ]  ++ lib.optionals (!withValgrind) [
    "-Dvalgrind=disabled"
  ]  ++ lib.optionals (!withLibunwind) [
    "-Dlibunwind=disabled"
  ] ++ lib.optional enablePatentEncumberedCodecs
    "-Dvideo-codecs=all"
  ++ lib.optional (vulkanLayers != []) "-D vulkan-layers=${builtins.concatStringsSep "," vulkanLayers}";

  strictDeps = true;

  buildInputs = with xorg; [
    expat glslang llvmPackages.libllvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libXvMC
    libpthreadstubs openssl
    zstd
  ] ++ lib.optionals withLibunwind [
    libunwind
  ] ++ [
    python3Packages.python # for shebang
  ] ++ lib.optionals haveWayland [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ elfutils libomxil-bellagio libva-minimal udev lm_sensors ]
    ++ lib.optionals enableOpenCL [ llvmPackages.libclc llvmPackages.clang llvmPackages.clang-unwrapped spirv-llvm-translator ]
    ++ lib.optional withValgrind valgrind-light
    ++ lib.optional haveZink vulkan-loader
    ++ lib.optional haveDozen directx-headers;

  depsBuildBuild = [ pkg-config ]
    # Adding this unconditionally makes x86_64-darwin pick up an older toolchain, as
    # we explicitly call Mesa with 11.0 stdenv, but buildPackages is still 10.something,
    # and Mesa can't build with that.
    # FIXME: figure this out, or figure out how to get rid of Mesa on Darwin,
    # whichever is easier.
    ++ lib.optional (!stdenv.isDarwin) buildPackages.stdenv.cc;

  nativeBuildInputs = [
    meson pkg-config ninja
    intltool bison flex file
    python3Packages.python python3Packages.mako python3Packages.ply
    jdupes glslang
    rustc rust-bindgen rustPlatform.bindgenHook
  ] ++ lib.optional haveWayland wayland-scanner;

  propagatedBuildInputs = with xorg; [
    libXdamage libXxf86vm
  ] ++ lib.optional withLibdrm libdrm
    ++ lib.optionals stdenv.isDarwin [ OpenGL Xplugin ];

  doCheck = false;

  postInstall = ''
    # Some installs don't have any drivers so this directory is never created.
    mkdir -p $drivers $osmesa
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $drivers/lib

    if [ -n "$(shopt -s nullglob; echo "$out/lib/libxatracker"*)" -o -n "$(shopt -s nullglob; echo "$out/lib/libvulkan_"*)" ]; then
      # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
      mv -t $drivers/lib       \
        $out/lib/libpowervr_rogue* \
        $out/lib/libxatracker* \
        $out/lib/libvulkan_*
    fi

    if [ -n "$(shopt -s nullglob; echo "$out"/lib/lib*_mesa*)" ]; then
      # Move other drivers to a separate output
      mv -t $drivers/lib $out/lib/lib*_mesa*
    fi

    # Update search path used by glvnd
    for js in $drivers/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace '"libEGL_' '"'"$drivers/lib/libEGL_"
    done

    # Update search path used by Vulkan (it's pointing to $out but
    # drivers are in $drivers)
    for js in $drivers/share/vulkan/icd.d/*.json; do
      substituteInPlace "$js" --replace "$out" "$drivers"
    done
  '' + lib.optionalString enableOpenCL ''
    # Move OpenCL stuff
    mkdir -p $opencl/lib
    mv -t "$opencl/lib/"     \
      $out/lib/gallium-pipe   \
      $out/lib/lib*OpenCL*

    # We construct our own .icd files that contain absolute paths.
    mkdir -p $opencl/etc/OpenCL/vendors/
    echo $opencl/lib/libMesaOpenCL.so > $opencl/etc/OpenCL/vendors/mesa.icd
    echo $opencl/lib/libRusticlOpenCL.so > $opencl/etc/OpenCL/vendors/rusticl.icd
  '' + lib.optionalString enableOSMesa ''
    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p $osmesa/lib
    mv -t $osmesa/lib/ $out/lib/libOSMesa*
  '' + lib.optionalString (vulkanLayers != []) ''
    mv -t $drivers/lib $out/lib/libVkLayer*
    for js in $drivers/share/vulkan/{im,ex}plicit_layer.d/*.json; do
      substituteInPlace "$js" --replace '"libVkLayer_' '"'"$drivers/lib/libVkLayer_"
    done
  '' + lib.optionalString haveDozen ''
    mkdir -p $spirv2dxil/{bin,lib}
    mv -t $spirv2dxil/lib $out/lib/libspirv_to_dxil*
    mv -t $spirv2dxil/bin $out/bin/spirv2dxil
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
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
    ${lib.optionalString haveZink ''
      patchelf --add-rpath ${vulkan-loader}/lib $drivers/lib/dri/zink_dri.so
    ''}
  '';

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [ "-fno-common" ] ++ lib.optionals enableOpenCL [
    "-UPIPE_SEARCH_DIR"
    "-DPIPE_SEARCH_DIR=\"${placeholder "opencl"}/lib/gallium-pipe\""
  ]);

  passthru = {
    inherit (libglvnd) driverLink;
    inherit llvmPackages;

    libdrm = if withLibdrm then libdrm else null;

    tests = lib.optionalAttrs stdenv.isLinux {
      devDoesNotDependOnLLVM = stdenv.mkDerivation {
        name = "mesa-dev-does-not-depend-on-llvm";
        buildCommand = ''
          echo ${self.dev} >>$out
        '';
        disallowedRequisites = [ llvmPackages.llvm self.drivers ];
      };
    };
  };

  meta = with lib; {
    description = "An open source 3D graphics library";
    longDescription = ''
      The Mesa project began as an open-source implementation of the OpenGL
      specification - a system for rendering interactive 3D graphics. Over the
      years the project has grown to implement more graphics APIs, including
      OpenGL ES (versions 1, 2, 3), OpenCL, OpenMAX, VDPAU, VA API, XvMC, and
      Vulkan.  A variety of device drivers allows the Mesa libraries to be used
      in many different environments ranging from software emulation to
      complete hardware acceleration for modern GPUs.
    '';
    homepage = "https://www.mesa3d.org/";
    changelog = "https://www.mesa3d.org/relnotes/${version}.html";
    license = licenses.mit; # X11 variant, in most files
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ primeos vcunat ]; # Help is welcome :)
  };
};

in self
