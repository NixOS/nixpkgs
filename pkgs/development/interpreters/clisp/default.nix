args: with args;
stdenv.mkDerivation rec {
  v = "2.47";
  name = "clisp-${v}";
  src =
	fetchurl {
		url = "mirror://gnu/clisp/release/${v}/${name}.tar.gz";
		sha256 = "0slfx519pk75y5rf7wfna7jgyhkr4qp29z9zd1rcnnrhps11bpn7";
	};

  inherit libsigsegv gettext coreutils;
  buildInputs = [libsigsegv gettext ncurses readline libX11 libXau
	libXt pcre zlib libXpm xproto libXext xextproto libffi
	libffcall];
 
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

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    cd builddir
  '';

  NIX_CFLAGS_COMPILE="-O0";

  # TODO : make mod-check fails
  doCheck = 1;

  meta = {
	  description = "ANSI Common Lisp Implementation";
	  homepage = http://clisp.cons.org;
  };
}
