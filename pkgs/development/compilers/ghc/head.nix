{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, autoconf, automake, happy, alex
}:

let
  inherit (bootPkgs) ghc;

in stdenv.mkDerivation rec {
  version = "8.1.20160930";
  name = "ghc-${version}";
  rev = "9e862765ffe161da8a4fd9cd67b0a600874feaa9";

  src = fetchgit {
    url = "git://git.haskell.org/ghc.git";
    inherit rev;
    sha256 = "01fmp5yrh3is8vzv2vabkzlvm1ry1zcq99m078plx9wgy20giq59";
  };

  patches = [
    ./ghc-8.x-dont-pass-linker-flags-via-response-files.patch   # https://github.com/NixOS/nixpkgs/issues/10752
  ];

  postUnpack = ''
    pushd ghc-${builtins.substring 0 7 rev}
    echo ${version} >VERSION
    echo ${rev} >GIT_COMMIT_ID
    patchShebangs .
    ./boot
    popd
  '';

  buildInputs = [ ghc perl autoconf automake happy alex ];

  enableParallelBuilding = true;

  preConfigure = ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = [
    "--with-cc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
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
