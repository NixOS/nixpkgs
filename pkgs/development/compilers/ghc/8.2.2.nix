{ stdenv, targetPackages
, buildPlatform, hostPlatform, targetPlatform
, selfPkgs, cross ? null

# build-tools
, bootPkgs, alex, happy, hscolour
, autoconf, automake, coreutils, fetchurl, perl, python3, sphinx

, libiconv ? null, ncurses

, # If enabled, GHC will be built with the GPL-free but slower integer-simple
  # library instead of the faster but GPLed integer-gmp library.
  enableIntegerSimple ? false, gmp ? null
}:

assert !enableIntegerSimple -> gmp != null;

let
  inherit (bootPkgs) ghc;
  version = "8.2.2";

  # TODO(@Ericson2314) Make unconditional
  targetPrefix = stdenv.lib.optionalString
    (targetPlatform != hostPlatform)
    "${targetPlatform.config}-";

  commonBuildInputs = [ alex autoconf automake ghc happy hscolour perl python3 sphinx ];
  commonPreConfigure =  ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '' + stdenv.lib.optionalString enableIntegerSimple ''
    echo "INTEGER_LIBRARY=integer-simple" > mk/build.mk
  '';
in stdenv.mkDerivation (rec {
  inherit version;
  name = "ghc-${version}";

  src = fetchurl {
    url = "https://downloads.haskell.org/~ghc/8.2.2/${name}-src.tar.xz";
    sha256 = "1z05vkpaj54xdypmaml50hgsdpw29dhbs2r7magx0cm199iw73mv";
  };

  postPatch = "patchShebangs .";

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
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!targetPlatform.isDarwin) "--keep-file-symbols";

  checkTarget = "test";

  postInstall = ''
    paxmark m $out/lib/${name}/bin/${if targetPlatform != hostPlatform then "ghc" else "{ghc,haddock}"}

    # Install the bash completion file.
    install -D -m 444 utils/completion/ghc.bash $out/share/bash-completion/completions/${targetPrefix}ghc

    # Patch scripts to include "readelf" and "cat" in $PATH.
    for i in "$out/bin/"*; do
      test ! -h $i || continue
      egrep --quiet '^#!' <(head -n 1 $i) || continue
      sed -i -e '2i export PATH="$PATH:${stdenv.lib.makeBinPath [ targetPackages.stdenv.cc.bintools coreutils ]}"' $i
    done
  '';

  outputs = [ "out" "doc" ];

  passthru = {
    inherit bootPkgs targetPrefix;
  } // stdenv.lib.optionalAttrs (targetPlatform != buildPlatform) {
    crossCompiler = selfPkgs.ghc.override {
      cross = targetPlatform;
      bootPkgs = selfPkgs;
    };
  };

  meta = {
    homepage = http://haskell.org/ghc;
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
    "CC=${stdenv.cc}/bin/${cross.config}-cc"
    "LD=${stdenv.cc.bintools}/bin/${cross.config}-ld"
    "AR=${stdenv.cc.bintools}/bin/${cross.config}-ar"
    "NM=${stdenv.cc.bintools}/bin/${cross.config}-nm"
    "RANLIB=${stdenv.cc.bintools}/bin/${cross.config}-ranlib"
    "--target=${cross.config}"
    "--enable-bootstrap-with-devel-snapshot"
  ] ++
    # fix for iOS: https://www.reddit.com/r/haskell/comments/4ttdz1/building_an_osxi386_to_iosarm64_cross_compiler/d5qvd67/
    stdenv.lib.optional (cross.config or null == "aarch64-apple-darwin14") "--disable-large-address-space";

  buildInputs = commonBuildInputs;

  configurePlatforms = [];

  passthru = {
    inherit bootPkgs cross;
    cc = "${stdenv.cc}/bin/${cross.config}-cc";
    ld = "${stdenv.cc}/bin/${cross.config}-ld";
  };
})
