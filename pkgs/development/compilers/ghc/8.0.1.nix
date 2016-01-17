{ stdenv, fetchurl, fetchpatch, ghc, perl, gmp, ncurses, libiconv, binutils, coreutils
, hscolour
}:

stdenv.mkDerivation rec {
  version = "8.0.0.20160111";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/8.0.1-rc1/${name}-src.tar.xz";
    sha256 = "0y4nha46mw01ysw90kh8szcbsfdc37rqjm7r5fyk6flqwr8b6pvr";
  };

  patches = [
    ./dont-pass-linker-flags-via-response-files.patch   # https://github.com/NixOS/nixpkgs/issues/10752
  ];

  buildInputs = [ ghc perl hscolour ];

  enableParallelBuilding = true;

  preConfigure = ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp}/include" "--with-gmp-libraries=${gmp}/lib"
    "--with-curses-includes=${ncurses}/include" "--with-curses-libraries=${ncurses}/lib"
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
      sed -i -e '2i export PATH="$PATH:${binutils}/bin:${coreutils}/bin"' $i
    done
  '';

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres simons ];
    inherit (ghc.meta) license platforms;
  };

}
