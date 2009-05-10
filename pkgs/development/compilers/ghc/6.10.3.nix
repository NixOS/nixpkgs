{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.10.3";
  
  name = "ghc-${version}";
  
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "82d104ab8b24f27c3566b5693316c779427794a137237b3df925c55e20905893";
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
