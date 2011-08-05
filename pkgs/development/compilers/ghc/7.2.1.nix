{stdenv, fetchurl, ghc, perl, gmp, ncurses, darwinInstallNameToolUtility}:

stdenv.mkDerivation rec {
  version = "7.2.0.20110728";
  label = "7.2.1-rc1";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${label}/${name}-src.tar.bz2";
    sha256 = "8747038f1b863a553f3250a415514705df5919932722e68a1477cf6e13363250";
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
    ];
    platforms = stdenv.lib.platforms.haskellPlatforms;
  };

}
