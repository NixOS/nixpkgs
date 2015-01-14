{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.8.4";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://www.haskell.org/ghc/dist/7.8.4/${name}-src.tar.xz";
    sha256 = "1i4254akbb4ym437rf469gc0m40bxm31blp6s1z1g15jmnacs6f3";
  };

  buildInputs = [ ghc perl gmp ncurses ];

  enableParallelBuilding = true;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    DYNAMIC_BY_DEFAULT = NO
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" "--keep-file-symbols" ];

  meta = with stdenv.lib; {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [ maintainers.marcweber maintainers.andres maintainers.simons ];
    inherit (ghc.meta) license;
    # Filter old "i686-darwin" platform which is unsupported these days.
    platforms = filter (x: elem x platforms.all) ghc.meta.platforms;
    # Disable Darwin builds: <https://github.com/NixOS/nixpkgs/issues/2689>.
    hydraPlatforms = filter (x: !elem x platforms.darwin) meta.platforms;
  };

}
