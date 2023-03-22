{ lib
, stdenv
, runCommand
, fetchurl
, fetchpatch
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
, libavif
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
, unifdef
, addOpenGLRunpath
, enableGeoLocation ? true
, withLibsecret ? true
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webkitgtk";
  version = "2.39.90";
  name = "${finalAttrs.pname}-${finalAttrs.version}+abi=${if lib.versionAtLeast gtk3.version "4.0" then "6.0" else "4.${if lib.versions.major libsoup.version == "2" then "0" else "1"}"}";

  outputs = [ "out" "dev" "devdoc" ];

  # https://github.com/NixOS/nixpkgs/issues/153528
  # Can't be linked within a 4GB address space.
  separateDebugInfo = stdenv.isLinux && !stdenv.is32bit;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/webkitgtk-${finalAttrs.version}.tar.xz";
    hash = "sha256-gnWGbDUppxXCPK442/Lt0xDYGIVGpHxaL3CdGT96X8A=";
  };

  patches = lib.optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
      inherit (addOpenGLRunpath) driverLink;
    })

    # Hardcode path to WPE backend
    # https://github.com/NixOS/nixpkgs/issues/110468
    (substituteAll {
      src = ./fdo-backend-path.patch;
      wpebackend_fdo = libwpe-fdo;
    })

    # Various build fixes for 2.39.90, should be part of final release
    # https://github.com/NixOS/nixpkgs/pull/218143#issuecomment-1445126808
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/5f8dc9d4cc01a31e53670acdcf7a9c4ea4626f58.patch";
      hash = "sha256-dTok1QK93Fp8RFED4wgbVdLErUnmIB4Xsm/VPutmQuw=";
    })
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/f51987a0f316621a0ab324696c9a576bbaf1e686.patch";
      hash = "sha256-TZVrrH4+JS2I/ist7MdMLsuk9X/Nyx62AcODvzGkdx8=";
    })
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/fe4fdc28cd214d36425d861791d05d1afaee60f5.patch";
      hash = "sha256-p1LNyvc6kGRhptov6AKVl2Rc+rrRnzHEtpF/AhqbA+E=";
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
    unifdef
  ] ++ lib.optionals stdenv.isLinux [
    wayland # for wayland-scanner
  ];

  buildInputs = [
    at-spi2-core
    enchant2
    libavif
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
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Web content rendering engine, GTK port";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    pkgConfigModules = [
      "javascriptcoregtk-4.0"
      "webkit2gtk-4.0"
      "webkit2gtk-web-extension-4.0"
    ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = teams.gnome.members;
    broken = stdenv.isDarwin;
  };
})
