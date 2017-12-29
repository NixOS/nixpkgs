{ stdenv, fetchurl, ghc, perl, ncurses, binutils, libiconv

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
}:

let
  # The "-Wa,--noexecstack" options might be needed only with GNU ld (as opposed
  # to the gold linker). It prevents binaries' stacks from being marked as
  # executable, which fails to run on a grsecurity/PaX kernel.
  ghcFlags = "-optc-Wa,--noexecstack -opta-Wa,--noexecstack";
  cFlags = "-Wa,--noexecstack";

in stdenv.mkDerivation rec {
  version = "7.6.3";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "1669m8k9q72rpd2mzs0bh2q6lcwqiwd1ax3vrard1dgn64yq4hxx";
  };

  patches = [ ./fix-7.6.3-clang.patch ./relocation.patch ];

  buildInputs = [ ghc perl ncurses ]
                ++ stdenv.lib.optional (!enableIntegerSimple) gmp;

  buildMK = ''
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for building ghc itself
    SRC_HC_OPTS += ${ghcFlags}
    SRC_CC_OPTS += ${cFlags}
  '' + (if enableIntegerSimple then ''
    INTEGER_LIBRARY=integer-simple
  '' else ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
  '');

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for binaries that ghc builds
    sed -i -e 's|"\$topdir"|"\$topdir" ${ghcFlags}|' ghc/ghc.wrapper

  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    find . -name '*.hs'  | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    find . -name '*.lhs' | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = if stdenv.isDarwin then "--with-gcc=${./gcc-clang-wrapper.sh}"
                                      else "--with-gcc=${stdenv.cc}/bin/gcc";

  postInstall = ''
    # ghci uses mmap with rwx protection at it implements dynamic
    # linking on its own. See:
    # - https://bugs.gentoo.org/show_bug.cgi?id=299709
    # - https://ghc.haskell.org/trac/ghc/ticket/4244
    # Therefore, we have to pax-mark the resulting binary.
    # Haddock also seems to run with ghci, so mark it as well.
    paxmark m $out/lib/${name}/{ghc,haddock}
  '';

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.peti
    ];
    inherit (ghc.meta) license platforms;
  };

}
