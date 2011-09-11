{stdenv, fetchurl, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "7.3.20110910";

  name = "ghc-${version}";

  # TODO: Does this have to be here, or can it go to meta?
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/current/dist/${name}-src.tar.bz2";
    sha256 = "1y8ixh6vcbqxqddc872kjfzxj94q4dhyaprdv7kv2yzwgp49qza5";
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

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    inherit homepage;
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
    ];
    platforms = ghc.meta.platforms;
  };

}
