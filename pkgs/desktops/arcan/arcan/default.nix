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
, glib
, gumbo
, harfbuzz
, jbig2dec
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
, lua5_1
, luajit
, makeWrapper
, mesa
, mupdf
, openal
, openjpeg
, pcre
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

let
  cmakeFeatureFlag = feature: flag:
    "-D${feature}=${if flag then "on" else "off"}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "arcan" + lib.optionalString useStaticOpenAL "-static-openal";
  version = "0.6.2.1";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "arcan";
    rev = finalAttrs.version;
    hash = "sha256-7H3fVSsW5VANLqwhykY+Q53fPjz65utaGksh/OpZnJM=";
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
    glib
    gumbo
    harfbuzz
    jbig2dec
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
    lua5_1
    luajit
    mesa
    mupdf.dev
    openal
    openjpeg.dev
    pcre
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

  # INFO: Arcan build scripts require the manpages to be generated before the
  # `configure` phase
  preConfigure = lib.optionalString buildManPages ''
    pushd doc
    ruby docgen.rb mangen
    popd
  '';

  cmakeFlags = [
    "-DBUILD_PRESET=everything"
    # The upstream project recommends tagging the distribution
    "-DDISTR_TAG=Nixpkgs"
    "-DENGINE_BUILDTAG=${finalAttrs.version}"
    (cmakeFeatureFlag "HYBRID_SDL" true)
    (cmakeFeatureFlag "BUILTIN_LUA" useBuiltinLua)
    (cmakeFeatureFlag "DISABLE_JIT" useBuiltinLua)
    (cmakeFeatureFlag "STATIC_FREETYPE" useStaticFreetype)
    (cmakeFeatureFlag "STATIC_LIBUVC" useStaticLibuvc)
    (cmakeFeatureFlag "STATIC_OPENAL" useStaticOpenAL)
    (cmakeFeatureFlag "STATIC_SQLite3" useStaticSqlite)
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
})
