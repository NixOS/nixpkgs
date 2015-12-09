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

  patches = [ ./pygame-v4l.patch ];

  preConfigure = ''
    for i in ${SDL_image} ${SDL_mixer} ${SDL_ttf} ${libpng} ${libjpeg} ${portmidi} ${libX11}; do
      sed -e "/origincdirs =/a'$i/include'," -i config_unix.py
      sed -e "/origlibdirs =/aoriglibdirs += '$i/lib'," -i config_unix.py
    done

    LOCALBASE=/ python config.py
  '';

  meta = {
    description = "Python library for games";
    homepage = "http://www.pygame.org/";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
