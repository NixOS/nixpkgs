{ fetchurl, stdenv, python, pkgconfig, SDL, SDL_image, SDL_mixer, SDL_ttf
, numeric }:

stdenv.mkDerivation {
  name = "pygame-1.7";

  src = fetchurl {
    url = http://www.pygame.org/ftp/pygame-1.7.1release.tar.gz ;
    sha256 = "0hl0rmgjcqj217fibwyilz7w9jpg0kh7hsa7vyzd4cgqyliskpqi";
  };

  buildInputs = [python pkgconfig SDL SDL_image SDL_ttf numeric];
 
  configurePhase = ''
    export LOCALBASE=///
    sed -e "/origincdirs =/a'${SDL_image}/include/SDL','${SDL_image}/include'," -i config_unix.py
    sed -e "/origlibdirs =/aoriglibdirs += '${SDL_image}/lib'," -i config_unix.py
    sed -e "/origincdirs =/a'${SDL_mixer}/include/SDL','${SDL_mixer}/include'," -i config_unix.py
    sed -e "/origlibdirs =/aoriglibdirs += '${SDL_mixer}/lib'," -i config_unix.py
    sed -e "/origincdirs =/a'${SDL_ttf}/include/SDL','${SDL_ttf}/include'," -i config_unix.py
    sed -e "/origlibdirs =/aoriglibdirs += '${SDL_ttf}/lib'," -i config_unix.py
    sed -e "/origincdirs =/a'${numeric}/include/python2.5'," -i config_unix.py

    sed -e "s|get_python_inc(0)|\"${numeric}/include/python2.5\"|g" -i config_unix.py

    # XXX: `Numeric.pth' should be found by Python but it's not, hence the
    # $PYTHONPATH setting below.  Gobolinux has the same problem:
    # http://bugs.python.org/issue1431 .
    yes Y | \
      PYTHONPATH="${numeric}/lib/python2.5/site-packages/Numeric:$PYTHONPATH" \
      python config.py

    # That `config.py' is really deeply broken.
    sed -i Setup \
        -e "s|^NUMERIC *=.*$|NUMERIC = -I${numeric}/include/python2.5|g ;
            s|^MIXER *=.*$|MIXER = -I${SDL_mixer}/include -L${SDL_mixer}/lib -lSDL_mixer|g"
  '';

  buildPhase = "yes Y | python setup.py build";	

  installPhase = "yes Y | python setup.py install --prefix=\${out} ";

  meta = {
    description = "Python library for games";
  };
}
