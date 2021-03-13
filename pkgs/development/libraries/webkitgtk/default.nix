{ lib, stdenv
, fetchurl
, perl
, fetchpatch
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
, libintl
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
  version = "2.30.5";

  outputs = [ "out" "dev" ];

  separateDebugInfo = stdenv.hostPlatform.isLinux;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "07vzbbnvz69rn9pciji4axfpclp98bpj4a0br2z0gbn5wc4an3bx";
  };

  patches = optionals stdenv.hostPlatform.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
    ./libglvnd-headers.patch
    ./darwin/patch-WTF-wtf-Randomdevice.diff
    ./darwin/patch-WTF-wtf-spi-darwin-ProcessMemoryFootprint-h.diff
    ./darwin/patch-Webcore-page-crypto.diff
    ./darwin/patch-bundle-link-webcore.diff
    ./darwin/patch-enable-plugin-architecture-unix.diff
    ./darwin/patch-ramsize.diff
    ./darwin/patch-snowleopard-cmakelists-stdcformatmacros.diff
    ./darwin/patch-source-wtf-wtf-osallocatorposix-cpp-map-jit.diff
    ./darwin/patch-source-wtf-wtf-unix-cputimeunix-cpp-darwin-version-restore.diff
    ./darwin/patch-sources-gtk.diff
    ./darwin/patch-web-process-main.diff
    ./darwin/patch-webcore-platform-audio-directconvolver-disable-veclib.diff
    ./darwin/patch-webkit2gtk-272-macports.diff
    ./darwin/patch-webkit2gtk-macports.diff
    ./darwin/patch-webkit2gtk-source-javascriptcore-jit-executableallocator-missingfcntl-h-older-systems.diff
    ./darwin/process-executable-path.diff
  # ];
  ] ++ optional stdenv.hostPlatform.isDarwin [
     (fetchpatch {
       name = "use_apple_icu_as_fallback.patch";
       url = "https://bug-220081-attachments.webkit.org/attachment.cgi?id=416707&action=diff&format=raw";
       excludes = [ "ChangeLog" "Source/WTF/ChangeLog" ];
       sha256 = "000was24gskf3m1i23rx6k98vn77n4d49qr54rdf2nb1b1fjmf42";
     })
   ]
  ;

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
  ]) ++ optionals stdenv.hostPlatform.isDarwin [
    libedit
    readline
  ] ++ optionals stdenv.isLinux [
    libwpe
    libwpe-fdo
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
    "-DENABLE_GRAPHICS_CONTEXT_GL=OFF"
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
    "-DUSE_SYSTEMD=OFF"
    "-DUSE_APPLE_ICU=OFF"
    "-DENABLE_WEB_CRYPTO=OFF"
  ] ++ optional (stdenv.hostPlatform.isLinux && enableGLES) "-DENABLE_GLES2=ON";

  postPatch = ''
    patchShebangs .
  '' + '' 
     sed -i '1i#include<malloc/malloc.h>' Source/WTF/wtf/FastMalloc.cpp
   '';

  meta = {
    description = "Web content rendering engine, GTK port";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = teams.gnome.members;
  };
}
