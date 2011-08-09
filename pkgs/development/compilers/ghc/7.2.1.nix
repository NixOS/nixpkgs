{stdenv, fetchurl, ghc, perl, gmp, ncurses, darwinInstallNameToolUtility}:

stdenv.mkDerivation rec {
  version = "7.2.0.20110804";
  label = "7.2.1-rc2";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${label}/${name}-src.tar.bz2";
    sha256 = "1q089pwfnjpgr44gd4pwp7794kw36dp3q5v0kpbcp1l24sbdf1x8";
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
    platforms = ghc.meta.platforms;
  };

}
