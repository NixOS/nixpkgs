{ stdenv, fetchgit, makeWrapper, gmp, gcc }:

stdenv.mkDerivation rec {
  v = "1.1.9";
  name = "mkcl-${v}";

  src = fetchgit {
    url = "https://github.com/jcbeaudoin/mkcl.git";
    rev = "86768cc1dfc2cc9caa1fe9696584bb25ea6c1429";
    sha256 = "0ja7vyp5rjidb2a1gah35jqzqn6zjkikz5sd966p0f0wh26l6n03";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ gmp ];

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

