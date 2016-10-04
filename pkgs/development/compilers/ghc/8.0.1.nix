{ stdenv, fetchurl, fetchpatch, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, hscolour, patchutils
}:

let
  inherit (bootPkgs) ghc;

  fetchFilteredPatch = args: fetchurl (args // {
    downloadToTemp = true;
    postFetch = ''
      ${patchutils}/bin/filterdiff --clean --strip-match=1 -x 'testsuite/*' "$downloadedFile" > "$out"
    '';
  });
in
stdenv.mkDerivation rec {
  version = "8.0.1";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/8.0.1/${name}-src.tar.xz";
    sha256 = "1lniqy29djhjkddnailpaqhlqh4ld2mqvb1fxgxw1qqjhz6j1ywh";
  };

  patches = [
    ./ghc-8.x-dont-pass-linker-flags-via-response-files.patch  # https://github.com/NixOS/nixpkgs/issues/10752
    ./relocation.patch

    # Fix https://ghc.haskell.org/trac/ghc/ticket/12130
    (fetchFilteredPatch { url = https://git.haskell.org/ghc.git/patch/4d71cc89b4e9648f3fbb29c8fcd25d725616e265; sha256 = "0syaxb4y4s2dc440qmrggb4vagvqqhb55m6mx12rip4i9qhxl8k0"; })
    (fetchFilteredPatch { url = https://git.haskell.org/ghc.git/patch/2f8cd14fe909a377b3e084a4f2ded83a0e6d44dd; sha256 = "06zvlgcf50ab58bw6yw3krn45dsmhg4cmlz4nqff8k4z1f1bj01v"; })
  ] ++ stdenv.lib.optional stdenv.isLinux ./ghc-no-madv-free.patch;

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
