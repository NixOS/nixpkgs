{ stdenv, fetchurl, fetchpatch, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, hscolour, patchutils
}:

let
  inherit (bootPkgs) ghc;

  fetchFilteredPatch = args: fetchurl (args // {
    downloadToTemp = true;
    postFetch = ''
      ${patchutils}/bin/filterdiff --clean --strip-match=1 -x 'testsuite/*' "$downloadedFile" > "$out"
    ''; # fix syntax highlighting: */
  });
in
stdenv.mkDerivation rec {
  version = "8.0.1.20161213";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/8.0.2-rc2/${name}-src.tar.xz";
    sha256 = "0l1arhbh3rbs011f0y4pgc35yn07x3hz6lfqlvqbwn96f8ff5529";
  };

  patches = [] ++ stdenv.lib.optional stdenv.isLinux ./ghc-no-madv-free.patch;

  buildInputs = [ ghc perl hscolour ];

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  preConfigure = ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
    "--datadir=$doc/share/doc/ghc"
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  postInstall = ''
    paxmark m $out/lib/${name}/bin/{ghc,haddock}

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
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
