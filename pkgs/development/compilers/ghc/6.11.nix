{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses, happy, alex}:

stdenv.mkDerivation rec {
  version = "6.11.20090916";
  
  name = "ghc-${version}";
  
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/current/dist/${name}-src.tar.bz2";
    sha256 = "a229c5052f401d03cdb77b8a96643eb80ba3faf1a9d0578c6fede1ce2a63cede";
  };

  buildInputs = [ghc libedit perl gmp happy alex];

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-gcc=${stdenv.gcc}/bin/gcc"
  ];

  preConfigure=[
    "make distclean"
  ];

  meta = {
    inherit homepage;
    description = "The Glasgow Haskell Compiler";
  };
}
