{ stdenv, lib, fetchurl, bootPkgs, perl, ncurses, libiconv, binutils, coreutils
, autoconf, automake, happy, alex, python3, sphinx, hscolour
, buildPlatform, targetPlatform , selfPkgs, cross ? null

  # If enabled GHC will be build with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
, enableIntegerSimple ? false, gmp
}:

let
  inherit (bootPkgs) ghc;
  version = "8.2.1";
  preReleaseName = "ghc-8.2.1";
  commonBuildInputs = [ alex autoconf automake ghc happy hscolour perl python3 sphinx ];
  commonPreConfigure =  ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/${preReleaseName}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '' + stdenv.lib.optionalString enableIntegerSimple ''
    echo "INTEGER_LIBRARY=integer-simple" > mk/build.mk
  '';
in stdenv.mkDerivation (rec {
  inherit version;
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/${version}/${preReleaseName}-src.tar.xz";
    sha256 = "1w4k0n23b9fg8kmarqhfamzpmf91p6jcdr6xlwzfmb4df2bd9hng";
  };

  postPatch = "patchShebangs .";

  patches = [ ./ghc-gold-linker.patch ];

  preConfigure = commonPreConfigure;

  buildInputs = commonBuildInputs;

  enableParallelBuilding = true;

  configureFlags = [
    "CC=${stdenv.cc}/bin/cc"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
    "--datadir=$doc/share/doc/ghc"
  ] ++ stdenv.lib.optional (! enableIntegerSimple) [
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  checkTarget = "test";

  postInstall = ''
    paxmark m $out/lib/${preReleaseName}/bin/{ghc,haddock}

    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/ghc

    # Patch scripts to include "readelf" and "cat" in $PATH.
    for i in "$out/bin/"*; do
      test ! -h $i || continue
      egrep --quiet '^#!' <(head -n 1 $i) || continue
      sed -i -e '2i export PATH="$PATH:${stdenv.lib.makeBinPath [ binutils coreutils ]}"' $i
    done
  '';

  outputs = [ "out" "doc" ];

  passthru = {
    inherit bootPkgs;
  } // stdenv.lib.optionalAttrs (targetPlatform != buildPlatform) {
    crossCompiler = selfPkgs.ghc.override {
      cross = targetPlatform;
      bootPkgs = selfPkgs;
    };
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = with stdenv.lib.maintainers; [ marcweber andres peti ];
    inherit (ghc.meta) license platforms;
  };

} // stdenv.lib.optionalAttrs (cross != null) {
  name = "${cross.config}-ghc-${version}";

  preConfigure = commonPreConfigure + ''
    sed 's|#BuildFlavour  = quick-cross|BuildFlavour  = perf-cross|' mk/build.mk.sample > mk/build.mk
  '';

  configureFlags = [
    "CC=${stdenv.ccCross}/bin/${cross.config}-cc"
    "LD=${stdenv.binutils}/bin/${cross.config}-ld"
    "AR=${stdenv.binutils}/bin/${cross.config}-ar"
    "NM=${stdenv.binutils}/bin/${cross.config}-nm"
    "RANLIB=${stdenv.binutils}/bin/${cross.config}-ranlib"
    "--target=${cross.config}"
    "--enable-bootstrap-with-devel-snapshot"
  ] ++
    # fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
    lib.optional (cross.config or null == "aarch64-apple-darwin14") "--disable-large-address-space";

  buildInputs = commonBuildInputs ++ [ stdenv.ccCross stdenv.binutils ];

  dontSetConfigureCross = true;

  passthru = {
    inherit bootPkgs cross;
    cc = "${stdenv.ccCross}/bin/${cross.config}-cc";
    ld = "${stdenv.binutils}/bin/${cross.config}-ld";
  };
})
