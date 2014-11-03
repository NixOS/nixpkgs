{ stdenv, fetchurl, python, pkgconfig
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg
}:

stdenv.mkDerivation {
  name = "pygame-1.9.1";

  src = fetchurl {
    url = "http://www.pygame.org/ftp/pygame-1.9.1release.tar.gz";
    sha256 = "0cyl0ww4fjlf289pjxa53q4klyn55ajvkgymw0qrdgp4593raq52";
  };

  buildInputs = [
    python pkgconfig SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
  ];

  patches = [ ./pygame-v4l.patch ];

  configurePhase = ''
    for i in ${SDL_image} ${SDL_mixer} ${SDL_ttf} ${libpng} ${libjpeg}; do
      sed -e "/origincdirs =/a'$i/include'," -i config_unix.py
      sed -e "/origlibdirs =/aoriglibdirs += '$i/lib'," -i config_unix.py
    done

    yes Y | LOCALBASE=/ python config.py
  '';

  buildPhase = "python setup.py build"; 

  installPhase = "python setup.py install --prefix=$out";

  meta = {
    description = "Python library for games";
    homepage = "http://www.pygame.org/";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
