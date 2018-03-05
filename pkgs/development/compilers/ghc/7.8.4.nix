{ stdenv, targetPackages

, fetchurl, ghc, perl
, libffi, libiconv ? null, ncurses

, # If enabled, GHC will be built with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
  enableIntegerSimple ? false, gmp ? null
}:

# TODO(@Ericson2314): Cross compilation support
assert stdenv.targetPlatform == stdenv.hostPlatform;
assert !enableIntegerSimple -> gmp != null;

let
  buildMK = ''
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    DYNAMIC_BY_DEFAULT = NO
    ${stdenv.lib.optionalString (stdenv.hostPlatform.libc != "glibc") ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '' + (if enableIntegerSimple then ''
    INTEGER_LIBRARY = integer-simple
  '' else ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
  '');

  # Splicer will pull out correct variations
  libDeps = [ ncurses ]
    ++ stdenv.lib.optional (!enableIntegerSimple) gmp
    ++ stdenv.lib.optional (stdenv.hostPlatform.libc != "glibc") libiconv;

in

stdenv.mkDerivation rec {
  version = "7.8.4";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://www.haskell.org/ghc/dist/${version}/${name}-src.tar.xz";
    sha256 = "1i4254akbb4ym437rf469gc0m40bxm31blp6s1z1g15jmnacs6f3";
  };

  enableParallelBuilding = true;

  patches = [ ./relocation.patch ]
    ++ stdenv.lib.optional stdenv.isDarwin ./hpc-7.8.4.patch;

  preConfigure = ''
    echo -n "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS+=" -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ];

  nativeBuildInputs = [ ghc perl ];
  depsBuildTarget = [ targetPackages.stdenv.cc ];

  buildInputs = libDeps;
  propagatedBuildInputs = [ targetPackages.stdenv.cc ];

  depsTargetTarget = map stdenv.lib.getDev libDeps;
  depsTargetTargetPropagated = map (stdenv.lib.getOutput "out") libDeps;

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  passthru = {
    targetPrefix = "";

    # Our Cabal compiler name
    haskellCompilerName = "ghc-7.8.4";
  };

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
