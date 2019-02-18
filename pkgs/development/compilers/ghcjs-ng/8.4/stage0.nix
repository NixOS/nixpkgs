{ callPackage, configuredSrc }:

{

  ghcjs = callPackage
    ({ mkDerivation, aeson, array, attoparsec, base, base16-bytestring
    , base64-bytestring, binary, bytestring, Cabal, containers
    , cryptohash, data-default, deepseq, directory, executable-path
    , filepath, ghc-api-ghcjs, ghc-boot, ghc-paths, ghci-ghcjs
    , ghcjs-th, haddock-api-ghcjs, hashable, haskell-src-exts
    , haskell-src-meta, http-types, HUnit, lens, lifted-base, mtl
    , network, optparse-applicative, parallel, parsec, process, random
    , regex-posix, safe, shelly, split, stdenv, stringsearch, syb
    , system-fileio, system-filepath, tar, template-haskell
    , template-haskell-ghcjs, terminfo, test-framework
    , test-framework-hunit, text, time, transformers
    , transformers-compat, unix, unix-compat, unordered-containers
    , vector, wai, wai-app-static, wai-extra, wai-websockets, warp
    , webdriver, websockets, wl-pprint-text, yaml
    }:
    mkDerivation {
      pname = "ghcjs";
      version = "8.4.0.1";
      src = configuredSrc + /.;
      isLibrary = true;
      isExecutable = true;
      enableSeparateDataOutput = true;
      setupHaskellDepends = [
        base Cabal containers directory filepath process template-haskell
        transformers
      ];
      libraryHaskellDepends = [
        aeson array attoparsec base base16-bytestring base64-bytestring
        binary bytestring Cabal containers cryptohash data-default deepseq
        directory filepath ghc-api-ghcjs ghc-boot ghc-paths ghci-ghcjs
        ghcjs-th hashable haskell-src-exts haskell-src-meta lens mtl
        optparse-applicative parallel parsec process regex-posix safe split
        stringsearch syb template-haskell template-haskell-ghcjs text time
        transformers unordered-containers vector wl-pprint-text yaml
      ];
      executableHaskellDepends = [
        aeson base binary bytestring Cabal containers directory
        executable-path filepath ghc-api-ghcjs ghc-boot haddock-api-ghcjs
        lens mtl optparse-applicative process shelly system-fileio
        system-filepath tar terminfo text time transformers
        transformers-compat unix unix-compat unordered-containers vector
        yaml
      ];
      testHaskellDepends = [
        aeson base bytestring data-default deepseq directory http-types
        HUnit lens lifted-base network optparse-applicative process random
        shelly system-fileio system-filepath test-framework
        test-framework-hunit text time transformers unordered-containers
        wai wai-app-static wai-extra wai-websockets warp webdriver
        websockets yaml
      ];
      description = "Haskell to JavaScript compiler";
      license = stdenv.lib.licenses.mit;
    }) {};

  ghc-api-ghcjs = callPackage
    ({ mkDerivation, array, base, binary, bytestring, containers
    , deepseq, directory, filepath, ghc-boot, ghc-boot-th, ghci-ghcjs
    , hpc, process, stdenv, template-haskell-ghcjs, terminfo, time
    , transformers, unix
    }:
    mkDerivation {
      pname = "ghc-api-ghcjs";
      version = "8.4.0";
      src = configuredSrc + /lib/ghc-api-ghcjs;
      libraryHaskellDepends = [
        array base binary bytestring containers deepseq directory filepath
        ghc-boot ghc-boot-th ghci-ghcjs hpc process template-haskell-ghcjs
        terminfo time transformers unix
      ];
      homepage = "http://www.haskell.org/ghc/";
      description = "The GHC API (customized for GHCJS)";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  ghci-ghcjs = callPackage
    ({ mkDerivation, array, base, binary, bytestring, containers
    , deepseq, filepath, ghc-boot, ghc-boot-th, stdenv
    , template-haskell-ghcjs, transformers, unix
    }:
    mkDerivation {
      pname = "ghci-ghcjs";
      version = "8.4.0";
      src = configuredSrc + /lib/ghci-ghcjs;
      libraryHaskellDepends = [
        array base binary bytestring containers deepseq filepath ghc-boot
        ghc-boot-th template-haskell-ghcjs transformers unix
      ];
      description = "The library supporting GHC's interactive interpreter (customized for GHCJS)";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  ghcjs-th = callPackage
    ({ mkDerivation, base, binary, bytestring, containers, ghc-prim
    , ghci-ghcjs, stdenv, template-haskell-ghcjs
    }:
    mkDerivation {
      pname = "ghcjs-th";
      version = "0.1.0.0";
      src = configuredSrc + /lib/ghcjs-th;
      libraryHaskellDepends = [
        base binary bytestring containers ghc-prim ghci-ghcjs
        template-haskell-ghcjs
      ];
      homepage = "http://github.com/ghcjs";
      license = stdenv.lib.licenses.mit;
    }) {};

  haddock-api-ghcjs = callPackage
    ({ mkDerivation, array, base, bytestring, Cabal, containers, deepseq
    , directory, filepath, ghc-api-ghcjs, ghc-boot, ghc-paths
    , haddock-library-ghcjs, hspec, hspec-discover, QuickCheck, stdenv
    , transformers, xhtml
    }:
    mkDerivation {
      pname = "haddock-api-ghcjs";
      version = "2.20.0";
      src = configuredSrc + /lib/haddock-api-ghcjs;
      enableSeparateDataOutput = true;
      libraryHaskellDepends = [
        array base bytestring Cabal containers deepseq directory filepath
        ghc-api-ghcjs ghc-boot ghc-paths haddock-library-ghcjs transformers
        xhtml
      ];
      testHaskellDepends = [
        array base bytestring Cabal containers deepseq directory filepath
        ghc-api-ghcjs ghc-boot ghc-paths haddock-library-ghcjs hspec
        QuickCheck transformers xhtml
      ];
      testToolDepends = [ hspec-discover ];
      homepage = "http://www.haskell.org/haddock/";
      description = "A documentation-generation tool for Haskell libraries";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  haddock-library-ghcjs = callPackage
    ({ mkDerivation, base, base-compat, bytestring, containers, deepseq
    , directory, filepath, haddock-library, hspec, hspec-discover
    , optparse-applicative, QuickCheck, stdenv, transformers, tree-diff
    }:
    mkDerivation {
      pname = "haddock-library-ghcjs";
      version = "1.6.0";
      src = configuredSrc + /lib/haddock-library-ghcjs;
      libraryHaskellDepends = [
        base bytestring containers deepseq transformers
      ];
      testHaskellDepends = [
        base base-compat bytestring containers deepseq directory filepath
        haddock-library hspec optparse-applicative QuickCheck transformers
        tree-diff
      ];
      testToolDepends = [ hspec-discover ];
      doHaddock = false;
      homepage = "http://www.haskell.org/haddock/";
      description = "Library exposing some functionality of Haddock";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  template-haskell-ghcjs = callPackage
    ({ mkDerivation, base, ghc-boot-th, pretty, stdenv }:
    mkDerivation {
      pname = "template-haskell-ghcjs";
      version = "2.13.0.0";
      src = configuredSrc + /lib/template-haskell-ghcjs;
      libraryHaskellDepends = [ base ghc-boot-th pretty ];
      description = "Support library for Template Haskell (customized for GHCJS)";
      license = stdenv.lib.licenses.bsd3;
    }) {};

}
