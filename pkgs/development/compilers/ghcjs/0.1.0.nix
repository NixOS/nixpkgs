{ cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative_0_7_0_2
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, CabalGhcjs, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, cabalInstallGhcjs, gmp
}:

cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  version = "0.1.0";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "c9ce6b9d87296b1236d5ef0f7d5236b2cedcff84";
    sha256 = "0cla5bchprc8g5n39fkssnv3lj378h948irsnr7dslaki6laaagw";
  };
  bootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "2daaf8fc0efd5b5906a7157a172ce77ca3b28d81";
    sha256 = "0kwn3lh196rp02kz2vxd0mkqyix99xqzs4vsazv0s49ari0dc4w8";
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "a6dd0202dcdb86ad63201495b8b5d9763483eb35";
    sha256 = "07cd7ijw4i62iz1xjpwilriiybpqdx246w8d3j27ny1xfsj9wnax";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative_0_7_0_2 parallel safe shelly split
    stringsearch syb systemFileio systemFilepath tar terminfo textBinary
    unorderedContainers vector wlPprintText yaml
    alex happy git gnumake gcc autoconf automake libtool patch gmp
  ];
  testDepends = [
    HUnit regexPosix testFramework testFrameworkHunit
  ];
  postConfigure = ''
    echo Patching ghcjs with absolute paths to the Nix store
    sed -i -e "s|getAppUserDataDirectory \"ghcjs\"|return \"$out/share/ghcjs\"|" \
      src/Compiler/Info.hs
    sed -i -e "s|str = \\[\\]|str = [\"--prefix=$out\", \"--libdir=$prefix/lib/$compiler\", \"--libsubdir=$pkgid\"]|" \
      src-bin/Boot.hs
  '';
  postInstall = ''
    export HOME=$(pwd)
    cp -R ${bootSrc} ghcjs-boot
    cd ghcjs-boot
    ( cd boot ; chmod u+w . ; ln -s .. ghcjs-boot )
    chmod -R u+w .              # because fetchgit made it read-only
    local GHCJS_LIBDIR=$out/share/ghcjs/x86_64-linux-0.1.0-7.8.2
    ensureDir $GHCJS_LIBDIR
    cp -R ${shims} $GHCJS_LIBDIR/shims
    ${cabalInstallGhcjs}/bin/cabal-js update
    PATH=$out/bin:${CabalGhcjs}/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${gcc.gcc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot --init --with-cabal ${cabalInstallGhcjs}/bin/cabal-js --with-gmp-includes ${gmp}/include --with-gmp-libraries ${gmp}/lib
  '';
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
