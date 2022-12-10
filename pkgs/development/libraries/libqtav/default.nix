{ mkDerivation
, lib
, fetchFromGitHub
, extra-cmake-modules
, qtbase
, qtmultimedia
, qtquick1
, qttools
, libGL
, libX11
, libass
, openal
, ffmpeg
, libuchardet
, alsa-lib
, libpulseaudio
, libva
}:

with lib;

mkDerivation rec {
  pname = "libqtav";
  version = "unstable-2020-09-10";

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    qtbase
    qtmultimedia
    qtquick1
    libGL
    libX11
    libass
    openal
    ffmpeg
    libuchardet
    alsa-lib
    libpulseaudio
    libva
  ];

  src = fetchFromGitHub {
    sha256 = "0qwrk40dihkbwmm7krz6qaqyn9v3qdjnd2k9b4s3a67x4403pib3";
    rev = "2a470d2a8d2fe22fae969bee5d594909a07b350a";
    repo = "QtAV";
    owner = "wang-bin";
    fetchSubmodules = true;
  };

  # Make sure libqtav finds its libGL dependency at both link and run time
  # by adding libGL to rpath. Not sure why it wasn't done automatically like
  # the other libraries as `libGL` is part of our `buildInputs`.
  NIX_CFLAGS_LINK = "-Wl,-rpath,${libGL}/lib";

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  preFixup = ''
    mkdir -p "$out/bin"
    cp -a "./bin/"* "$out/bin"
  '';

  stripDebugList = [ "lib" "libexec" "bin" "qml" ];

  meta = {
    description = "A multimedia playback framework based on Qt + FFmpeg";
    #license = licenses.lgpl21; # For the libraries / headers only.
    license = licenses.gpl3; # With the examples (under bin) and most likely some of the optional dependencies used.
    homepage = "http://www.qtav.org/";
    maintainers = [ maintainers.jraygauthier ];
    platforms = platforms.linux;
  };
}
