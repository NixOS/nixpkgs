{ stdenv, lib, fetchurl, fetchpatch
, meson, pkg-config, ninja
, intltool, bison, flex, file, python3Packages, wayland-scanner
, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages_15, libffi, libomxil-bellagio, libva-minimal
, libelf, libvdpau
, libglvnd, libunwind, lm_sensors
, vulkan-loader, glslang
, galliumDrivers ?
  if stdenv.isLinux then
    [
      "d3d12" # WSL emulated GPU (aka Dozen)
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
      "swrast" # software renderer (aka Lavapipe)
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch -> lib.versionAtLeast stdenv.hostPlatform.parsed.cpu.version "6") [
      # QEMU virtualized GPU (aka VirGL)
      # Requires ATOMIC_INT_LOCK_FREE == 2.
      "virtio-experimental"
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
, enableGalliumNine ? stdenv.isLinux
, enableOSMesa ? stdenv.isLinux
, enableOpenCL ? stdenv.isLinux && stdenv.isx86_64
, enablePatentEncumberedCodecs ? true
, libclc
, jdupes
, rustc
, rust-bindgen
, spirv-llvm-translator
, zstd
, directx-headers
, udev
}:

/** Packaging design:
  - The basic mesa ($out) contains headers and libraries (GLU is in libGLU now).
    This or the mesa attribute (which also contains GLU) are small (~ 2 MB, mostly headers)
    and are designed to be the buildInput of other packages.
  - DRI drivers are compiled into $drivers output, which is much bigger and
    depends on LLVM. These should be searched at runtime in
    "/run/opengl-driver{,-32}/lib/*" and so are kind-of impure (given by NixOS).
    (I suppose on non-NixOS one would create the appropriate symlinks from there.)
  - libOSMesa is in $osmesa (~4 MB)
*/

let
  version = "23.1.5";
  hash = "sha256-PPiFdv3r8k/EBHBnk2ExyQy2VBwnNlmWt5tmHewfsVM=";

  # Release calendar: https://www.mesa3d.org/release-calendar.html
  # Release frequency: https://www.mesa3d.org/releasing.html#schedule
  branch = lib.versions.major version;

  withLibdrm = lib.meta.availableOn stdenv.hostPlatform libdrm;

  llvmPackages = llvmPackages_15;
  # Align all the Mesa versions used. Required to prevent explosions when
  # two different LLVMs are loaded in the same process.
  # FIXME: these should really go into some sort of versioned LLVM package set
  rust-bindgen' = rust-bindgen.override {
    rust-bindgen-unwrapped = rust-bindgen.unwrapped.override {
      clang = llvmPackages.clang;
    };
  };
  spirv-llvm-translator' = spirv-llvm-translator.override {
    inherit (llvmPackages) llvm;
  };

  haveWayland = lib.elem "wayland" eglPlatforms;
  haveZink = lib.elem "zink" galliumDrivers;
  haveDozen = (lib.elem "d3d12" galliumDrivers) || (lib.elem "microsoft-experimental" vulkanDrivers);
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

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    # fixes pkgsMusl.mesa build
    ./musl.patch

    ./opencl.patch
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
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
  '';

  outputs = [ "out" "dev" "drivers" ]
    ++ lib.optional enableOSMesa "osmesa"
    ++ lib.optional stdenv.isLinux "driversdev"
    ++ lib.optional enableOpenCL "opencl"
    # the Dozen drivers depend on libspirv2dxil, but link it statically, and
    # libspirv2dxil itself is pretty chonky, so relocate it to its own output
    # in case anything wants to use it at some point
    ++ lib.optional haveDozen "spirv2dxil";

  # FIXME: this fixes rusticl/iris segfaulting on startup, _somehow_.
  # Needs more investigating.
  separateDebugInfo = true;

  preConfigure = ''
    PATH=${llvmPackages.libllvm.dev}/bin:$PATH
  '';

  # TODO: Figure out how to enable opencl without having a runtime dependency on clang
  mesonFlags = [
    "--sysconfdir=/etc"
    "--datadir=${placeholder "drivers"}/share" # Vendor files

    # Don't build in debug mode
    # https://gitlab.freedesktop.org/mesa/mesa/blob/master/docs/meson.html#L327
    "-Db_ndebug=true"

    "-Ddisk-cache-key=${placeholder "drivers"}"
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
    "-Dintel-clc=enabled"
  ] ++ lib.optionals enableOpenCL [
    # Clover, old OpenCL frontend
    "-Dgallium-opencl=icd"
    "-Dopencl-spirv=true"

    # Rusticl, new OpenCL frontend
    "-Dgallium-rusticl=true" "-Drust_std=2021"
    "-Dclang-libdir=${llvmPackages.clang-unwrapped.lib}/lib"
  ]  ++ lib.optionals (!withValgrind) [
    "-Dvalgrind=disabled"
  ] ++ lib.optional enablePatentEncumberedCodecs
    "-Dvideo-codecs=h264dec,h264enc,h265dec,h265enc,vc1dec"
  ++ lib.optional (vulkanLayers != []) "-D vulkan-layers=${builtins.concatStringsSep "," vulkanLayers}";

  buildInputs = with xorg; [
    expat llvmPackages.libllvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libelf libXvMC
    libpthreadstubs openssl /*or another sha1 provider*/
    zstd libunwind
  ] ++ lib.optionals haveWayland [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ libomxil-bellagio libva-minimal udev lm_sensors ]
    ++ lib.optionals enableOpenCL [ libclc llvmPackages.clang llvmPackages.clang-unwrapped rustc rust-bindgen' spirv-llvm-translator' ]
    ++ lib.optional withValgrind valgrind-light
    ++ lib.optional haveZink vulkan-loader
    ++ lib.optional haveDozen directx-headers;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson pkg-config ninja
    intltool bison flex file
    python3Packages.python python3Packages.mako python3Packages.ply
    jdupes glslang
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
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace "$drivers" "${libglvnd.driverLink}"
    [ -f "$dev/lib/pkgconfig/d3d.pc" ] && substituteInPlace "$dev/lib/pkgconfig/d3d.pc" --replace "$drivers" "${libglvnd.driverLink}"

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

    # https://gitlab.freedesktop.org/mesa/mesa/-/issues/8634
    broken = stdenv.isDarwin;
  };
};

in self
