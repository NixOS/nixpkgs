{stdenv, fetchurl, ghc, perl, gmp, ncurses, darwinInstallNameToolUtility}:

stdenv.mkDerivation rec {
  version = "7.4.0.20111219";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/7.4.1-rc1/${name}-src.tar.bz2";
    sha256 = "11imfag07wr9s5vf12yh6bz4hjfbw20i1c7n8py9fa4vx7va676n";
  };

  buildInputs = [ghc perl gmp ncurses] ++
    (if stdenv.isDarwin then [darwinInstallNameToolUtility] else []);

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '';

  configureFlags=[
    "--with-gcc=${stdenv.gcc}/bin/gcc"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.simons
    ];
    platforms = ghc.meta.platforms;
  };

}
