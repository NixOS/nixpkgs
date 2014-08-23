{stdenv, fetchurl, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.12.3";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://darcs.haskell.org/download/dist/${version}/${name}-src.tar.bz2";
    sha256 = "0s2y1sv2nq1cgliv735q2w3gg4ykv1c0g1adbv8wgwhia10vxgbc";
  };

  buildInputs = [ghc perl gmp ncurses];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
  '';

  configureFlags=[
    "--with-gcc=${stdenv.gcc}/bin/gcc"
  ];

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
    ];
    inherit (ghc.meta) license platforms;
  };

  # TODO: requires a comment as to what it does and why it is needed.
  passthru = {
    corePackages = [
       [ "Cabal" "1.8.0.2" ]
       [ "array" "0.3.0.0" ]
       [ "base" "3.0.3.2" ]
       [ "base" "4.2.0.0" ]
       [ "bin-package-db" "0.0.0.0" ]
       [ "bytestring" "0.9.1.5" ]
       [ "containers" "0.3.0.0" ]
       [ "directory" "1.0.1.0" ]
       [ "dph-base" "0.4.0" ]
       [ "dph-par" "0.4.0" ]
       [ "dph-prim-interface" "0.4.0" ]
       [ "dph-prim-par" "0.4.0" ]
       [ "dph-prim-seq" "0.4.0" ]
       [ "dph-seq" "0.4.0" ]
       [ "extensible-exceptions" "0.1.1.1" ]
       [ "ffi" "1.0" ]
       [ "filepath" "1.1.0.3" ]
       [ "ghc" "6.12.1" ]
       [ "ghc-binary" "0.5.0.2" ]
       [ "ghc-prim" "0.2.0.0" ]
       [ "haskell98" "1.0.1.1" ]
       [ "hpc" "0.5.0.4" ]
       [ "integer-gmp" "0.2.0.0" ]
       [ "old-locale" "1.0.0.2" ]
       [ "old-time" "1.0.0.3" ]
       [ "pretty" "1.0.1.1" ]
       [ "process" "1.0.1.2" ]
       [ "random" "1.0.0.2" ]
       [ "rts" "1.0" ]
       [ "syb" "0.1.0.2" ]
       [ "template-haskell" "2.4.0.0" ]
       [ "time" "1.1.4" ]
       [ "unix" "2.4.0.0" ]
       [ "utf8-string" "0.3.4" ]
    ];
  };
}
