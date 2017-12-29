{ pkgs, stdenv, callPackage }: self:
let src = pkgs.fetchFromGitHub
      { owner = "haskell";
        repo = "haskell-ide-engine";
        rev = "3ec8e93e9ca751cf282556998851ffa65f32e06b";
        sha256 = "1wzqzvsa39c1cngmmjryqrq4vqdg6d4wp5wdf17vp96ljvz1cczw";
      };
    cabal-helper-src = pkgs.fetchgit
      { url = "https://gitlab.com/dxld/cabal-helper.git";
        rev = "4bfc6b916fcc696a5d82e7cd35713d6eabcb0533";
        sha256 = "1a8231as0wdvi0q73ha9lc0qrx23kmcwf910qaicvmdar5p2b15m";
      };
    ghc-dump-tree-src = pkgs.fetchgit
      { url = "https://gitlab.com/alanz/ghc-dump-tree.git";
        rev = "50f8b28fda675cca4df53909667c740120060c49";
        sha256 = "0v3r81apdqp91sv7avy7f0s3im9icrakkggw8q5b7h0h4js6irqj";
      };
    ghc-mod-src = pkgs.fetchFromGitHub
      { owner = "wz1000";
        repo = "ghc-mod";
        rev = "03c91ea53b6389e7a1fcf4e471171aa3d6c8de41";
        sha256 = "11iic93klsh5izp8v4mhl7vnnlib821cfhdymlpg4drx7zbm9il6";
      };
    HaRe-src = pkgs.fetchgit
      { url = "https://gitlab.com/alanz/HaRe.git";
        rev = "e325975450ce89d790ed3f92de3ef675967d9538";
        sha256 = "0z7r3l4j5a1brz7zb2rgd985m58rs0ki2p59y1l9i46fcy8r9y4g";
      };
    cabal-helper = self.cabal-helper_hie;
    haddock-library = self.haddock-library_1_4_4;
    ghc-dump-tree = self.ghc-dump-tree_hie;
    ghc-mod = self.ghc-mod_hie;
    HaRe = self.HaRe_hie;
