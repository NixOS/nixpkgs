{ stdenv, fetchurl, fetchpatch, ghc, perl, gmp, ncurses, libiconv }:

let

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses}/lib"
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

  # We patch Cabal for GHCJS. See: https://github.com/haskell/cabal/issues/2454
  # This should be removed when GHC includes Cabal > 1.22.2.0
  cabalPatch = fetchpatch {
    url = https://github.com/haskell/cabal/commit/f11b7c858bb25be78b81413c69648c87c446859e.patch;
    sha256 = "1z56yyc7lgc78g847qf19f5n1yk054pzlnc2i178dpsj0mgjppyb";
  };

in

stdenv.mkDerivation rec {
  version = "7.10.1";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/7.10.1/${name}-src.tar.xz";
    sha256 = "181srnj3s5dcqb096yminjg50lq9cx57075n95y5hz33gbbf7wwj";
  };

  buildInputs = [ ghc perl ];

  enableParallelBuilding = true;

  patches = [
    # Fix user pkg db location for GHCJS: 
    # https://ghc.haskell.org/trac/ghc/ticket/10232
    (fetchpatch {
      url = "https://git.haskell.org/ghc.git/patch/c46e4b184e0abc158ad8f1eff6b3f0421acaf984";
      sha256 = "0fkdyqd4bqp742rydwmqq8d2n7gf61bgdhaiw8xf7jy0ix7lr60w";
    })
  ];

  postPatch = ''
    pushd libraries/Cabal
    patch -p1 < ${cabalPatch}
    popd
  '';

  preConfigure = ''
    echo >mk/build.mk "${buildMK}"
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp}/include" "--with-gmp-libraries=${gmp}/lib"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres simons ];
    inherit (ghc.meta) license platforms;
  };

}
