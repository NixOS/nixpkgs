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

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  meta = {
    inherit homepage;
    description = "The Glasgow Haskell Compiler";
    inherit (ghc.meta) license platforms;
  };

  passthru = {
    corePackages = [
      [ "Cabal" "1.6.0.3" ]
      [ "array" "0.2.0.0" ]
      [ "base" "3.0.3.1" ]
      [ "base" "4.1.0.0" ]
      [ "bytestring" "0.9.1.4" ]
      [ "containers" "0.2.0.1" ]
      [ "directory" "1.0.0.3" ]
      [ "extensible-exceptions" "0.1.1.0" ]
      [ "filepath" "1.1.0.2" ]
      [ "ghc" "6.10.4" ]
      [ "ghc-prim" "0.1.0.0" ]
      [ "haddock" "2.4.2" ]
      [ "haskell98" "1.0.1.0" ]
      [ "hpc" "0.5.0.3" ]
      [ "integer" "0.1.0.1" ]
      [ "old-locale" "1.0.0.1" ]
      [ "old-time" "1.0.0.2" ]
      [ "packedstring" "0.1.0.1" ]
      [ "pretty" "1.0.1.0" ]
      [ "process" "1.0.1.1" ]
      [ "random" "1.0.0.1" ]
      [ "rts" "1.0" ]
      [ "syb" "0.1.0.1" ]
      [ "template-haskell" "2.3.0.1" ]
      [ "unix" "2.3.2.0" ]
    ];
  };
}
