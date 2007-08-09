args:
args.stdenv.mkDerivation {
  name = "pygame-1.7";

  src = args.fetchurl {
    url = http://www.pygame.org/ftp/pygame-1.7.1release.tar.gz ;
    sha256 = "0hl0rmgjcqj217fibwyilz7w9jpg0kh7hsa7vyzd4cgqyliskpqi";
  };

  buildInputs =(with args; [python pkgconfig SDL SDL_image SDL_ttf]);
 
  configurePhase = (with args;
	 "
	export LOCALBASE=///
	sed -e \"/origincdirs =/a'${SDL_image}/include/SDL','${SDL_image}/include',\" -i config_unix.py
	sed -e \"/origlibdirs =/aoriglibdirs += '${SDL_image}/lib',\" -i config_unix.py
	sed -e \"/origincdirs =/a'${SDL_ttf}/include/SDL','${SDL_ttf}/include',\" -i config_unix.py
	sed -e \"/origlibdirs =/aoriglibdirs += '${SDL_ttf}/lib',\" -i config_unix.py
	yes Y | python config.py ");

  buildPhase = "yes Y | python setup.py build";	

  installPhase = "yes Y | python setup.py install --prefix=\${out} ";
 
  meta = {
    description = "
	Python library for games.
";
  };
}
