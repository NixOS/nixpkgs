{ stdenv, fetchurl, fetchpatch, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_45, docbook_xml_dtd_42, hscolour
}:

let
  inherit (bootPkgs) ghc;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

in

stdenv.mkDerivation rec {
  version = "7.10.2";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/7.10.2/${name}-src.tar.xz";
    sha256 = "1x8m4rp2v7ydnrz6z9g8x7z3x3d3pxhv2pixy7i7hkbqbdsp7kal";
  };

  buildInputs = [ ghc perl libxml2 libxslt docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_42 hscolour ];

  enableParallelBuilding = true;

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
      sed -i -e '2i export PATH="$PATH:${binutils}/bin:${coreutils}/bin"' $i
    done
  '';

  passthru = {
    inherit bootPkgs;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
