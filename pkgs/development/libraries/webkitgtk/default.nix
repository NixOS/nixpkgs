{ stdenv
, fetchurl
, perl
, python3
, ruby
, bison
, gperf
, cmake
, ninja
, pkgconfig
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
, libintl
, openjpeg
, enableGeoLocation ? true
, geoclue2
, sqlite
, enableGtk2Plugins ? false
, gtk2 ? null
, gst-plugins-base
, gst-plugins-bad
, woff2
, bubblewrap
, libseccomp
, xdg-dbus-proxy
, substituteAll
, gnome3
}:

assert enableGeoLocation -> geoclue2 != null;
assert enableGtk2Plugins -> gtk2 != null;
assert stdenv.isDarwin -> !enableGtk2Plugins;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.26.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0gqi9f9njrdn8vad1zvr59b25arwc8r0n8bp25sgkbfz2c3r11j3";
  };

  patches = optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
    ./libglvnd-headers.patch
  ];

  nativeBuildInputs = [
    bison
    cmake
    gettext
    gobject-introspection
    gperf
    ninja
    perl
    pkgconfig
    python3
    ruby
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
    libgcrypt
    libidn
    libintl
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
    wayland
    xdg-dbus-proxy
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2;

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
  ] ++ optional (!enableGtk2Plugins) "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
    ++ optional stdenv.isLinux "-DENABLE_GLES2=ON";

  postPatch = ''
    patchShebangs .
  '';

  meta = {
    description = "Web content rendering engine, GTK port";
    homepage = https://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = gnome3.maintainers;
  };
}
