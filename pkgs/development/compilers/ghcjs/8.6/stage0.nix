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
    , regex-posix, safe, shelly_1_8_2, split, stdenv, stringsearch, syb
    , system-fileio, system-filepath, tar, template-haskell
    , template-haskell-ghcjs, terminfo, test-framework
    , test-framework-hunit, text, time, transformers
    , transformers-compat, unix, unix-compat, unordered-containers
    , vector, wai, wai-app-static, wai-extra, wai-websockets, warp
    , webdriver, websockets, wl-pprint-text, yaml
    }:
    mkDerivation {
      pname = "ghcjs";
      version = "8.6.0.1";
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
        lens mtl optparse-applicative process shelly_1_8_2 system-fileio
        system-filepath tar terminfo text time transformers
        transformers-compat unix unix-compat unordered-containers vector
        yaml
      ];
      testHaskellDepends = [
        aeson base bytestring data-default deepseq directory http-types
        HUnit lens lifted-base network optparse-applicative process random
        shelly_1_8_2 system-fileio system-filepath test-framework
        test-framework-hunit text time transformers unordered-containers
        wai wai-app-static wai-extra wai-websockets warp webdriver
        websockets yaml
      ];
      description = "Haskell to JavaScript compiler";
      license = stdenv.lib.licenses.mit;
      doCheck = false;
    }) {};

  happy_1_19_9 = callPackage
    ({ mkDerivation, array, base, Cabal, containers, directory, filepath
    , lib, mtl, process
    }:
    mkDerivation {
      pname = "happy";
      version = "1.19.9";
      src = builtins.fetchTarball {
        url = "https://hackage.haskell.org/package/happy-1.19.9/happy-1.19.9.tar.gz";
        sha256 = "1bh8ldimknnh4f8zc5qjk6naj5ilq22i2xlgnc16jxfj7l67dz70"; 
      };
      isLibrary = false;
      isExecutable = true;
      setupHaskellDepends = [ base Cabal directory filepath ];
      executableHaskellDepends = [ array base containers mtl ];
      testHaskellDepends = [ base process ];
      homepage = "https://www.haskell.org/happy/";
      description = "Happy is a parser generator for Haskell";
      license = lib.licenses.bsd2;
    }) {};

  shelly_1_8_2 = callPackage
    ({ mkDerivation, async, base, bytestring, containers, directory
    , enclosed-exceptions, exceptions, filepath, hspec, hspec-contrib
    , HUnit, lib, lifted-async, lifted-base, monad-control, mtl
    , process, system-fileio, system-filepath, text, time, transformers
    , transformers-base, unix-compat
    }:
    mkDerivation {
      pname = "shelly";
      version = "1.8.2";
      src = builtins.fetchTarball {
        url = "https://hackage.haskell.org/package/shelly-1.8.2/shelly-1.8.2.tar.gz";
        sha256 = "1iz4ycc7k20r56avx8rz7cwnjf96d3ikwqpsjmvnxkzsy5f9gbsi";
      };
      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = [
        async base bytestring containers directory enclosed-exceptions
        exceptions lifted-async lifted-base monad-control mtl process
        system-fileio system-filepath text time transformers
        transformers-base unix-compat
      ];
      testHaskellDepends = [
        async base bytestring containers directory enclosed-exceptions
        exceptions filepath hspec hspec-contrib HUnit lifted-async
        lifted-base monad-control mtl process system-fileio system-filepath
        text time transformers transformers-base unix-compat
      ];
      homepage = "https://github.com/gregwebs/Shelly.hs";
      description = "shell-like (systems) programming in Haskell";
      license = lib.licenses.bsd3;
    }) {};

  ghc-api-ghcjs = callPackage
    ({ mkDerivation, alex, array, base, binary, bytestring, containers
    , deepseq, directory, filepath, ghc-boot, ghc-boot-th, ghc-heap
    , ghci-ghcjs, happy_1_19_9, hpc, process, stdenv, template-haskell-ghcjs
    , terminfo, time, transformers, unix
    }:
    mkDerivation {
      pname = "ghc-api-ghcjs";
      version = "8.6.5";
      src = configuredSrc + /lib/ghc-api-ghcjs;
      libraryHaskellDepends = [
        array base binary bytestring containers deepseq directory filepath
        ghc-boot ghc-boot-th ghc-heap ghci-ghcjs hpc process
        template-haskell-ghcjs terminfo time transformers unix
      ];
      libraryToolDepends = [ alex happy_1_19_9 ];
      homepage = "http://www.haskell.org/ghc/";
      description = "The GHC API (customized for GHCJS)";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  ghci-ghcjs = callPackage
    ({ mkDerivation, array, base, binary, bytestring, containers
    , deepseq, filepath, ghc-boot, ghc-boot-th, ghc-heap, stdenv
    , template-haskell-ghcjs, transformers, unix
    }:
    mkDerivation {
      pname = "ghci-ghcjs";
      version = "8.6.1";
      src = configuredSrc + /lib/ghci-ghcjs;
      libraryHaskellDepends = [
        array base binary bytestring containers deepseq filepath ghc-boot
        ghc-boot-th ghc-heap template-haskell-ghcjs transformers unix
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
    , optparse-applicative, parsec, QuickCheck, stdenv, text
    , transformers, tree-diff
    }:
    mkDerivation {
      pname = "haddock-library-ghcjs";
      version = "1.6.0";
      src = configuredSrc + /lib/haddock-library-ghcjs;
      libraryHaskellDepends = [
        base bytestring containers parsec text transformers
      ];
      testHaskellDepends = [
        base base-compat bytestring containers deepseq directory filepath
        haddock-library hspec optparse-applicative parsec QuickCheck text
        transformers tree-diff
      ];
      testToolDepends = [ hspec-discover ];
      homepage = "http://www.haskell.org/haddock/";
      description = "Library exposing some functionality of Haddock";
      license = stdenv.lib.licenses.bsd3;
    }) {};

  template-haskell-ghcjs = callPackage
    ({ mkDerivation, base, ghc-boot-th, pretty, stdenv }:
    mkDerivation {
      pname = "template-haskell-ghcjs";
      version = "2.14.0.0";
      src = configuredSrc + /lib/template-haskell-ghcjs;
      libraryHaskellDepends = [ base ghc-boot-th pretty ];
      description = "Support library for Template Haskell (customized for GHCJS)";
      license = stdenv.lib.licenses.bsd3;
    }) {};

}
