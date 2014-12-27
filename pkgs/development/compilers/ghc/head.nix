{ stdenv, fetchurl, ghc, perl, gmp, ncurses, happy, alex }:

stdenv.mkDerivation rec {
  version = "7.9.20141217";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://deb.haskell.org/dailies/2014-12-17/ghc_${version}.orig.tar.bz2";
    sha256 = "1yfdi9r07aqbnv6xfdhs6cpj0y0yjdr03l5sa4dv0j1xs3lh1wkv";
  };

  buildInputs = [ ghc perl ncurses happy alex ];

  preConfigure = ''
    echo >mk/build.mk "DYNAMIC_BY_DEFAULT = NO"
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp}/include" "--with-gmp-libraries=${gmp}/lib"
  ];

  enableParallelBuilding = true;

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" "--keep-file-symbols" ];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres simons ];
    inherit (ghc.meta) license platforms;
  };

}
