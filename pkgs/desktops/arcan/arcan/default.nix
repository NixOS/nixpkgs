{ lib
, stdenv
, fetchFromGitHub
, fetchgit
, SDL2
, cmake
, espeak
, ffmpeg
, file
, freetype
, harfbuzz
, leptonica
, libGL
, libX11
, libXau
, libXcomposite
, libXdmcp
, libXfixes
, libdrm
, libffi
, libusb1
, libuvc
, libvlc
, libvncserver
, libxcb
, libxkbcommon
, lua
, luajit
, makeWrapper
, mesa
, openal
, pkg-config
, sqlite
, tesseract
, valgrind
, wayland
, wayland-protocols
, xcbutil
, xcbutilwm
, xz
, buildManPages ? true, ruby
, useBuiltinLua ? true
, useStaticFreetype ? false
, useStaticLibuvc ? false
, useStaticOpenAL ? true
, useStaticSqlite ? false
}:

stdenv.mkDerivation rec {
  pname = "arcan" + lib.optionalString useStaticOpenAL "-static-openal";
  version = "0.6.1pre1+unstable=2021-10-16";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "arcan";
    rev = "e0182b944152fbcb49f5c16932d38c05a9fb2680";
    hash = "sha256-4FodFuO51ehvyjH4YaF/xBY9dwA6cP/e6/BvEsH4w7U=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ] ++ lib.optionals buildManPages [
    ruby
  ];

  buildInputs = [
    SDL2
    espeak
    ffmpeg
    file
    freetype
    harfbuzz
    leptonica
    libGL
    libX11
    libXau
    libXcomposite
    libXdmcp
    libXfixes
    libdrm
    libffi
    libusb1
    libuvc
    libvlc
    libvncserver
    libxcb
    libxkbcommon
    lua
    luajit
    mesa
    openal
    sqlite
    tesseract
    valgrind
    wayland
    wayland-protocols
    xcbutil
    xcbutilwm
    xz
  ];

  patches = [
    # Nixpkgs-specific: redirect vendoring
    ./000-openal.patch
    ./001-luajit.patch
    ./002-libuvc.patch
    ./003-freetype.patch
  ];

  # Emulate external/git/clone.sh
  postUnpack = let
    inherit (import ./clone-sources.nix { inherit fetchFromGitHub fetchgit; })
      letoram-openal-src freetype-src libuvc-src luajit-src;
  in
    ''
      pushd $sourceRoot/external/git/
    ''
    + (lib.optionalString useStaticOpenAL ''
      cp -a ${letoram-openal-src}/ openal
      chmod --recursive 744 openal
    '')
    + (lib.optionalString useStaticFreetype ''
      cp -a ${freetype-src}/ freetype
      chmod --recursive 744 freetype
    '')
    + (lib.optionalString useStaticLibuvc ''
      cp -a ${libuvc-src}/ libuvc
      chmod --recursive 744 libuvc
    '')
    + (lib.optionalString useBuiltinLua ''
      cp -a ${luajit-src}/ luajit
      chmod --recursive 744 luajit
    '') +
    ''
      popd
    '';

  postPatch = ''
    substituteInPlace ./src/platform/posix/paths.c \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./src/CMakeLists.txt --replace "SETUID" "# SETUID"
  '';

  # INFO: According to the source code, the manpages need to be generated before
  # the configure phase
  preConfigure = lib.optionalString buildManPages ''
    pushd doc
    ruby docgen.rb mangen
    popd
  '';

  cmakeFlags = [
    "-DBUILD_PRESET=everything"
    # The upstream project recommends tagging the distribution
    "-DDISTR_TAG=Nixpkgs"
    "-DENGINE_BUILDTAG=${version}"
    "-DHYBRID_SDL=on"
    "-DBUILTIN_LUA=${if useBuiltinLua then "on" else "off"}"
    "-DDISABLE_JIT=${if useBuiltinLua then "on" else "off"}"
    "-DSTATIC_FREETYPE=${if useStaticFreetype then "on" else "off"}"
    "-DSTATIC_LIBUVC=${if useStaticLibuvc then "on" else "off"}"
    "-DSTATIC_OPENAL=${if useStaticOpenAL then "on" else "off"}"
    "-DSTATIC_SQLite3=${if useStaticSqlite then "on" else "off"}"
    "../src"
  ];

  hardeningDisable = [
    "format"
  ];

  meta = with lib; {
    homepage = "https://arcan-fe.com/";
    description = "Combined Display Server, Multimedia Framework, Game Engine";
    longDescription = ''
      Arcan is a portable and fast self-sufficient multimedia engine for
      advanced visualization and analysis work in a wide range of applications
      e.g. game development, real-time streaming video, monitoring and
      surveillance, up to and including desktop compositors and window managers.
    '';
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
