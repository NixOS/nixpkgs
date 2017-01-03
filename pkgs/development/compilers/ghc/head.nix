{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, autoconf, automake, happy, alex, python3, crossSystem, selfPkgs, cross ? null
}:

let
  inherit (bootPkgs) ghc;

  commonBuildInputs = [ ghc perl autoconf automake happy alex python3 ];

  version = "8.1.20161224";

  commonPreConfigure =  ''
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';
in stdenv.mkDerivation (rec {
  inherit version;
  name = "ghc-${version}";
  rev = "2689a1692636521777f007861a484e7064b2d696";

  src = fetchgit {
    url = "git://git.haskell.org/ghc.git";
    inherit rev;
    sha256 = "0rk6xy7kgxx849nprq1ji459p88nyy93236g841m5p6mdh7mmrcr";
  };

  postPatch = "patchShebangs .";

  preConfigure = ''
    echo ${version} >VERSION
    echo ${rev} >GIT_COMMIT_ID
    ./boot
  '' + commonPreConfigure ;

  buildInputs = commonBuildInputs;

  enableParallelBuilding = true;

  configureFlags = [
    "CC=${stdenv.cc}/bin/cc"
    "--with-gmp-includes=${gmp.dev}/include" "--with-gmp-libraries=${gmp.out}/lib"
    "--with-curses-includes=${ncurses.dev}/include" "--with-curses-libraries=${ncurses.out}/lib"
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    "--with-iconv-includes=${libiconv}/include" "--with-iconv-libraries=${libiconv}/lib"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  checkTarget = "test";

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
  } // stdenv.lib.optionalAttrs (crossSystem != null) {
    crossCompiler = selfPkgs.ghc.override {
      cross = crossSystem;
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

  # Some fixes for cross-compilation to iOS. See https://phabricator.haskell.org/D2710 (D2711,D2712,D2713)
  patches = [ ./D2710.patch ./D2711.patch ./D2712.patch ./D2713.patch ];

  preConfigure = commonPreConfigure + ''
    sed 's|#BuildFlavour  = quick-cross|BuildFlavour  = perf-cross|' mk/build.mk.sample > mk/build.mk
  '';

  configureFlags = [
    "CC=${stdenv.ccCross}/bin/${cross.config}-cc"
    "LD=${stdenv.binutilsCross}/bin/${cross.config}-ld"
    "AR=${stdenv.binutilsCross}/bin/${cross.config}-ar"
    "NM=${stdenv.binutilsCross}/bin/${cross.config}-nm"
    "RANLIB=${stdenv.binutilsCross}/bin/${cross.config}-ranlib"
    "--target=${cross.config}"
    "--enable-bootstrap-with-devel-snapshot"
  ];

  buildInputs = commonBuildInputs ++ [ stdenv.ccCross stdenv.binutilsCross ];

  dontSetConfigureCross = true;

  passthru = {
    inherit bootPkgs cross;

    cc = "${stdenv.ccCross}/bin/${cross.config}-cc";

    ld = "${stdenv.binutilsCross}/bin/${cross.config}-ld";
  };
})
