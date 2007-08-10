args:
args.stdenv.mkDerivation {
  name = "clisp-2.41a";
  builder = ./builder.sh;
  src = args.
	fetchurl {
		url = ftp://ftp.gnu.org/pub/gnu/clisp/release/2.41/clisp-2.41a.tar.bz2;
		sha256 = "08z35bni42dhlqlsg5rr5p025961fl82gqvaadrf0jh20jdqspqy";
	};

  inherit (args) libsigsegv gettext coreutils;
  buildInputs = (with args;
 [libsigsegv gettext ncurses readline libX11 libXau
	libXt pcre zlib]);
}
