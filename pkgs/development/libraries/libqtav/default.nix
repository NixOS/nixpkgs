{ mkDerivation, lib, fetchFromGitHub, extra-cmake-modules
, qtbase, qtmultimedia, qtquick1, qttools
, mesa, libX11
, libass, openal, ffmpeg, libuchardet
, alsaLib, libpulseaudio, libva
}:

with lib;

mkDerivation rec {
  name = "libqtav-${version}";

  # Awaiting upcoming `v1.12.0` release. `v1.11.0` is not supporting cmake which is the
  # the reason behind taking an unstable git rev. 
  version = "unstable-2017-03-30";

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ 
    qtbase qtmultimedia qtquick1
    mesa libX11
    libass openal ffmpeg libuchardet
    alsaLib libpulseaudio libva
  ];

  src = fetchFromGitHub {
    sha256 = "1xw0ynm9w501651rna3ppf8p336ag1p60i9dxhghzm543l7as93v";
    rev = "4b4ae3b470b2fcbbcf1b541c2537fb270ee0bcfa";
    repo = "QtAV";
    owner = "wang-bin";
    fetchSubmodules = true;
  };

  patchPhase = ''
    sed -i -e 's#CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT#TRUE#g' ./CMakeLists.txt
    sed -i -e 's#DESTINATION ''${QT_INSTALL_LIBS}/cmake#DESTINATION ''${QTAV_INSTALL_LIBS}/cmake#g' ./CMakeLists.txt
  '';

  # Make sure libqtav finds its libGL dependancy at both link and run time
  # by adding mesa to rpath. Not sure why it wasn't done automatically like
  # the other libraries as `mesa` is part of our `buildInputs`.
  NIX_CFLAGS_LINK = [ "-Wl,-rpath,${mesa}/lib"];

  preFixup = ''
    mkdir -p "$out/bin"
    cp -a "./bin/"* "$out/bin"
  '';

  meta = {
    description = "A multimedia playback framework based on Qt + FFmpeg.";
    #license = licenses.lgpl21; # For the libraries / headers only.
    license = licenses.gpl3; # With the examples (under bin) and most likely some of the optional dependencies used.
    homepage = http://www.qtav.org/;
    maintainers = [ maintainers.jraygauthier ];
    platforms = platforms.linux;
  };
}

