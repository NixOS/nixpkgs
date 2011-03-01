{stdenv, fetchurl, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "7.0.1.20110217";
  label = "7.0.2-rc2";
  
  name = "ghc-${version}";
  
  # TODO: Does this have to be here, or can it go to meta?
  homepage = "http://haskell.org/ghc";

  src = fetchurl {
    url = "${homepage}/dist/${label}/${name}-src.tar.bz2";
    sha256 = "18jbw5na4v8v2vzswbi8xfd73mx8zv1diym0bg5bns5337q76lzi";
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
    platforms = stdenv.lib.platforms.linux;
  };

}
