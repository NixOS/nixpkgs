{ stdenv, fetchhg, buildPythonPackage, pkgconfig, smpeg, libX11
, SDL, SDL_image, SDL_mixer, SDL_ttf, libpng, libjpeg, portmidi
, ffmpeg
}:

buildPythonPackage {
  name = "pygame-1.9.2";

  src = fetchhg {
    url = "https://bitbucket.org/pygame/pygame";
    rev = "8bdcd449963f";
    sha256 = "1mhwh6lggfiyz22njxxr14p16ms0apfg14n1hmczqh4d6pdz8l2p";
  };

  buildInputs = [
    pkgconfig SDL SDL_image SDL_mixer SDL_ttf libpng libjpeg
    smpeg portmidi libX11 ffmpeg
  ];

  preConfigure = ''
    for i in ${SDL_image} ${SDL_mixer} ${SDL_ttf} ${libpng} ${libjpeg} ${portmidi} ${libX11} ${ffmpeg}; do
      sed -e "/origincdirs =/a'$i/include'," -i config_unix.py
      sed -e "/origlibdirs =/aoriglibdirs += '$i/lib'," -i config_unix.py
    done

    LOCALBASE=/ python3 config.py
  '';

  
  meta = {
    description = "Python library for games";
    homepage = "http://www.pygame.org/";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
