args: with args;
stdenv.mkDerivation rec {
  v = "2.43";
  name = "clisp-${v}";
  src =
	fetchurl {
		url = "mirror://gnu/clisp/release/${v}/${name}.tar.bz2";
		sha256 = "10qyn6wccnayf1cyvrcanay6c6laar6z1r608w7ijp6nb763q8dm";
	};

  inherit libsigsegv gettext coreutils;
  buildInputs = [libsigsegv gettext ncurses readline libX11 libXau
	libXt pcre zlib];
 
  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  patchPhase = ''
  sed -e 's@9090@64237@g' -i tests/socket.tst
  sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
  find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i
  '';

  configureFlags = "--with-readline builddir --with-dynamic-ffi
  --with-module=clx/new-clx --with-module=i18n --with-module=bindings/glibc
  --with-module=pcre --with-module=rawsock --with-module=readline
  --with-module=syscalls --with-module=wildcard --with-module=zlib";

  preBuild = "cd builddir";

  NIX_CFLAGS_COMPILE="-O0";

  # TODO : make mod-check fails
  doCheck = 1;

  meta = {
	  description = "ANSI Common Lisp Implementation";
	  homepage = http://clisp.cons.org;
  };
}
