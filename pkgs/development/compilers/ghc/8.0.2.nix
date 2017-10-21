{ stdenv, lib, fetchurl, fetchpatch, bootPkgs, perl, ncurses, libiconv, binutils, coreutils
, hscolour, patchutils, sphinx

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
, cross ? null
}:

let
  inherit (bootPkgs) ghc;
in
stdenv.mkDerivation rec {
  version = "8.0.2";
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/8.0.2/${name}-src.tar.xz";
    sha256 = "1c8qc4fhkycynk4g1f9hvk53dj6a1vvqi6bklqznns6hw59m8qhi";
  };

  patches = [ ./ghc-gold-linker.patch ]
    ++ stdenv.lib.optional stdenv.isLinux ./ghc-no-madv-free.patch
    ++ stdenv.lib.optional stdenv.isDarwin ./ghc-8.0.2-no-cpp-warnings.patch;

  buildInputs = [ ghc perl hscolour sphinx ];

  enableParallelBuilding = true;

  outputs = [ "out" "man" "doc" ];

  preConfigure = ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '' + stdenv.lib.optionalString enableIntegerSimple ''
    echo "INTEGER_LIBRARY=integer-simple" > mk/build.mk
  '';

  configureFlags = [
    "--with-gcc=${stdenv.cc}/bin/cc"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
    "--datadir=$doc/share/doc/ghc"
  ] ++ stdenv.lib.optional (! enableIntegerSimple) [
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ] ++
    # fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
    lib.optional (cross.config or null == "aarch64-apple-darwin14") "--disable-large-address-space";

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
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

}