in
  { ### Overrides required by hie
    cabal-helper_hie = callPackage
      ({ mkDerivation, base, bytestring, Cabal, cabal-install, containers
       , directory, exceptions, filepath, ghc-prim, mtl, process
       , semigroupoids, template-haskell, temporary, transformers
       , unix, unix-compat, utf8-string
       }:
       mkDerivation {
         pname = "cabal-helper";
         version = "0.8.0.0";
         src = cabal-helper-src;
         isLibrary = true;
         isExecutable = true;
         jailbreak = true;
         setupHaskellDepends = [ base Cabal directory filepath ];
         libraryHaskellDepends = [
           base Cabal directory filepath ghc-prim mtl process semigroupoids
           transformers unix unix-compat
         ];
         executableHaskellDepends = [
           base bytestring Cabal containers directory exceptions filepath
           ghc-prim mtl process template-haskell temporary transformers unix
           unix-compat utf8-string
         ];
         testHaskellDepends = [
           base bytestring Cabal directory exceptions filepath ghc-prim mtl
           process template-haskell temporary transformers unix unix-compat
           utf8-string
         ];
         testToolDepends = [ cabal-install ];
         postInstall =
           ''
             libexec="$out/libexec/$(basename $out/lib/ghc*/*ghc*)/$name"
             mkdir -p "$libexec"
             ln -sv $out/bin/cabal-helper-wrapper "$libexec"
           '';
         doCheck = false;
         description = "Simple interface to some of Cabal's configuration state, mainly used by ghc-mod";
         license = stdenv.lib.licenses.agpl3;
       }) {};
    ghc-dump-tree_hie = callPackage
      ({ mkDerivation, aeson, base, bytestring, ghc, optparse-applicative
       , pretty, pretty-show, process, unordered-containers
       , vector
       }:
       mkDerivation {
         pname = "ghc-dump-tree";
         version = "0.2.0.1";
         src = ghc-dump-tree-src;
         isLibrary = true;
         isExecutable = true;
         libraryHaskellDepends = [
           aeson base bytestring ghc pretty pretty-show process
           unordered-containers vector
         ];
         executableHaskellDepends = [
           aeson base bytestring ghc optparse-applicative pretty pretty-show
           process unordered-containers vector
         ];
         homepage = "https://github.com/edsko/ghc-dump-tree";
         description = "Dump GHC's parsed, renamed, and type checked ASTs";
         license = stdenv.lib.licenses.bsd3;
       }) {};
    ghc-mod-core = callPackage
      ({ mkDerivation, base, binary, bytestring, Cabal, cabal-helper
       , containers, deepseq, directory, djinn-ghc, extra, fclabels
       , filepath, fingertree, ghc, ghc-boot, ghc-paths, ghc-syb-utils
       , haskell-src-exts, hlint, monad-control, monad-journal, mtl
       , old-time, optparse-applicative, pipes, process, safe, semigroups
       , split, syb, template-haskell, temporary, text, time
       , transformers, transformers-base
       }:
       mkDerivation {
         pname = "ghc-mod-core";
         version = "5.9.0.0";
         src = "${ghc-mod-src}/core";
         setupHaskellDepends = [
           base Cabal containers directory filepath process template-haskell
           transformers
         ];
         libraryHaskellDepends = [
           base binary bytestring cabal-helper containers deepseq directory
           djinn-ghc extra fclabels filepath fingertree ghc ghc-boot ghc-paths
           ghc-syb-utils haskell-src-exts hlint monad-control monad-journal
           mtl old-time optparse-applicative pipes process safe semigroups
           split syb template-haskell temporary text time transformers
           transformers-base
         ];
         homepage = "https://github.com/DanielG/ghc-mod";
         description = "Happy Haskell Hacking";
         license = stdenv.lib.licenses.agpl3;
       }) { inherit cabal-helper; };
    ghc-mod_hie = callPackage
      ({ mkDerivation, base, binary, bytestring, Cabal, cabal-doctest
       , cabal-helper, containers, criterion, deepseq, directory
       , djinn-ghc, doctest, extra, fclabels, filepath, ghc, ghc-boot
       , ghc-mod-core, ghc-paths, ghc-syb-utils, haskell-src-exts, hlint
       , hspec, monad-control, monad-journal, mtl, old-time
       , optparse-applicative, pipes, process, safe, semigroups, shelltest
       , split, syb, template-haskell, temporary, text, time
       , transformers, transformers-base
       }:
       mkDerivation {
         pname = "ghc-mod";
         version = "5.9.0.0";
         src = ghc-mod-src;
         isLibrary = true;
         isExecutable = true;
         enableSeparateDataOutput = true;
         setupHaskellDepends = [
           base Cabal cabal-doctest containers directory filepath process
           template-haskell transformers
         ];
         libraryHaskellDepends = [
           base binary bytestring cabal-helper containers deepseq directory
           djinn-ghc extra fclabels filepath ghc ghc-boot ghc-mod-core
           ghc-paths ghc-syb-utils haskell-src-exts hlint monad-control
           monad-journal mtl old-time optparse-applicative pipes process safe
           semigroups split syb template-haskell temporary text time
           transformers transformers-base
         ];
         executableHaskellDepends = [
           base binary deepseq directory fclabels filepath ghc ghc-mod-core
           monad-control mtl old-time optparse-applicative process semigroups
           split time
         ];
         testHaskellDepends = [
           base cabal-helper containers directory doctest fclabels filepath
           ghc ghc-boot ghc-mod-core hspec monad-journal mtl process split
           temporary transformers
         ];
         testToolDepends = [ shelltest ];
         # Doesn't work with our doctest
         doCheck = false;
         benchmarkHaskellDepends = [
           base criterion directory filepath ghc-mod-core temporary
         ];
         homepage = "https://github.com/DanielG/ghc-mod";
         description = "Happy Haskell Hacking";
         license = stdenv.lib.licenses.agpl3;
       }) { shelltest = null; inherit cabal-helper; };
    HaRe_hie = callPackage
      ({ mkDerivation, attoparsec, base, base-prelude, Cabal, cabal-helper
       , case-insensitive, containers, conversion
       , conversion-case-insensitive, conversion-text, Diff, directory
       , filepath, foldl, ghc, ghc-exactprint, ghc-mod-core, ghc-syb-utils
       , gitrev, hslogger, hspec, HUnit, monad-control, mtl
       , optparse-applicative, optparse-simple, parsec, stdenv
       , Strafunski-StrategyLib, syb, syz, turtle
       }:
       mkDerivation {
         pname = "HaRe";
         version = "0.8.4.1";
         src = HaRe-src;
         isLibrary = true;
         isExecutable = true;
         enableSeparateDataOutput = true;
         libraryHaskellDepends = [
           base cabal-helper containers directory filepath ghc ghc-exactprint
           ghc-mod-core ghc-syb-utils hslogger monad-control mtl
           Strafunski-StrategyLib syb syz
         ];
         executableHaskellDepends = [
           base Cabal ghc-mod-core gitrev mtl optparse-applicative
           optparse-simple
         ];
         testHaskellDepends = [
           attoparsec base base-prelude cabal-helper case-insensitive
           containers conversion conversion-case-insensitive conversion-text
           Diff directory filepath foldl ghc ghc-exactprint ghc-mod-core
           ghc-syb-utils hslogger hspec HUnit monad-control mtl parsec
           Strafunski-StrategyLib syb syz turtle
         ];
         # Test directory doesn't exist
         doCheck = false;
         homepage = "https://github.com/RefactoringTools/HaRe/wiki";
         description = "the Haskell Refactorer";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit cabal-helper; };
    ### hie packages
    haskell-ide-engine = callPackage
      ({ mkDerivation, aeson, async, base, bytestring, Cabal, cabal-install
       , containers, data-default, Diff, directory, either, ekg, filepath, ghc
       , ghc-mod-core, gitrev, haskell-lsp, hie-apply-refact, hie-base
       , hie-brittany, hie-build-plugin, hie-eg-plugin-async
       , hie-example-plugin2, hie-ghc-mod, hie-ghc-tree, hie-haddock
       , hie-hare, hie-hoogle, hie-plugin-api, hoogle, hslogger, hspec
       , lens, mtl, optparse-simple, QuickCheck, quickcheck-instances
       , sorted-list, stm, text, time, transformers
       , unordered-containers, vector, vinyl, yaml, yi-rope
       }:
       mkDerivation {
         pname = "haskell-ide-engine";
         version = "0.1.0.0";
         inherit src;
         isLibrary = true;
         isExecutable = true;
         libraryHaskellDepends = [
           aeson async base bytestring Cabal containers data-default directory
           either filepath ghc ghc-mod-core gitrev haskell-lsp
           hie-apply-refact hie-base hie-brittany hie-ghc-mod hie-haddock
           hie-hare hie-hoogle hie-plugin-api hslogger lens mtl
           optparse-simple sorted-list stm text transformers
           unordered-containers vector yi-rope
         ];
         executableHaskellDepends = [
           base Cabal containers directory ekg ghc-mod-core gitrev haskell-lsp
           hie-apply-refact hie-build-plugin hie-eg-plugin-async
           hie-example-plugin2 hie-ghc-mod hie-ghc-tree hie-hare hie-hoogle
           hie-plugin-api hslogger optparse-simple stm text time transformers
           unordered-containers vinyl
         ];
         testHaskellDepends = [
           aeson base containers Diff directory filepath ghc-mod-core
           haskell-lsp hie-apply-refact hie-base hie-eg-plugin-async
           hie-example-plugin2 hie-ghc-mod hie-ghc-tree hie-hare hie-hoogle
           hie-plugin-api hoogle hslogger hspec QuickCheck
           quickcheck-instances stm text transformers unordered-containers
           vector vinyl yaml
         ];
         preCheck = "export HOME=$NIX_BUILD_TOP/home; mkdir $HOME";
         # https://github.com/haskell/haskell-ide-engine/issues/425
         # The disabled tests do work in a local nix-shell with cabal available.
         patches = [ ./patches/hie-testsuite.patch ];
         homepage = "http://github.com/githubuser/haskell-ide-engine#readme";
         description = "Provide a common engine to power any Haskell IDE";
         license = stdenv.lib.licenses.bsd3;
      }) {};
    hie-apply-refact = callPackage
      ({ mkDerivation, aeson, apply-refact, base, either, extra, ghc-mod
       , ghc-mod-core, haskell-src-exts, hie-base, hie-plugin-api, hlint
       , text, transformers
       }:
       mkDerivation {
         pname = "hie-apply-refact";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-apply-refact";
         libraryHaskellDepends = [
           aeson apply-refact base either extra ghc-mod ghc-mod-core
           haskell-src-exts hie-base hie-plugin-api hlint text transformers
         ];
         description = "Haskell IDE Apply Refact plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-mod; };
    hie-base = callPackage
      ({ mkDerivation, aeson, base, haskell-lsp, text }:
       mkDerivation {
         pname = "hie-base";
         version = "0.1.0.0";
         inherit src;
         preUnpack = "sourceRoot=source/hie-base";
         libraryHaskellDepends = [ aeson base haskell-lsp text ];
         description = "Haskell IDE API base types";
         license = stdenv.lib.licenses.bsd3;
       }) {};
    hie-brittany = callPackage
      ({ mkDerivation, aeson, base, brittany, ghc-mod, ghc-mod-core
       , haskell-lsp, hie-plugin-api, lens, text
       }:
       mkDerivation {
         pname = "hie-brittany";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-brittany";
         libraryHaskellDepends = [
           aeson base brittany ghc-mod ghc-mod-core haskell-lsp hie-plugin-api
           lens text
         ];
         description = "Haskell IDE Hoogle plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-mod; };
    hie-build-plugin = callPackage
      ({ mkDerivation, aeson, base, bytestring, Cabal, cabal-helper
       , containers, directory, filepath, haskell-lsp, hie-plugin-api
       , process, stm, text, transformers, yaml
       }:
       mkDerivation {
         pname = "hie-build-plugin";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-build-plugin";
         libraryHaskellDepends = [
           aeson base bytestring Cabal cabal-helper containers directory
           filepath haskell-lsp hie-plugin-api process stm text transformers
           yaml
         ];
         description = "Haskell IDE build plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit cabal-helper; };
    hie-eg-plugin-async = callPackage
      ({ mkDerivation, base, ghc-mod-core, hie-plugin-api, stm
       , text
       }:
       mkDerivation {
         pname = "hie-eg-plugin-async";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-eg-plugin-async";
         libraryHaskellDepends = [
           base ghc-mod-core hie-plugin-api stm text
         ];
         description = "Haskell IDE example plugin, using async processes";
         license = stdenv.lib.licenses.bsd3;
       }) {};
    hie-example-plugin2 = callPackage
      ({ mkDerivation, base, hie-plugin-api, text }:
       mkDerivation {
         pname = "hie-example-plugin2";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-example-plugin2";
         libraryHaskellDepends = [ base hie-plugin-api text ];
         description = "Haskell IDE example plugin";
         license = stdenv.lib.licenses.bsd3;
       }) {};
    hie-ghc-mod = callPackage
      ({ mkDerivation, aeson, base, containers, ghc, ghc-mod, ghc-mod-core
       , hie-base, hie-plugin-api, text, transformers
       }:
       mkDerivation {
         pname = "hie-ghc-mod";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-ghc-mod";
         libraryHaskellDepends = [
           aeson base containers ghc ghc-mod ghc-mod-core hie-base
           hie-plugin-api text transformers
         ];
         description = "Haskell IDE ghc-mod plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-mod; };
    hie-ghc-tree = callPackage
      ({ mkDerivation, aeson, base, ghc-dump-tree, ghc-mod, ghc-mod-core
       , hie-base, hie-plugin-api, text
       }:
       mkDerivation {
         pname = "hie-ghc-tree";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-ghc-tree";
         libraryHaskellDepends = [
           aeson base ghc-dump-tree ghc-mod ghc-mod-core hie-base
           hie-plugin-api text
         ];
         description = "Haskell IDE GHC Tree plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-dump-tree ghc-mod; };
    hie-haddock = callPackage
      ({ mkDerivation, aeson, base, containers, directory, either
       , filepath, ghc, ghc-exactprint, ghc-mod, ghc-mod-core, haddock-api
       , haddock-library, HaRe, haskell-lsp, hie-base, hie-ghc-mod
       , hie-hare, hie-plugin-api, lens, monad-control, mtl, text
       , transformers
       }:
       mkDerivation {
         pname = "hie-haddock";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-haddock";
         libraryHaskellDepends = [
           aeson base containers directory either filepath ghc ghc-exactprint
           ghc-mod ghc-mod-core haddock-api haddock-library HaRe haskell-lsp
           hie-base hie-ghc-mod hie-hare hie-plugin-api lens monad-control mtl
           text transformers
         ];
         description = "Haskell IDE Haddock plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit haddock-library HaRe ghc-mod; };
    hie-hare = callPackage
      ({ mkDerivation, aeson, base, containers, Diff, either, ghc
       , ghc-exactprint, ghc-mod, ghc-mod-core, HaRe, haskell-lsp
       , hie-base, hie-ghc-mod, hie-plugin-api, lens, monad-control, mtl
       , text, transformers
       }:
       mkDerivation {
         pname = "hie-hare";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-hare";
         libraryHaskellDepends = [
           aeson base containers Diff either ghc ghc-exactprint ghc-mod
           ghc-mod-core HaRe haskell-lsp hie-base hie-ghc-mod hie-plugin-api
           lens monad-control mtl text transformers
         ];
         description = "Haskell IDE HaRe plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-mod HaRe; };
    hie-hoogle = callPackage
      ({ mkDerivation, aeson, base, directory, filepath, ghc-mod
       , ghc-mod-core, hie-plugin-api, hoogle, tagsoup, text
       }:
       mkDerivation {
         pname = "hie-hoogle";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-hoogle";
         libraryHaskellDepends = [
           aeson base directory filepath ghc-mod ghc-mod-core hie-plugin-api
           hoogle tagsoup text
         ];
         description = "Haskell IDE Hoogle plugin";
         license = stdenv.lib.licenses.bsd3;
       }) { inherit ghc-mod; };
    hie-plugin-api = callPackage
      ({ mkDerivation, aeson, base, containers, Diff, directory, either
       , filepath, fingertree, ghc, ghc-mod-core, haskell-lsp, hie-base
       , hslogger, lifted-base, monad-control, mtl, stdenv, stm, syb, text
       , time, transformers, unordered-containers
       }:
       mkDerivation {
         pname = "hie-plugin-api";
         version = "0.1.0.0";
         inherit src;
         postUnpack = "sourceRoot=source/hie-plugin-api";
         libraryHaskellDepends = [
           aeson base containers Diff directory either filepath fingertree ghc
           ghc-mod-core haskell-lsp hie-base hslogger lifted-base
           monad-control mtl stm syb text time transformers
           unordered-containers
         ];
         description = "Haskell IDE API for plugin communication";
         license = stdenv.lib.licenses.bsd3;
       }) {};
  }
