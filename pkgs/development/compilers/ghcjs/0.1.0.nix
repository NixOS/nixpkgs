{ cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative_0_9_1_1
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
    rev = "c0b8ebb3e2608fdd8dc3b74b55f281b5c24be8e1";
    sha256 = "442ebdfd426ec98a431735f72ec00c7dde54ae1f0c78dd593d33077ffdb1e2a2";
  };
  bootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "8bf2861c0c776eec42e0a1833f220e36681e810c";
    sha256 = "1f6695f7c25e40b87621ba6ce71a8338788951fd85e88e9223c8258520fbded6";
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "5e11d33cb74f8522efca0ace8365c0dc994b10f6";
    sha256 = "64be139022e6f662086103fca3838330006d38e6454bd3f7b66013031a47278e";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative_0_9_1_1 parallel safe shelly split
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
