{ stdenv, fetchurl, ghc, perl, gmp, ncurses, binutils }:

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

  buildInputs = [ ghc perl gmp ncurses ];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for building ghc itself
    SRC_HC_OPTS += ${ghcFlags}
    SRC_CC_OPTS += ${cFlags}
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure

  '' + stdenv.lib.optionalString stdenv.isLinux ''
    # Set ghcFlags for binaries that ghc builds
    sed -i -e 's|"\$topdir"|"\$topdir" ${ghcFlags}|' ghc/ghc.wrapper

  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = "--with-gcc=${stdenv.gcc}/bin/gcc";

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
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.simons
    ];
    inherit (ghc.meta) license platforms;
  };

}
