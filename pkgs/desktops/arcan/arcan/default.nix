{ lib
, stdenv
, fetchFromGitHub
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
, buildManpages ? true, ruby
}:

let
  # TODO: investigate vendoring, especially OpenAL
  # WARN: vendoring of OpenAL is required for running arcan_lwa
  # INFO: maybe it needs leaveDotGit, but it is dangerous/impure
  letoram-openal-src = fetchFromGitHub {
    owner = "letoram";
    repo = "openal";
    rev = "1c7302c580964fee9ee9e1d89ff56d24f934bdef";
    hash = "sha256-InqU59J0zvwJ20a7KU54xTM7d76VoOlFbtj7KbFlnTU=";
  };
in
stdenv.mkDerivation rec {
  pname = "arcan";
  version = "0.6.1pre1+unstable=2021-10-16";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "arcan";
    rev = "e0182b944152fbcb49f5c16932d38c05a9fb2680";
    hash = "sha256-4FodFuO51ehvyjH4YaF/xBY9dwA6cP/e6/BvEsH4w7U=";
  };

  postUnpack = ''
    pushd .
    cd $sourceRoot/external/git/
    cp -a ${letoram-openal-src}/ openal/
    chmod --recursive 744 openal/
    popd
  '';

  # TODO: work with upstream in order to get rid of these hardcoded paths
  postPatch = ''
    substituteInPlace ./src/platform/posix/paths.c \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "$out/share"

    substituteInPlace ./src/CMakeLists.txt --replace "SETUID" "# SETUID"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ] ++ lib.optionals buildManpages [
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

  # INFO: According to the source code, the manpages need to be generated before
  # the configure phase
  preConfigure = lib.optionalString buildManpages ''
    pushd .
    cd doc
    ruby docgen.rb mangen
    popd
  '';

  cmakeFlags = [
    "-DBUILD_PRESET=everything"
    # The upstream project recommends tagging the distribution
    "-DDISTR_TAG=Nixpkgs"
    "-DENGINE_BUILDTAG=${version}"
    "-DHYBRID_SDL=on"
    "-DSTATIC_OPENAL=off"
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
