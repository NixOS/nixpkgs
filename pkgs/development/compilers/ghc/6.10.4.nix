{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.10.4";

  name = "ghc-${version}";

  src = fetchurl {
    url = "${meta.homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "d66a8e52572f4ff819fe5c4e34c6dd1e84a7763e25c3fadcc222453c0bd8534d";
  };

  buildInputs = [ghc libedit perl gmp];

  configureFlags = [
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-gcc=${stdenv.cc}/bin/gcc"
  ];

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    inherit (ghc.meta) license platforms;
  };
}
