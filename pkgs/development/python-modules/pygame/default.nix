{ stdenv, fetchurl, buildPythonPackage, pkgconfig, smpeg, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi, isPy3k,
}:

buildPythonPackage {
  name = "pygame-1.9.1";

  src = fetchurl {
    url = "http://www.pygame.org/ftp/pygame-1.9.1release.tar.gz";
    sha256 = "0cyl0ww4fjlf289pjxa53q4klyn55ajvkgymw0qrdgp4593raq52";
  };

  buildInputs = [
    pkgconfig SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    smpeg portmidi libX11
  ];

  # /nix/store/94kswjlwqnc0k2bnwgx7ckx0w2kqzaxj-stdenv/setup: line 73: python: command not found
  disabled = isPy3k;

  # Tests fail because of no audio device and display.
  doCheck = false;

  patches = [ ./pygame-v4l.patch ];

  preConfigure = stdenv.lib.concatMapStrings (dep: ''
    sed \
      -e "/origincdirs =/a'${dep.dev or dep.out}/include'," \
      -e "/origlibdirs =/aoriglibdirs += '${dep.lib or dep.out}/lib'," \
      -i config_unix.py
  '') [ SDL_image SDL_mixer SDL_ttf libpng libjpeg portmidi libX11 ] + ''
    LOCALBASE=/ python config.py
  '';

  meta = {
    description = "Python library for games";
    homepage = "http://www.pygame.org/";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
