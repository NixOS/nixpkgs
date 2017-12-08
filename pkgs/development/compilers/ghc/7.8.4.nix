{ stdenv, fetchurl, ghc, perl, ncurses, libiconv

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
  # Whether or not to build shipped libraries with position independent code.
, enableBootLibPIC ? false
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
  '') + stdenv.lib.optionalString enableBootLibPIC picConfigString;

  picConfigString = ''
    GhcRtsHcOpts += -fPIC
    libraries/array_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/base_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/binary_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/bytestring_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/Cabal_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/containers_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/deepseq_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/directory_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/dph_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/filepath_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/ghc-boot_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/ghc-boot-th_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/ghc-compact_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/ghc-prim_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/haskeline_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/hpc_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/integer-gmp_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/mtl_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/parallel_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/parsec_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/pretty_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/primitive_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/process_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/random_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/stm_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/template-haskell_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/terminfo_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/text_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/time_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/transformers_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/unix_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/vector_dist-install_EXTRA_HC_OPTS += -fPIC
    libraries/xhtml_dist-install_EXTRA_HC_OPTS += -fPIC
  '' + ( if enableIntegerSimple
         then "libraries/integer-simple_dist-install_EXTRA_HC_OPTS += -fPIC"
         else "libraries/integer-gmp_dist-install_EXTRA_HC_OPTS += -fPIC"
       );

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
