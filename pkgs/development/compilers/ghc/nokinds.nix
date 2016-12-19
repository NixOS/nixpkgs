{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, libiconv, autoconf, automake, happy, alex }:

let
  inherit (bootPkgs) ghc;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
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
  version = "7.11.20150826";
  name = "ghc-${version}"; # We cannot add a "nokinds" tag here; see git comment for details.
  rev = "5f7f64b7fc879b5ecfd6987ec5565bd90f7c0179";

  src = fetchgit {
    url = "https://github.com/goldfirere/ghc.git";
    inherit rev;
    sha256 = "183l4v6aw52r3ydwl8bxg1lh3cwfakb35rpy6mjg23dqmqsynmcn";
  };

  patches = [ ./relocation.patch ];

  postUnpack = ''
    pushd ghc-${builtins.substring 0 7 rev}
    echo ${version} >VERSION
    echo ${rev} >GIT_COMMIT_ID
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
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
  ];

  enableParallelBuilding = true;

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  passthru = {
    inherit bootPkgs;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The dependently-typed 'nokinds' branch of the Glasgow Haskell Compiler by Richard Eisenberg";
    maintainers = with stdenv.lib.maintainers; [ deepfire ];
    inherit (ghc.meta) license platforms;
  };

}
