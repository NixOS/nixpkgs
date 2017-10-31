{ stdenv, fetchgit, makeWrapper, gmp, gcc }:

stdenv.mkDerivation rec {
  v = "1.1.9";
  name = "mkcl-${v}";

  src = fetchgit {
    url = "https://github.com/jcbeaudoin/mkcl.git";
    rev = "86768cc1dfc2cc9caa1fe9696584bb25ea6c1429";
    sha256 = "1gsvjp9xlnjccg0idi8x8gzkn6hlrqia95jh3zx7snm894503mf1";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ gmp ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "GMP_CFLAGS=-I${gmp.dev}/include"
    "GMP_LDFLAGS=-L${gmp.out}/lib"
  ];

  postInstall = ''
    wrapProgram $out/bin/mkcl --prefix PATH : "${gcc}/bin"
  '';

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = https://common-lisp.net/project/mkcl/;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.tohl];
  };
}

