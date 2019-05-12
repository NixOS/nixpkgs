{ lib, fetchPypi, buildPythonPackage, python, pkg-config, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, freetype
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "1.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mvr557xwn0pvd1s8mpkdwxqccwwac7bhl9rkr5cs3l8q0l6871h";
  };

  nativeBuildInputs = [
    pkg-config SDL
  ];

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    portmidi libX11 freetype
  ];

  # Tests fail because of no audio device and display.
  doCheck = false;

  preConfigure = ''
    sed \
      -e "s/origincdirs = .*/origincdirs = []/" \
      -e "s/origlibdirs = .*/origlibdirs = []/" \
      -e "/'\/lib\/i386-linux-gnu', '\/lib\/x86_64-linux-gnu']/d" \
      -e "/\/include\/smpeg/d" \
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
    homepage = http://www.pygame.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
