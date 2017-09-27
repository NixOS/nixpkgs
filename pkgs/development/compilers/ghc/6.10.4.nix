{ stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses
  # Whether or not to build shipped libraries with position independent code.
, enableBootLibPIC ? false
}:

stdenv.mkDerivation rec {
  version = "6.10.4";

  name = "ghc-${version}";

  src = fetchurl {
    url = "${meta.homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "d66a8e52572f4ff819fe5c4e34c6dd1e84a7763e25c3fadcc222453c0bd8534d";
  };

  buildInputs = [ghc libedit perl gmp];

  hardeningDisable = [ "format" ];

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

  preConfigure = stdenv.lib.optionalString enableBootLibPIC ''
    echo ${picConfigString} >> mk/build.mk
  '';

  configureFlags = [
    "--with-gmp-libraries=${gmp.out}/lib"
    "--with-gmp-includes=${gmp.dev}/include"
    "--with-gcc=${stdenv.cc}/bin/gcc"
  ];

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    platforms = ["x86_64-linux" "i686-linux"];  # Darwin is unsupported.
    inherit (ghc.meta) license;
    broken = true;  # https://nix-cache.s3.amazonaws.com/log/6ys7lzckf2c0532kzhmss73mmz504can-ghc-6.10.4.drv
  };
}
