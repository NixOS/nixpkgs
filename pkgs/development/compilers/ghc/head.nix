{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, libiconv, binutils, coreutils
, autoconf, automake, happy, alex, crossSystem, selfPkgs, cross ? null
}:

let
  inherit (bootPkgs) ghc;

  commonBuildInputs = [ ghc perl autoconf automake happy alex ];

  version = "8.1.20161115";

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
  rev = "017d11e0a36866b05ace32ece1af11adf652a619";

  src = fetchgit {
    url = "git://git.haskell.org/ghc.git";
    inherit rev;
    sha256 = "1ryggmz961qd0fl50rkjjvi6g9azwla2vx9310a9nzjaj5x6ib4y";
  };

  # This shouldn't be necessary since 1ad1edbb32ce01ba8b47d8e8dad357b0edd6a4dc, but
  # see http://hydra.cryp.to/build/2061608/nixlog/1/raw
  patches = [ ./ghc-HEAD-dont-pass-linker-flags-via-response-files.patch ];

  postPatch = ''
    echo ${version} >VERSION
    echo ${rev} >GIT_COMMIT_ID
    patchShebangs .
    ./boot
  '';

  buildInputs = commonBuildInputs;

  enableParallelBuilding = true;

  preConfigure = commonPreConfigure;

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
