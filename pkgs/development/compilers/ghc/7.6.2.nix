{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.6.2";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "d5f45184abeacf7e9c6b4f63c7101a5c1d7b4fe9007901159e2287ecf38de533";
  };

  buildInputs = [ ghc perl gmp ncurses ];

  # The comments below applied to GHC 7.6.1, left for if somebody experiences
  # similar problems. If so, I argue we should selectively disable parallel
  # building JUST for that platform. ~aristidb
  #
  ## My attempts to compile GHC with parallel build support enabled, failed
  ## 4 consecutive times with the following error:
  ##
  ##    building rts/dist/build/AutoApply.debug_o
  ##    building rts/dist/build/AutoApply.thr_o
  ##      rts_dist_HC rts/dist/build/AutoApply.debug_o
  ##    /nix/store/1iigiim5855m8j7pmwf5xrnpf705s4dh-binutils-2.21.1a/bin/ld: cannot find libraries/integer-gmp/dist-install/build/cbits/gmp-wrappers_o_split/gmp-wrappers__1.o
  ##    collect2: ld returned 1 exit status
  ##    make[1]: *** [libraries/integer-gmp/dist-install/build/cbits/gmp-wrappers.p_o] Error 1
  enableParallelBuilding = true;

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
