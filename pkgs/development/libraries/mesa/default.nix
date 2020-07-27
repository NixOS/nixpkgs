{ stdenv, lib, fetchurl, fetchpatch, buildPackages
, pkgconfig, intltool, ninja, meson
, file, flex, bison, expat, libdrm, xorg, wayland, wayland-protocols, openssl
, llvmPackages, libffi, libomxil-bellagio, libva-minimal
, libelf, libvdpau, python3Packages
, libglvnd
, enableRadv ? true
, galliumDrivers ? ["auto"]
, driDrivers ? ["auto"]
, vulkanDrivers ? ["auto"]
, eglPlatforms ? [ "x11" "surfaceless" ] ++ lib.optionals stdenv.isLinux [ "wayland" "drm" ]
, OpenGL, Xplugin
, withValgrind ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAarch32, valgrind-light
, enableGalliumNine ? stdenv.isLinux
, enableOSMesa ? stdenv.isLinux
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

with stdenv.lib;

let
  # Release calendar: https://www.mesa3d.org/release-calendar.html
  # Release frequency: https://www.mesa3d.org/releasing.html#schedule
  version = "20.1.4";
  branch  = versions.major version;
in

stdenv.mkDerivation {
  pname = "mesa";
  inherit version;

  src = fetchurl {
    urls = [
      "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
      "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
    ];
    sha256 = "1zlrczmmkcy42w332rfmlicihlnrxmkrnkpb21sl98725cf2f038";
  };

  prePatch = "patchShebangs .";

  # TODO:
  #  revive ./dricore-gallium.patch when it gets ported (from Ubuntu), as it saved
  #  ~35 MB in $drivers; watch https://launchpad.net/ubuntu/+source/mesa/+changelog
  patches = [
    ./missing-includes.patch # dev_t needs sys/stat.h, time_t needs time.h, etc.-- fixes build w/musl
    ./opencl-install-dir.patch
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
    ./link-radv-with-ld_args_build_id.patch
  ] # do not prefix user provided dri-drivers-path
    ++ lib.optional (lib.versionOlder version "19.0.0") (fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/mesa/commit/f6556ec7d126b31da37c08d7cb657250505e01a0.patch";
      sha256 = "0z6phi8hbrbb32kkp1js7ggzviq7faz1ria36wi4jbc4in2392d9";
    })
    ++ lib.optionals (lib.versionOlder version "19.1.0") [
      # do not prefix user provided d3d-drivers-path
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/dcc48664197c7e44684ccfb970a4ae083974d145.patch";
        sha256 = "1nhs0xpx3hiy8zfb5gx1zd7j7xha6h0hr7yingm93130a5902lkb";
      })

      # don't build libGLES*.so with GLVND
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/b01524fff05eef66e8cd24f1c5aacefed4209f03.patch";
        sha256 = "1pszr6acx2xw469zq89n156p3bf3xf84qpbjw5fr1sj642lbyh7c";
      })
    ];

  postPatch = ''
    substituteInPlace meson.build --replace \
      "find_program('pkg-config')" \
      "find_program('${buildPackages.pkg-config.targetPrefix}pkg-config')"
  '';

  outputs = [ "out" "dev" "drivers" ] ++ lib.optional enableOSMesa "osmesa";

  # TODO: Figure out how to enable opencl without having a runtime dependency on clang
  mesonFlags = [
    "--sysconfdir=/etc"

    # Don't build in debug mode
    # https://gitlab.freedesktop.org/mesa/mesa/blob/master/docs/meson.html#L327
    "-Db_ndebug=true"

    "-Ddisk-cache-key=${placeholder "drivers"}"
    "-Ddri-search-path=${libglvnd.driverLink}/lib/dri"

    "-Dplatforms=${concatStringsSep "," eglPlatforms}"
    "-Ddri-drivers=${concatStringsSep "," driDrivers}"
    "-Dgallium-drivers=${concatStringsSep "," galliumDrivers}"
    "-Dvulkan-drivers=${concatStringsSep "," vulkanDrivers}"

    "-Ddri-drivers-path=${placeholder "drivers"}/lib/dri"
    "-Dvdpau-libs-path=${placeholder "drivers"}/lib/vdpau"
    "-Dxvmc-libs-path=${placeholder "drivers"}/lib"
    "-Domx-libs-path=${placeholder "drivers"}/lib/bellagio"
    "-Dva-libs-path=${placeholder "drivers"}/lib/dri"
    "-Dd3d-drivers-path=${placeholder "drivers"}/lib/d3d"
    "-Dgallium-nine=${if enableGalliumNine then "true" else "false"}" # Direct3D in Wine
    "-Dosmesa=${if enableOSMesa then "gallium" else "none"}" # used by wine
  ] ++ optionals stdenv.isLinux [
    "-Dglvnd=true"
  ];

  buildInputs = with xorg; [
    expat llvmPackages.llvm libglvnd xorgproto
    libX11 libXext libxcb libXt libXfixes libxshmfence libXrandr
    libffi libvdpau libelf libXvMC
    libpthreadstubs openssl /*or another sha1 provider*/
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [ wayland wayland-protocols ]
    ++ lib.optionals stdenv.isLinux [ libomxil-bellagio libva-minimal ]
    ++ lib.optional withValgrind valgrind-light;

  depsBuildBuild = [ pkgconfig ];

  nativeBuildInputs = [
    pkgconfig meson ninja
    intltool bison flex file
    python3Packages.python python3Packages.Mako
  ] ++ lib.optionals (elem "wayland" eglPlatforms) [
    wayland # For wayland-scanner during the build
  ];

  propagatedBuildInputs = with xorg; [
    libXdamage libXxf86vm
  ] ++ optional stdenv.isLinux libdrm
    ++ optionals stdenv.isDarwin [ OpenGL Xplugin ];

  enableParallelBuilding = true;
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
      mv $out/lib/lib*_mesa* $drivers/lib
    fi

    # move vendor files
    mv $out/share/ $drivers/

    # Update search path used by glvnd
    for js in $drivers/share/glvnd/egl_vendor.d/*.json; do
      substituteInPlace "$js" --replace '"libEGL_' '"'"$drivers/lib/libEGL_"
    done

    # Update search path used by Vulkan (it's pointing to $out but
    # drivers are in $drivers)
    for js in $drivers/share/vulkan/icd.d/*.json; do
      substituteInPlace "$js" --replace "$out" "$drivers"
    done
  '' + lib.optionalString enableOSMesa ''
    # move libOSMesa to $osmesa, as it's relatively big
    mkdir -p $osmesa/lib
    mv -t $osmesa/lib/ $out/lib/libOSMesa*
  '';

  # TODO:
  #  check $out doesn't depend on llvm: builder failures are ignored
  #  for some reason grep -qv '${llvmPackages.llvm}' -R "$out";
  postFixup = optionalString stdenv.isLinux ''
    # set the default search path for DRI drivers; used e.g. by X server
    substituteInPlace "$dev/lib/pkgconfig/dri.pc" --replace "$drivers" "${libglvnd.driverLink}"

    # remove pkgconfig files for GL/EGL; they are provided by libGL.
    rm -f $dev/lib/pkgconfig/{gl,egl}.pc

    # Update search path used by pkg-config
    for pc in $dev/lib/pkgconfig/{d3d,dri,xatracker}.pc; do
      if [ -f "$pc" ]; then
        substituteInPlace "$pc" --replace $out $drivers
      fi
    done

    # add RPATH so the drivers can find the moved libgallium and libdricore9
    # moved here to avoid problems with stripping patchelfed files
    for lib in $drivers/lib/*.so* $drivers/lib/*/*.so*; do
      if [[ ! -L "$lib" ]]; then
        patchelf --set-rpath "$(patchelf --print-rpath $lib):$drivers/lib" "$lib"
      fi
    done
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-fno-common";

  passthru = {
    inherit libdrm;
    inherit (libglvnd) driverLink;
  };

  meta = with stdenv.lib; {
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
}
