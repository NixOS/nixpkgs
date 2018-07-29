{ stdenv, lib, fetchurl, buildPythonPackage, python, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, freetype
}:

buildPythonPackage rec {
  pname = "pygame";
  version = "1.9.4";

  src = fetchurl {
    url = "mirror://pypi/p/pygame/pygame-${version}.tar.gz";
    sha256 = "700d1781c999af25d11bfd1f3e158ebb660f72ebccb2040ecafe5069d0b2c0b6";
  };

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    portmidi libX11 freetype
  ];

  # Tests fail because of no audio device and display.
  doCheck = false;

  preConfigure = ''
    sed \
      -e "s/^origincdirs = .*/origincdirs = []/" \
      -e "s/^origlibdirs = .*/origlibdirs = []/" \
      -e "/\/include\/smpeg/d" \
      -i config_unix.py
    ${lib.concatMapStrings (dep: ''
      sed \
        -e "/^origincdirs =/aorigincdirs += ['${lib.getDev dep}/include']" \
        -e "/^origlibdirs =/aoriglibdirs += ['${lib.getLib dep}/lib']" \
        -i config_unix.py
      '') buildInputs
    }
    LOCALBASE=/ ${python.interpreter} config.py
  '';

  meta = with stdenv.lib; {
    description = "Python library for games";
    homepage = http://www.pygame.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
