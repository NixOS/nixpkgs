{ stdenv, fetchurl, ghc, perl, gmp, ncurses
  # Whether or not to build shipped libraries with position independent code.
, enableBootLibPIC ? false
}:

stdenv.mkDerivation rec {
  version = "6.12.3";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://darcs.haskell.org/download/dist/${version}/${name}-src.tar.bz2";
    sha256 = "0s2y1sv2nq1cgliv735q2w3gg4ykv1c0g1adbv8wgwhia10vxgbc";
  };

  buildInputs = [ghc perl gmp ncurses];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
  '' + stdenv.lib.optionalString enableBootLibPIC picConfigString;

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
    libraries/integer-gmp_dist-install_EXTRA_HC_OPTS += -fPIC
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/gcc"
  ];

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    platforms = ["x86_64-linux" "i686-linux"];  # Darwin is unsupported.
    inherit (ghc.meta) license;
    broken = true; # broken by gcc 5.x: http://hydra.nixos.org/build/33627548
  };
}
