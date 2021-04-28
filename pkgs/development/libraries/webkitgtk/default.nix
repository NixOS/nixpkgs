{ lib, stdenv
, fetchurl
, perl
, python3
, ruby
, bison
, gperf
, cmake
, ninja
, pkg-config
, gettext
, gobject-introspection
, libnotify
, gnutls
, libgcrypt
, gtk3
, wayland
, libwebp
, enchant2
, xorg
, libxkbcommon
, epoxy
, at-spi2-core
, libxml2
, libsoup
, libsecret
, libxslt
, harfbuzz
, libpthreadstubs
, pcre
, nettle
, libtasn1
, p11-kit
, libidn
, libedit
, readline
, libGL
, libGLU
, mesa
, libintl
, libmanette
, openjpeg
, enableGeoLocation ? true
, geoclue2
, sqlite
, enableGLES ? true
, gst-plugins-base
, gst-plugins-bad
, woff2
, bubblewrap
, libseccomp
, systemd
, xdg-dbus-proxy
, substituteAll
, glib
}:

assert enableGeoLocation -> geoclue2 != null;

with lib;

stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.32.0";

  outputs = [ "out" "dev" ];

  separateDebugInfo = stdenv.isLinux;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1w3b0w8izp0i070grhv19j631sdcd0mcqnjnax13k8mdx7dg8zcx";
  };

  patches = optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
    ./libglvnd-headers.patch
  ];

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # Ignore gettext in cmake_prefix_path so that find_program doesn't
    # pick up the wrong gettext. TODO: Find a better solution for
    # this, maybe make cmake not look up executables in
    # CMAKE_PREFIX_PATH.
    cmakeFlags+=" -DCMAKE_IGNORE_PATH=${getBin gettext}/bin"
  '';

  nativeBuildInputs = [
    bison
    cmake
    gettext
    gobject-introspection
    gperf
    ninja
    perl
    pkg-config
    python3
    ruby
    glib # for gdbus-codegen
  ] ++ lib.optionals stdenv.isLinux [
    wayland # for wayland-scanner
  ];

  buildInputs = [
    at-spi2-core
    enchant2
    epoxy
    gnutls
    gst-plugins-bad
    gst-plugins-base
    harfbuzz
    libGL
    libGLU
    mesa # for libEGL headers
    libgcrypt
    libidn
    libintl
    libmanette
    libnotify
    libpthreadstubs
    libsecret
    libtasn1
    libwebp
    libxkbcommon
    libxml2
    libxslt
    nettle
    openjpeg
    p11-kit
    pcre
    sqlite
    woff2
  ] ++ (with xorg; [
    libXdamage
    libXdmcp
    libXt
    libXtst
  ]) ++ optionals stdenv.isDarwin [
    libedit
    readline
  ] ++ optionals stdenv.isLinux [
    bubblewrap
    libseccomp
    systemd
    wayland
    xdg-dbus-proxy
  ] ++ optional enableGeoLocation geoclue2;

  propagatedBuildInputs = [
    gtk3
    libsoup
  ];

  cmakeFlags = [
    "-DENABLE_INTROSPECTION=ON"
    "-DPORT=GTK"
    "-DUSE_LIBHYPHEN=OFF"
    "-DUSE_WPE_RENDERER=OFF"
  ] ++ optionals stdenv.isDarwin [
    "-DENABLE_GRAPHICS_CONTEXT_3D=OFF"
    "-DENABLE_GTKDOC=OFF"
    "-DENABLE_MINIBROWSER=OFF"
    "-DENABLE_OPENGL=OFF"
    "-DENABLE_QUARTZ_TARGET=ON"
    "-DENABLE_VIDEO=ON"
    "-DENABLE_WEBGL=OFF"
    "-DENABLE_WEB_AUDIO=OFF"
    "-DENABLE_X11_TARGET=OFF"
    "-DUSE_ACCELERATE=0"
    "-DUSE_SYSTEM_MALLOC=ON"
  ] ++ optional (stdenv.isLinux && enableGLES) "-DENABLE_GLES2=ON";

  postPatch = ''
    patchShebangs .
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Web content rendering engine, GTK port";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = teams.gnome.members;
  };
}
