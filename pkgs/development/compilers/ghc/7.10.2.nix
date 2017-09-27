{ stdenv, fetchurl, fetchpatch, bootPkgs, perl, ncurses, libiconv, binutils, coreutils
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_45, docbook_xml_dtd_42, hscolour

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
  # Whether or not to build shipped libraries with position independent code.
, enableBootLibPIC ? false
}:

let
  inherit (bootPkgs) ghc;

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

  buildMK = ''
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
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

in

stdenv.mkDerivation rec {
  version = "7.10.2";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/7.10.2/${name}-src.tar.xz";
    sha256 = "1x8m4rp2v7ydnrz6z9g8x7z3x3d3pxhv2pixy7i7hkbqbdsp7kal";
  };

  buildInputs = [ ghc perl libxml2 libxslt docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_42 hscolour ];

  patches = [ ./relocation.patch ];

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

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
    "--datadir=$doc/share/doc/ghc"
  ] ++ stdenv.lib.optional (! enableIntegerSimple) [
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  postInstall = ''
    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/ghc

    # Patch scripts to include "readelf" and "cat" in $PATH.
    for i in "$out/bin/"*; do
      test ! -h $i || continue
      egrep --quiet '^#!' <(head -n 1 $i) || continue
      sed -i -e '2i export PATH="$PATH:${stdenv.lib.makeBinPath [ binutils coreutils ]}"' $i
    done
  '';

  passthru = {
    inherit bootPkgs;
  };

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
