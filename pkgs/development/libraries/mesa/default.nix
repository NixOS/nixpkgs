{ stdenv, lib, fetchurl, fetchpatch, buildPackages
, meson, pkg-config, ninja
, intltool, bison, flex, file, python3Packages, wayland-scanner
, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages, libffi, libomxil-bellagio, libva-minimal
, libelf, libvdpau
, libglvnd, libunwind
, vulkan-loader
, galliumDrivers ? ["auto"]
, vulkanDrivers ? ["auto"]
, eglPlatforms ? [ "x11" ] ++ lib.optionals stdenv.isLinux [ "wayland" ]
, OpenGL, Xplugin
, withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light && !valgrind-light.meta.broken, valgrind-light
, enableGalliumNine ? stdenv.isLinux
, enableOSMesa ? stdenv.isLinux
, enableOpenCL ? stdenv.isLinux && stdenv.isx86_64
, libclc
, jdupes
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

with lib;

let
  # Release calendar: https://www.mesa3d.org/release-calendar.html
  # Release frequency: https://www.mesa3d.org/releasing.html#schedule
  version = "22.1.6";
  branch  = versions.major version;

self = stdenv.mkDerivation {
  pname = "mesa";
  inherit version;

  src = fetchurl {
    urls = [
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
    ];
    sha256 = "22ced061eb9adab8ea35368246c1995c09723f3f71653cd5050c5cec376e671a";
  };

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    # fixes pkgsMusl.mesa build
    ./musl.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/b9f58f303ae23754c95d5d1fe87a98b5a2d8f271/srcpkgs/mesa/patches/musl-endian.patch";
      hash = "sha256-eRc91qCaFlVzrxFrNUPpAHd1gsqKsLCCN0IW8pBQcqk=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/b9f58f303ae23754c95d5d1fe87a98b5a2d8f271/srcpkgs/mesa/patches/musl-stacksize.patch";
      hash = "sha256-bEp0AWddsw1Pc3rxdKN8fsrX4x2TQEzMUa5afhLXGsg=";
    })

    ./opencl.patch
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
  ] ++ optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fix aarch64-darwin build, remove when upstreaam supports it out of the box.
    # See: https://gitlab.freedesktop.org/mesa/mesa/-/issues/1020
    ./aarch64-darwin.patch
  ] ++ optionals stdenv.isDarwin [
    # 22.1 on darwin won't build: https://gitlab.freedesktop.org/mesa/mesa/-/issues/6519
    # (already in-tree for 22.2)
    ./drop-dri2.patch
  ];

  postPatch = ''
    patchShebangs .

    # The drirc.d directory cannot be installed to $drivers as that would cause a cyclic dependency:
    substituteInPlace src/util/xmlconfig.c --replace \
      'DATADIR "/drirc.d"' '"${placeholder "out"}/share/drirc.d"'
    substituteInPlace src/util/meson.build --replace \
      "get_option('datadir')" "'${placeholder "out"}/share'"
  '';

  outputs = [ "out" "dev" "drivers" ]
    ++ lib.optional enableOSMesa "osmesa"
    ++ lib.optional stdenv.isLinux "driversdev"
    ++ lib.optional enableOpenCL "opencl";

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

    "-Dplatforms=${concatStringsSep "," eglPlatforms}"
    "-Dgallium-drivers=${concatStringsSep "," galliumDrivers}"
    "-Dvulkan-drivers=${concatStringsSep "," vulkanDrivers}"

    "-Ddri-drivers-path=${placeholder "drivers"}/lib/dri"
    "-Dvdpau-libs-path=${placeholder "drivers"}/lib/vdpau"
    "-Dxvmc-libs-path=${placeholder "drivers"}/lib"
    "-Domx-libs-path=${placeholder "drivers"}/lib/bellagio"
    "-Dva-libs-path=${placeholder "drivers"}/lib/dri"
    "-Dd3d-drivers-path=${placeholder "drivers"}/lib/d3d"
    "-Dgallium-nine=${boolToString enableGalliumNine}" # Direct3D in Wine
    "-Dosmesa=${boolToString enableOSMesa}" # used by wine
    "-Dmicrosoft-clc=disabled" # Only relevant on Windows (OpenCL 1.2 API on top of D3D12)

    # To enable non-mesa gbm backends to be found (e.g. Nvidia)
    "-Dgbm-backends-path=${libglvnd.driverLink}/lib/gbm:${placeholder "out"}/lib/gbm"
  ] ++ optionals stdenv.isLinux [
    "-Dglvnd=true"
  ] ++ optionals enableOpenCL [
    "-Dgallium-opencl=icd" # Enable the gallium OpenCL frontend
    "-Dclang-libdir=${llvmPackages.clang-unwrapped.lib}/lib"
  ];

  buildInputs = with xorg; [
    expat llvmPackages.libllvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libelf libXvMC
    libpthreadstubs openssl /*or another sha1 provider*/
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ libomxil-bellagio libva-minimal ]
    ++ lib.optionals stdenv.isDarwin [ libunwind ]
    ++ lib.optionals enableOpenCL [ libclc llvmPackages.clang llvmPackages.clang-unwrapped ]
    ++ lib.optional withValgrind valgrind-light
    # Mesa will not build zink when gallium-drivers=auto
    ++ lib.optional (elem "zink" galliumDrivers) vulkan-loader;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson pkg-config ninja
    intltool bison flex file
    python3Packages.python python3Packages.Mako
    jdupes
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [
    wayland-scanner
  ];

  propagatedBuildInputs = with xorg; [
    libXdamage libXxf86vm
  ] ++ optional stdenv.isLinux libdrm
    ++ optionals stdenv.isDarwin [ OpenGL Xplugin ];

  doCheck = false;

  postInstall = ''
    # Some installs don't have any drivers so this directory is never created.
    mkdir -p $drivers $osmesa
  '' + optionalString stdenv.isLinux ''
    mkdir -p $drivers/lib

    if [ -n "$(shopt -s nullglob; echo "$out/lib/libxatracker"*)" -o -n "$(shopt -s nullglob; echo "$out/lib/libvulkan_"*)" ]; then
      # move gallium-related stuff to $drivers, so $out doesn't depend on LLVM
      mv -t $drivers/lib       \
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
  '' + optionalString enableOpenCL ''
    # Move OpenCL stuff
    mkdir -p $opencl/lib
    mv -t "$opencl/lib/"     \
      $out/lib/gallium-pipe   \
      $out/lib/libMesaOpenCL*

    # We construct our own .icd file that contains an absolute path.
    rm -r $out/etc/OpenCL
    mkdir -p $opencl/etc/OpenCL/vendors/
    echo $opencl/lib/libMesaOpenCL.so > $opencl/etc/OpenCL/vendors/mesa.icd
  '' + lib.optionalString enableOSMesa ''
    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p $osmesa/lib
    mv -t $osmesa/lib/ $out/lib/libOSMesa*
  '';

  postFixup = optionalString stdenv.isLinux ''
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
  '';

  NIX_CFLAGS_COMPILE = optionals stdenv.isDarwin [ "-fno-common" ] ++ lib.optionals enableOpenCL [
    "-UPIPE_SEARCH_DIR"
    "-DPIPE_SEARCH_DIR=\"${placeholder "opencl"}/lib/gallium-pipe\""
  ];

  passthru = {
    inherit libdrm;
    inherit (libglvnd) driverLink;
    inherit llvmPackages;

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

  meta = {
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
