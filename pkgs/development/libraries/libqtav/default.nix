{ mkDerivation, lib, fetchFromGitHub, extra-cmake-modules
, qtbase, qtmultimedia, qtquick1, qttools
, libGL, libX11
, libass, openal, ffmpeg, libuchardet
, alsaLib, libpulseaudio, libva
}:

with lib;

mkDerivation rec {
  pname = "libqtav";
  version = "1.12.0";

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    qtbase qtmultimedia qtquick1
    libGL libX11
    libass openal ffmpeg libuchardet
    alsaLib libpulseaudio libva
  ];

  src = fetchFromGitHub {
    sha256 = "03ii9l38l3fsr27g42fx4151ipzkip2kr4akdr8x28sx5r9rr5m2";
    rev = "v${version}";
    repo = "QtAV";
    owner = "wang-bin";
    fetchSubmodules = true;
  };

  # Make sure libqtav finds its libGL dependency at both link and run time
  # by adding libGL to rpath. Not sure why it wasn't done automatically like
  # the other libraries as `libGL` is part of our `buildInputs`.
  NIX_CFLAGS_LINK = "-Wl,-rpath,${libGL}/lib";

  preFixup = ''
    mkdir -p "$out/bin"
    cp -a "./bin/"* "$out/bin"
  '';

  stripDebugList = [ "lib" "libexec" "bin" "qml" ];

  meta = {
    description = "A multimedia playback framework based on Qt + FFmpeg";
    #license = licenses.lgpl21; # For the libraries / headers only.
    license = licenses.gpl3; # With the examples (under bin) and most likely some of the optional dependencies used.
    homepage = http://www.qtav.org/;
    maintainers = [ maintainers.jraygauthier ];
    platforms = platforms.linux;
  };
}

