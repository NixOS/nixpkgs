{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.10.4";
  
  name = "ghc-${version}";
  
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "d66a8e52572f4ff819fe5c4e34c6dd1e84a7763e25c3fadcc222453c0bd8534d";
  };

  buildInputs = [ghc libedit perl gmp];

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-gcc=${stdenv.gcc}/bin/gcc"
  ];

  meta = {
    inherit homepage;
    description = "The Glasgow Haskell Compiler";
  };
}
