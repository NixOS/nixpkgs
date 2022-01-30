{ lib, stdenv
, runCommand
, fetchurl
, fetchpatch
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
, libgpg-error
, gtk3
, wayland
, libwebp
, enchant2
, xorg
, libxkbcommon
, libepoxy
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
, apple_sdk
, libGL
, libGLU
, mesa
, libintl
, lcms2
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
, addOpenGLRunpath
}:

assert enableGeoLocation -> geoclue2 != null;

stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.34.4";

  outputs = [ "out" "dev" ];

  separateDebugInfo = stdenv.isLinux;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-l19QGRmbp2mRkYNc914BoYuU47zQEH2nOJ1N3LGrpAY=";
  };

  patches = lib.optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
      inherit (addOpenGLRunpath) driverLink;
    })
    ./libglvnd-headers.patch

    # Pull upstream patches for missing includes on gcc-12:
    #  https://trac.webkit.org/changeset/288379/webkit
    (fetchpatch {
      name = "exchange-gcc-12.patch";
      url  = "https://github.com/WebKit/WebKit/commit/198b392130b8dd625f4d5d36e652954eececb16b.patch";
      excludes = [
        "Source/JavaScriptCore/ChangeLog"
        "Source/WTF/ChangeLog"
        "Source/WebCore/ChangeLog"
        "Tools/ChangeLog"

        "Tools/ImageDiff/ImageDiff.cpp"
      ];
      sha256 = "sha256-D+wxfM8AEMBfvpghrwa5v9cYLyK5+Sab3J0RE/xVar8=";
    })
    (fetchpatch {
      name = "string-gcc-12.patch";
      url  = "https://github.com/WebKit/WebKit/commit/4e3fade6bd89347e041a1938d4ea85fee14e5534.patch";
      excludes = [
        "Source/WTF/ChangeLog"
      ];
      sha256 = "sha256-NPqZLfMUR6InQuqfVwNoZwuM3Jtbz5KAbm9SUBaprmc=";
    })
  ];

  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    # Ignore gettext in cmake_prefix_path so that find_program doesn't
    # pick up the wrong gettext. TODO: Find a better solution for
    # this, maybe make cmake not look up executables in
    # CMAKE_PREFIX_PATH.
    cmakeFlags+=" -DCMAKE_IGNORE_PATH=${lib.getBin gettext}/bin"
  '';

  nativeBuildInputs = [
    bison
    cmake
    gettext
    gobject-introspection
    gperf
    ninja
    perl
    perl.pkgs.FileCopyRecursive # used by copy-user-interface-resources.pl
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
    libepoxy
    gnutls
    gst-plugins-bad
    gst-plugins-base
    harfbuzz
    libGL
    libGLU
    mesa # for libEGL headers
    libgcrypt
    libgpg-error
    libidn
    libintl
    lcms2
  ] ++ lib.optionals stdenv.isLinux [
    libmanette
  ] ++ [
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
  ]) ++ lib.optionals stdenv.isDarwin [
    libedit
    readline
  ] ++ lib.optional (stdenv.isDarwin && !stdenv.isAarch64) (
    # Pull a header that contains a definition of proc_pid_rusage().
    # (We pick just that one because using the other headers from `sdk` is not
    # compatible with our C++ standard library. This header is already in
    # the standard library on aarch64)
    runCommand "${pname}_headers" {} ''
      install -Dm444 "${lib.getDev apple_sdk.sdk}"/include/libproc.h "$out"/include/libproc.h
    ''
  ) ++ lib.optionals stdenv.isLinux [
    bubblewrap
    libseccomp
    systemd
    wayland
    xdg-dbus-proxy
  ] ++ lib.optional enableGeoLocation geoclue2;

  propagatedBuildInputs = [
    gtk3
    libsoup
  ];

  cmakeFlags = [
    "-DENABLE_INTROSPECTION=ON"
    "-DPORT=GTK"
    "-DUSE_LIBHYPHEN=OFF"
    "-DUSE_WPE_RENDERER=OFF"
    "-DUSE_SOUP2=${if lib.versions.major libsoup.version == "2" then "ON" else "OFF"}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DENABLE_GAMEPAD=OFF"
    "-DENABLE_GTKDOC=OFF"
    "-DENABLE_MINIBROWSER=OFF"
    "-DENABLE_QUARTZ_TARGET=ON"
    "-DENABLE_VIDEO=ON"
    "-DENABLE_WEBGL=OFF"
    "-DENABLE_WEB_AUDIO=OFF"
    "-DENABLE_X11_TARGET=OFF"
    "-DUSE_APPLE_ICU=OFF"
    "-DUSE_OPENGL_OR_ES=OFF"
    "-DUSE_SYSTEM_MALLOC=ON"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-DUSE_SYSTEMD=OFF"
  ] ++ lib.optional (stdenv.isLinux && enableGLES) "-DENABLE_GLES2=ON";

  postPatch = ''
    patchShebangs .
  '' + lib.optionalString stdenv.isDarwin ''
    # It needs malloc_good_size.
    sed 22i'#include <malloc/malloc.h>' -i Source/WTF/wtf/FastMalloc.h
    # <CommonCrypto/CommonRandom.h> needs CCCryptorStatus.
    sed 43i'#include <CommonCrypto/CommonCryptor.h>' -i Source/WTF/wtf/RandomDevice.cpp
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Web content rendering engine, GTK port";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = teams.gnome.members;
    broken = stdenv.isDarwin;
  };
}
