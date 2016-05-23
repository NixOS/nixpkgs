{ stdenv, lib, fetchFromBitbucket, buildPythonPackage, python, smpeg, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi
}:

buildPythonPackage rec {
  name = "pygame-${version}";
  version = "2016-05-17";

  src = fetchFromBitbucket {
    owner = "pygame";
    repo = "pygame";
    rev = "575c7a74d85a37db7c645421c02cf0b6b78a889f";
    sha256 = "1i5xqmw93kfidcji2wacgkm5y4mcnbksy8iimih0729k19rbhznc";
  };

  buildInputs = [
    SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    smpeg portmidi libX11
  ];

  # Tests fail because of no audio device and display.
  doCheck = false;

  preConfigure = ''
    sed \
      -e "s/^origincdirs = .*/origincdirs = []/" \
      -e "s/^origlibdirs = .*/origlibdirs = []/" \
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
