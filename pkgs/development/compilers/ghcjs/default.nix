{ nodejs, cabal, filepath, HTTP, HUnit, mtl, network, QuickCheck, random, stm
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, time
, zlib, aeson, attoparsec, bzlib, dataDefault, ghcPaths, hashable
, haskellSrcExts, haskellSrcMeta, lens, optparseApplicative
, parallel, safe, shelly, split, stringsearch, syb, systemFileio
, systemFilepath, tar, terminfo, textBinary, unorderedContainers
, vector, wlPprintText, yaml, fetchgit, Cabal, cabalInstall
, regexPosix, alex, happy, git, gnumake, gcc, autoconf, patch
, automake, libtool, gmp, base16Bytestring
, cryptohash, executablePath, transformersCompat, haddockApi
, haddock, hspec, xhtml, primitive, cacert, pkgs, ghc
, coreutils
, ghcjsPrim
}:
let
  version = "0.1.0";
  libDir = "share/ghcjs/${pkgs.stdenv.system}-${version}-${ghc.ghc.version}/ghcjs";
  ghcjsBoot = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "5c7a71472d5a797e895914d3b82cea447a058793";
    sha256 = "0dp97bgbnlr3sd9yfnk27p6dfv46fi26sn6y6qv1wxs5i29kmjav";
  };
  shims = fetchgit {
    url = git://github.com/ghcjs/shims.git;
    rev = "99bbd4bed584ec42bfcc5ea61c3808a2c670053d";
    sha256 = "1my3gqkln7hgm0bpy32pnhwjfza096alh0n9x9ny8xfpxhmzz4h6";
  };
in cabal.mkDerivation (self: rec {
  pname = "ghcjs";
  inherit version;
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs.git;
    rev = "4b9461e8be646d5152a0ae7ece5b3616bf938637";
    sha256 = "19g62j1kkdwcgp0042ppmskwbvfk7qkf1fjs8bpjc6wwd19ipiar";
  };
  isLibrary = true;
  isExecutable = true;
  jailbreak = true;
  noHaddock = true;
  doCheck = false;
  buildDepends = [
    filepath HTTP mtl network random stm time zlib aeson attoparsec
    bzlib dataDefault ghcPaths hashable haskellSrcExts haskellSrcMeta
    lens optparseApplicative parallel safe shelly split
    stringsearch syb systemFileio systemFilepath tar terminfo textBinary
    unorderedContainers vector wlPprintText yaml
    alex happy git gnumake gcc autoconf automake libtool patch gmp
    base16Bytestring cryptohash executablePath haddockApi
    transformersCompat QuickCheck haddock hspec xhtml
    ghcjsPrim regexPosix
  ];
  buildTools = [ nodejs git ];
  testDepends = [
    HUnit testFramework testFrameworkHunit
  ];
  patches = [ ./ghcjs.patch ];
  postPatch = ''
    substituteInPlace Setup.hs --replace "/usr/bin/env" "${coreutils}/bin/env"
    substituteInPlace src/Compiler/Info.hs --replace "@PREFIX@" "$out"
    substituteInPlace src-bin/Boot.hs --replace "@PREFIX@" "$out"
  '';
  preBuild = ''
    local topDir=$out/${libDir}
    mkdir -p $topDir

    cp -r ${ghcjsBoot} $topDir/ghcjs-boot
    chmod -R u+w $topDir/ghcjs-boot

    cp -r ${shims} $topDir/shims
    chmod -R u+w $topDir/shims
  '';
  postInstall = ''
    PATH=$out/bin:${Cabal}/bin:$PATH LD_LIBRARY_PATH=${gmp}/lib:${gcc.gcc}/lib64:$LD_LIBRARY_PATH \
      env -u GHC_PACKAGE_PATH $out/bin/ghcjs-boot \
        --dev \
        --with-cabal ${cabalInstall}/bin/cabal \
        --with-gmp-includes ${gmp}/include \
        --with-gmp-libraries ${gmp}/lib
  '';
  passthru = {
    inherit libDir;
  };
  meta = {
    homepage = "https://github.com/ghcjs/ghcjs";
    description = "GHCJS is a Haskell to JavaScript compiler that uses the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
