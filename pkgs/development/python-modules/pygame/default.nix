{ stdenv, lib, fetchurl, buildPythonPackage, python, smpeg, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, isPy3k,
}:

buildPythonPackage rec {
  name = "pygame-${version}";
  version = "1.9.1";

  src = fetchurl {
    url = "http://www.pygame.org/ftp/pygame-1.9.1release.tar.gz";
    sha256 = "0cyl0ww4fjlf289pjxa53q4klyn55ajvkgymw0qrdgp4593raq52";
  };

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    smpeg portmidi libX11
  ];

  # http://ubuntuforums.org/showthread.php?t=1960262
  disabled = isPy3k;

  # Tests fail because of no audio device and display.
  doCheck = false;

  patches = [ ./pygame-v4l.patch ];

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
    homepage = "http://www.pygame.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
