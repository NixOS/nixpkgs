{ lib
, stdenv
, runCommand
, fetchurl
, perl
, python3
, ruby
, gi-docgen
, bison
, gperf
, cmake
, ninja
, pkg-config
, gettext
, gobject-introspection
, gnutls
, libgcrypt
, libgpg-error
, gtk3
, wayland
, wayland-protocols
, libwebp
, libwpe
, libwpe-fdo
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
, enableGeoLocation ? true
, withLibsecret ? true
, systemdSupport ? stdenv.isLinux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.38.5";
  name = "${finalAttrs.pname}-${finalAttrs.version}+abi=${if lib.versionAtLeast gtk3.version "4.0" then "5.0" else "4.${if lib.versions.major libsoup.version == "2" then "0" else "1"}"}";

  outputs = [ "out" "dev" "devdoc" ];

  # https://github.com/NixOS/nixpkgs/issues/153528
  # Can't be linked within a 4GB address space.
  separateDebugInfo = stdenv.isLinux && !stdenv.is32bit;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-QMIMQwIidN9Yk/IrEFT6iUw+6gVzibsIruCMWwuwwac=";
  };

  patches = lib.optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
      inherit (addOpenGLRunpath) driverLink;
    })

    ./libglvnd-headers.patch

    # Hardcode path to WPE backend
    # https://github.com/NixOS/nixpkgs/issues/110468
    (substituteAll {
      src = ./fdo-backend-path.patch;
      wpebackend_fdo = libwpe-fdo;
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
    gi-docgen
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
    libpthreadstubs
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
    runCommand "webkitgtk_headers" { } ''
      install -Dm444 "${lib.getDev apple_sdk.sdk}"/include/libproc.h "$out"/include/libproc.h
    ''
  ) ++ lib.optionals stdenv.isLinux [
    bubblewrap
    libseccomp
    libmanette
    wayland
    libwpe
    libwpe-fdo
    xdg-dbus-proxy
  ] ++ lib.optionals systemdSupport [
    systemd
  ] ++ lib.optionals enableGeoLocation [
    geoclue2
  ] ++ lib.optionals withLibsecret [
    libsecret
  ] ++ lib.optionals (lib.versionAtLeast gtk3.version "4.0") [
    xorg.libXcomposite
    wayland-protocols
  ];

  propagatedBuildInputs = [
    gtk3
    libsoup
  ];

  cmakeFlags = let
    cmakeBool = x: if x then "ON" else "OFF";
  in [
    "-DENABLE_INTROSPECTION=ON"
    "-DPORT=GTK"
    "-DUSE_LIBHYPHEN=OFF"
    "-DUSE_SOUP2=${cmakeBool (lib.versions.major libsoup.version == "2")}"
    "-DUSE_LIBSECRET=${cmakeBool withLibsecret}"
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
  ] ++ lib.optionals (lib.versionAtLeast gtk3.version "4.0") [
    "-DUSE_GTK4=ON"
  ] ++ lib.optionals (!systemdSupport) [
    "-DENABLE_JOURNALD_LOG=OFF"
  ] ++ lib.optionals (stdenv.isLinux && enableGLES) [
    "-DENABLE_GLES2=ON"
  ];

  postPatch = ''
    patchShebangs .
  '' + lib.optionalString stdenv.isDarwin ''
    # It needs malloc_good_size.
    sed 22i'#include <malloc/malloc.h>' -i Source/WTF/wtf/FastMalloc.h
    # <CommonCrypto/CommonRandom.h> needs CCCryptorStatus.
    sed 43i'#include <CommonCrypto/CommonCryptor.h>' -i Source/WTF/wtf/RandomDevice.cpp
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
})
