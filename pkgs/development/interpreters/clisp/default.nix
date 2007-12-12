args: with args;
stdenv.mkDerivation {
  name = "clisp-2.43";
  builder = ./builder.sh;
  src =
	fetchurl {
		url = mirror://gnu/clisp/release/2.43/clisp-2.43.tar.bz2;
		sha256 = "10qyn6wccnayf1cyvrcanay6c6laar6z1r608w7ijp6nb763q8dm";
	};

  inherit libsigsegv gettext coreutils;
  buildInputs = [libsigsegv gettext ncurses readline libX11 libXau
	libXt pcre zlib];
}
