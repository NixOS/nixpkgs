{ stdenv, fetchurl, ghc, perl, ncurses, libiconv

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
}:

stdenv.mkDerivation (rec {
  version = "7.8.4";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://www.haskell.org/ghc/dist/7.8.4/${name}-src.tar.xz";
    sha256 = "1i4254akbb4ym437rf469gc0m40bxm31blp6s1z1g15jmnacs6f3";
  };

  patches = [ ./relocation.patch ];

  buildInputs = [ ghc perl ncurses ]
                ++ stdenv.lib.optional (!enableIntegerSimple) gmp;

  enableParallelBuilding = true;

  buildMK = ''
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    DYNAMIC_BY_DEFAULT = NO
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '' + (if enableIntegerSimple then ''
    INTEGER_LIBRARY=integer-simple
  '' else ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
  '');

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

} // stdenv.lib.optionalAttrs stdenv.isDarwin {
  # https://ghc.haskell.org/trac/ghc/ticket/9762
  patches = [ ./hpc-7.8.4.patch ];
})
