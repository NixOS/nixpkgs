{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.10.1";
  
  name = "ghc-${version}";
  
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "16q08cxxsmh4hgjhvkl739pc1hh81gljycfq1d2z6m1ld3jpbi22";
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

  
  passthru = {
    corePackages = [
      [ "Cabal" "1.6.0.1" ]
      [ "array" "0.2.0.0" ]
      [ "base" "3.0.3.0" ]
      [ "base" "4.0.0.0" ]
      [ "bytestring" "0.9.1.4" ]
      [ "containers" "0.2.0.0" ]
      [ "directory" "1.0.0.2" ]
      [ "editline" "0.2.1.0" ]
      [ "filepath" "1.1.0.1" ]
      [ "(ghc" "6.10.1)" ]
      [ "ghc-prim" "0.1.0.0" ]
      [ "haddock" "2.3.0" ]
      [ "haskell98" "1.0.1.0" ]
      [ "hpc" "0.5.0.2" ]
      [ "integer" "0.1.0.0" ]
      [ "old-locale" "1.0.0.1" ]
      [ "old-time" "1.0.0.1" ]
      [ "packedstring" "0.1.0.1" ]
      [ "pretty" "1.0.1.0" ]
      [ "process" "1.0.1.0" ]
      [ "random" "1.0.0.1" ]
      [ "rts" "1.0" ]
      [ "syb" "0.1.0.0" ]
      [ "template-haskell" "2.3.0.0" ]
      [ "unix" "2.3.1.0" ]
    ];
  };
}
