{ lib, fetchPypi, buildPythonPackage, python, pkg-config, libX11
, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, libpng, libjpeg, portmidi, freetype
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b1e7b63f47aafcdd8849933b206778747ef1802bd3d526aca45ed77141e4001";
  };

  nativeBuildInputs = [
    pkg-config SDL2
  ];

  buildInputs = [
    SDL2 SDL2_image SDL2_mixer SDL2_ttf libpng libjpeg
    portmidi libX11 freetype
  ];

  # Tests fail because of no audio device and display.
  doCheck = false;

  preConfigure = ''
    sed \
      -e "s/origincdirs = .*/origincdirs = []/" \
      -e "s/origlibdirs = .*/origlibdirs = []/" \
      -e "/linux-gnu/d" \
      -i buildconfig/config_unix.py
    ${lib.concatMapStrings (dep: ''
      sed \
        -e "/origincdirs =/a\        origincdirs += ['${lib.getDev dep}/include']" \
        -e "/origlibdirs =/a\        origlibdirs += ['${lib.getLib dep}/lib']" \
        -i buildconfig/config_unix.py
      '') buildInputs
    }
    LOCALBASE=/ ${python.interpreter} buildconfig/config.py
  '';

  meta = with lib; {
    description = "Python library for games";
    homepage = "http://www.pygame.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
