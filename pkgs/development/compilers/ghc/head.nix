{stdenv, fetchurl, ghc, perl, gmp, ncurses, darwinInstallNameToolUtility}:

stdenv.mkDerivation rec {
  version = "7.5.20120413";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/current/dist/${name}-src.tar.bz2";
    sha256 = "a111054715133d12fc35d1565f371e149677416af9131e6a47ffdb0354e8a87f";
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
