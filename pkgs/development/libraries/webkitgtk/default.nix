{ lib
, stdenv
, runCommand
, fetchurl
, fetchgit
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
, enableGLES ? stdenv.isLinux
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

stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.36.5";

  outputs = [ "out" "dev" ];

  separateDebugInfo = stdenv.isLinux;

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-1VMvqITJQ9xI8ZEUc91mOrpAejs1yqewS6wUGbQeWQg=";
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
  ] ++ [
    # Fix build without OpenGL.
    # https://bugs.webkit.org/show_bug.cgi?id=232934
    # This is required when building WebKitGTK with Quartz backend on macOS.
    (fetchpatch {
      url = "https://git.yoctoproject.org/poky/plain/meta/recipes-sato/webkit/webkitgtk/0001-Fix-build-without-opengl-or-es.patch";
      sha256 = "sha256-9MUDNTda2yxo5knhBKu2PQXNASgTW2Z7H4F0aFt4b0Q=";
    })
    # Fix conflicting types on OS X.
    # https://bugs.webkit.org/show_bug.cgi?id=126433
    # This patch was reverted later since it used to break builds under OS X 10.9 and earlier.
    # However, including CoreFoundation.h causes exactly the same errors in the link.
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/68822eb73f2cdd843dbe6bdd346e7268b279650b.patch";
      postFetch = ''sed -i 's/#ifdef __APPLE__/#if defined(__APPLE__)/' $out'';
      excludes = [ "Source/JavaScriptCore/ChangeLog" ];
      sha256 = "sha256-0jbQeOY9EC+8cgK4LWTO+q0TE50RdnWgSJalULc52m4=";
    })
    # Fix WTF errors on Darwin. (upstreamed)
    # This patch fixes missing headers in WTF.
    # TODO: remove me on 2.38+
    (fetchpatch {
      url = "https://github.com/WebKit/WebKit/commit/6bb3f1342f342358061b525c7b8f077b7b5ed15b.patch";
      sha256 = "sha256-f0ovaxF0IT3EDXTjaoYSu9fQlJa55AtlpalRisrx+Wk=";
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
    libnotify
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
    runCommand "${pname}_headers" { } ''
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
    "-DENABLE_GAMEPAD=OFF" # we don't have libmanette on darwin
    "-DENABLE_JOURNALD_LOG=OFF"
    "-DENABLE_QUARTZ_TARGET=ON"
    "-DENABLE_X11_TARGET=OFF"
    "-DUSE_APPLE_ICU=OFF" # https://bugs.webkit.org/show_bug.cgi?id=220081
    "-DUSE_OPENGL_OR_ES=OFF"
  ] ++ lib.optionals (!systemdSupport) [
    "-DUSE_SYSTEMD=OFF"
  ] ++ lib.optionals enableGLES [
    "-DENABLE_GLES2=ON"
  ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    # FAILED: Source/WTF/wtf/CMakeFiles/WTF.dir/FileSystem.cpp.o
    # error: no matching constructor for initialization of 'std::filesystem::path'
    "-D HAVE_MISSING_STD_FILESYSTEM_PATH_CONSTRUCTOR=1"
    # FAILED: lib/libwebkit2gtk-4.0.37.56.9.dylib
    # Undefined symbols for architecture arm64: "bmalloc::api::isoAllocate(__pas_heap_ref&)"
    # TODO: check if it can be removed on 2.37.2+
    "-D BENABLE_LIBPAS=0"
  ];

  postPatch = ''
    patchShebangs .
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Web content rendering engine, GTK port";
    homepage = "https://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = teams.gnome.members;
  };
}
