{ stdenv, fetchgit, ghc, perl, gmp, ncurses, libiconv, autoconf, automake, happy, alex }:

let

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses}/lib"
    DYNAMIC_BY_DEFAULT = NO
    SRC_HC_OPTS        = -H64m -O -fasm
    GhcLibHcOpts       = -O -dcore-lint
    GhcStage1HcOpts    = -Rghc-timing -O -fasm
    GhcStage2HcOpts    = -Rghc-timing -O0 -DDEBUG
    SplitObjs          = NO
    HADDOCK_DOCS       = NO
    BUILD_DOCBOOK_HTML = NO
    BUILD_DOCBOOK_PS   = NO
    BUILD_DOCBOOK_PDF  = NO
    LAX_DEPENDENCIES   = YES
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

in

stdenv.mkDerivation rec {
  version = "7.11.20150718";
  name = "ghc-nokinds-${version}";
  rev = "4cb79c85a4976c509a65a8638899391a60cd0962";

  src = fetchgit {
    url = "https://github.com/goldfirere/ghc.git";
    inherit rev;
    sha256 = "1pyz459hs189bw2jaz7k2j2r53nc1vfa4q3zd3zz1zm0h14lsmlv";
  };

  postUnpack = ''
    pushd ghc-${builtins.substring 0 7 rev}
    patchShebangs .
    ./boot
    popd
  '';

  buildInputs = [ ghc perl autoconf automake happy alex ];

  preConfigure = ''
    echo >mk/build.mk "${buildMK}"
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
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The dependently-typed 'nokinds' branch of the Glasgow Haskell Compiler by Richard Eisenberg";
    maintainers = with stdenv.lib.maintainers; [ ];
    inherit (ghc.meta) license platforms;
  };

}
