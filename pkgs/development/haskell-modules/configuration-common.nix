# COMMON OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS
#
# This file contains haskell package overrides that are shared by all
# haskell package sets provided by nixpkgs and distributed via the official
# NixOS hydra instance.
#
# Overrides that would also make sense for custom haskell package sets not provided
# as part of nixpkgs and that are specific to Nix should go in configuration-nix.nix
#
# See comment at the top of configuration-nix.nix for more information about this
# distinction.
{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch fetchpatch2 lib;
  inherit (lib) throwIfNot versionOlder versions;
in

with haskellLib;

self: super: {
  # Make sure that Cabal 3.10.* can be built as-is
  Cabal_3_10_3_0 = doDistribute (super.Cabal_3_10_3_0.override ({
    Cabal-syntax = self.Cabal-syntax_3_10_3_0;
  } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.2.5") {
    # Use process core package when possible
    process = self.process_1_6_20_0;
  }));

  # cabal-install needs most recent versions of Cabal and Cabal-syntax,
  # so we need to put some extra work for non-latest GHCs
  inherit (
    let
      # !!! Use cself/csuper inside for the actual overrides
      cabalInstallOverlay = cself: csuper:
        {
          # Needs to be downgraded compared to Stackage LTS 21
          resolv = cself.resolv_0_1_2_0;
        } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.10") {
          Cabal = cself.Cabal_3_10_3_0;
          Cabal-syntax = cself.Cabal-syntax_3_10_3_0;
        } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.4") {
          # We need at least directory >= 1.3.7.0. Using the latest version
          # 1.3.8.* is not an option since it causes very annoying dependencies
          # on newer versions of unix and filepath than GHC 9.2 ships
          directory = cself.directory_1_3_7_1;
          # GHC 9.2.5 starts shipping 1.6.16.0 which is required by
          # cabal-install, but we need to recompile process even if the correct
          # version is available to prevent inconsistent dependencies:
          # process depends on directory.
          process = cself.process_1_6_20_0;

          # Prevent dependency on doctest which causes an inconsistent dependency
          # due to depending on ghc which depends on directory etc.
          vector = dontCheck csuper.vector;
        };
    in
    {
      cabal-install = super.cabal-install.overrideScope cabalInstallOverlay;
      cabal-install-solver = super.cabal-install-solver.overrideScope cabalInstallOverlay;

      # Needs cabal-install >= 3.8 /as well as/ matching Cabal
      guardian =
        lib.pipe
          (super.guardian.overrideScope cabalInstallOverlay)
          [
            # Tests need internet access (run stack)
            dontCheck
            # May as well…
            (self.generateOptparseApplicativeCompletions [ "guardian" ])
          ];
    }
  ) cabal-install
    cabal-install-solver
    guardian
  ;

  # Extensions wants the latest version of Cabal for its list of Haskell
  # language extensions.
  # 2024-01-15: jailbreak to allow hspec-hedgehog 0.1.1.0 https://github.com/kowainik/extensions/pull/92
  extensions = doJailbreak (super.extensions.override {
    Cabal =
      if versionOlder self.ghc.version "9.6"
      then self.Cabal_3_10_3_0
      else null; # use GHC bundled version
  });

  #######################################
  ### HASKELL-LANGUAGE-SERVER SECTION ###
  #######################################

  haskell-language-server = dontCheck (super.haskell-language-server.overrideScope (lself: lsuper: {
    # For most ghc versions, we overrideScope Cabal in the configuration-ghc-???.nix,
    # because some packages, like ormolu, need a newer Cabal version.
    # ghc-paths is special because it depends on Cabal for building
    # its Setup.hs, and therefor declares a Cabal dependency, but does
    # not actually use it as a build dependency.
    # That means ghc-paths can just use the ghc included Cabal version,
    # without causing package-db incoherence and we should do that because
    # otherwise we have different versions of ghc-paths
    # around which have the same abi-hash, which can lead to confusions and conflicts.
    ghc-paths = lsuper.ghc-paths.override { Cabal = null; };
  }));

  # For -f-auto see cabal.project in haskell-language-server.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser (disableCabalFlag "auto" super.ghc-lib-parser-ex);

  ###########################################
  ### END HASKELL-LANGUAGE-SERVER SECTION ###
  ###########################################

  # Test ldap server test/ldap.js is missing from sdist
  # https://github.com/supki/ldap-client/issues/18
  ldap-client-og = dontCheck super.ldap-client-og;

  # Support for template-haskell >= 2.16
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  vector = overrideCabal (old: {
    # Too strict bounds on doctest which isn't used, but is part of the configuration
    jailbreak = true;
    # vector-doctest seems to be broken when executed via ./Setup test
    testTarget = lib.concatStringsSep " " [
      "vector-tests-O0"
      "vector-tests-O2"
    ];
  }) super.vector;

  # Almost guaranteed failure due to floating point imprecision with QuickCheck-2.14.3
  # https://github.com/haskell/math-functions/issues/73
  math-functions = overrideCabal (drv: {
    testFlags = drv.testFlags or [] ++ [ "-p" "! /Kahan.t_sum_shifted/" ];
  }) super.math-functions;

  # Too strict bounds on base
  # https://github.com/lspitzner/butcher/issues/7#issuecomment-1681394943
  butcher = doJailbreak super.butcher;
  # https://github.com/lspitzner/data-tree-print/issues/4
  data-tree-print = doJailbreak super.data-tree-print;
  # … and template-haskell.
  # https://github.com/lspitzner/czipwith/issues/5
  czipwith = doJailbreak super.czipwith;

  # jacinda needs latest version of alex
  jacinda = super.jacinda.override {
    alex = self.alex_3_5_1_0;
  };

  aeson =
    # aeson's test suite includes some tests with big numbers that fail on 32bit
    # https://github.com/haskell/aeson/issues/1060
    dontCheckIf pkgs.stdenv.hostPlatform.is32bit
    # Deal with infinite and NaN values generated by QuickCheck-2.14.3
    (appendPatches [
      (pkgs.fetchpatch {
        name = "aeson-quickcheck-2.14.3-double-workaround.patch";
        url = "https://github.com/haskell/aeson/commit/58766a1916b4980792763bab74f0c86e2a7ebf20.patch";
        sha256 = "1jk2xyi9g6dfjsi6hvpvkpmag3ivimipwy1izpbidf3wvc9cixs3";
      })
    ] super.aeson);

  # 2023-06-28: Test error: https://hydra.nixos.org/build/225565149
  orbits = dontCheck super.orbits;

  # Too strict bounds on hspec < 2.11
  http-api-data = doJailbreak super.http-api-data;
  tasty-discover = doJailbreak super.tasty-discover;

  # Allow aeson == 2.1.*
  # https://github.com/hdgarrood/aeson-better-errors/issues/23
  aeson-better-errors = lib.pipe super.aeson-better-errors [
    doJailbreak
    (appendPatches [
      # https://github.com/hdgarrood/aeson-better-errors/pull/25
      (fetchpatch {
        name = "mtl-2-3.patch";
        url = "https://github.com/hdgarrood/aeson-better-errors/commit/1ec49ab7d1472046b680b5a64ae2930515b47714.patch";
        hash = "sha256-xuuocWxSoBDclVp0bJ9UrDamVcDVOAFgJIi/un1xBvk=";
      })
    ])
  ];

  # https://github.com/mpickering/eventlog2html/pull/187
  eventlog2html = lib.pipe super.eventlog2html [
    doJailbreak
    (appendPatch (fetchpatch {
      name = "blaze-html-compat.patch";
      url = "https://github.com/mpickering/eventlog2html/commit/666aee9ee44c571173a73036b36ad4154c188481.patch";
      sha256 = "sha256-9PLygLEpJ6pAZ31gSWiEMqWxmvElT6Unc/pgr6ULIaw=";
    }))
   ];

  # 2023-08-09: Jailbreak because of vector < 0.13
  # 2023-11-09: don't check because of https://github.com/tweag/monad-bayes/pull/326
  monad-bayes = dontCheck (doJailbreak super.monad-bayes);

  # Disable tests failing on odd floating point numbers generated by QuickCheck 2.14.3
  # https://github.com/haskell/statistics/issues/205
  statistics = overrideCabal (drv: {
    testFlags = [
      "-p" "! (/Pearson correlation/ || /t_qr/ || /Tests for: FDistribution.1-CDF is correct/)"
    ];
  }) super.statistics;

  # There are numerical tests on random data, that may fail occasionally
  lapack = dontCheck super.lapack;

  # currently, cabal-plan seems to get not much maintenance
  cabal-plan = doJailbreak super.cabal-plan;

  # test dependency has incorrect upper bound but still supports the newer dependency
  # https://github.com/fused-effects/fused-effects/issues/451
  # https://github.com/fused-effects/fused-effects/pull/452
  fused-effects = doJailbreak super.fused-effects;

  # support for transformers >= 0.6
  fused-effects-random = doJailbreak super.fused-effects-random;
  fused-effects-readline = doJailbreak super.fused-effects-readline;

  # fix tests failure for base≥4.15 (https://github.com/kim/leveldb-haskell/pull/41)
  leveldb-haskell = appendPatch (fetchpatch {
    url = "https://github.com/kim/leveldb-haskell/commit/f5249081f589233890ddb1945ec548ca9fb717cf.patch";
    sha256 = "14gllipl28lqry73c5dnclsskzk1bsrrgazibl4lkl8z98j2csjb";
  }) super.leveldb-haskell;

  # Arion's test suite needs a Nixpkgs, which is cumbersome to do from Nixpkgs
  # itself. For instance, pkgs.path has dirty sources and puts a huge .git in the
  # store. Testing is done upstream.
  arion-compose = dontCheck super.arion-compose;

  # 2023-07-17: Outdated base bound https://github.com/srid/lvar/issues/5
  lvar = doJailbreak super.lvar;

  # This used to be a core package provided by GHC, but then the compiler
  # dropped it. We define the name here to make sure that old packages which
  # depend on this library still evaluate (even though they won't compile
  # successfully with recent versions of the compiler).
  bin-package-db = null;

  # Unnecessarily requires alex >= 3.3
  # https://github.com/glguy/config-value/commit/c5558c8258598fab686c259bff510cc1b19a0c50#commitcomment-119514821
  config-value = doJailbreak super.config-value;

  # path-io bound is adjusted in 0.6.1 release
  # https://github.com/tek/hix/commit/019426f6a3db256e4c96558ffe6fa2114e2f19a0
  hix = doJailbreak super.hix;

  # waiting for release: https://github.com/jwiegley/c2hsc/issues/41
  c2hsc = appendPatch (fetchpatch {
    url = "https://github.com/jwiegley/c2hsc/commit/490ecab202e0de7fc995eedf744ad3cb408b53cc.patch";
    sha256 = "1c7knpvxr7p8c159jkyk6w29653z5yzgjjqj11130bbb8mk9qhq7";
  }) super.c2hsc;

  # Some Hackage packages reference this attribute, which exists only in the
  # GHCJS package set. We provide a dummy version here to fix potential
  # evaluation errors.
  ghcjs-base = null;
  ghcjs-prim = null;

  ghc-debug-client = doJailbreak super.ghc-debug-client;

  # Test failure.  Tests also disabled in Stackage:
  # https://github.com/jtdaugherty/brick/issues/499
  brick = dontCheck super.brick;

  # Needs older QuickCheck version
  attoparsec-varword = dontCheck super.attoparsec-varword;

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;
  ghc-vis = disableLibraryProfiling super.ghc-vis;

  # Fixes compilation for basement on i686 for GHC >= 9.4
  # https://github.com/haskell-foundation/foundation/pull/573
  # Patch would not work for GHC >= 9.2 where it breaks compilation on x86_64
  # https://github.com/haskell-foundation/foundation/pull/573#issuecomment-1669468867
  # TODO(@sternenseemann): make unconditional
  basement = appendPatches (lib.optionals pkgs.stdenv.hostPlatform.is32bit [
    (fetchpatch {
      name = "basement-i686-ghc-9.4.patch";
      url = "https://github.com/haskell-foundation/foundation/pull/573/commits/38be2c93acb6f459d24ed6c626981c35ccf44095.patch";
      sha256 = "17kz8glfim29vyhj8idw8bdh3id5sl9zaq18zzih3schfvyjppj7";
      stripLen = 1;
    })
  ]) super.basement;

  # Fixes compilation of memory with GHC >= 9.4 on 32bit platforms
  # https://github.com/vincenthz/hs-memory/pull/99
  memory = appendPatches (lib.optionals pkgs.stdenv.hostPlatform.is32bit [
    (fetchpatch {
      name = "memory-i686-ghc-9.4.patch";
      url = "https://github.com/vincenthz/hs-memory/pull/99/commits/2738929ce15b4c8704bbbac24a08539b5d4bf30e.patch";
      sha256 = "196rj83iq2k249132xsyhbbl81qi1j23h9pa6mmk6zvxpcf63yfw";
    })
  ]) super.memory;

  # Depends on outdated deps hedgehog < 1.4, doctest < 0.12 for tests
  # As well as deepseq < 1.5 (so it forbids GHC 9.8)
  hw-fingertree = doJailbreak super.hw-fingertree;

  # 2024-03-10: Maintainance stalled, fixes unmerged: https://github.com/haskell/ThreadScope/pull/130
  threadscope = overrideCabal (drv: {
    prePatch = drv.prePatch or "" + ''
      ${pkgs.buildPackages.dos2unix}/bin/dos2unix *.cabal
    '';
    editedCabalFile = null;
    revision = null;
  })
  (appendPatches [
    (fetchpatch {
      name = "loosen-bounds-1.patch";
      url = "https://github.com/haskell/ThreadScope/commit/8f9f21449adb3af07eed539dcaf267c9c9ee987b.patch";
      sha256 = "sha256-egKM060QplSmUeDptHXoSom1vf5KBrvNcjb2Vk59N7A=";
    })
    (fetchpatch {
      name = "loosen-bounds-2.patch";
      url = "https://github.com/haskell/ThreadScope/commit/f366a9ee455eda16cd6a4dc26f0275e2cf2b5798.patch";
      sha256 = "sha256-DaPTK5LRbZZS1KDIr5X/eXQasqtofrCteTbUQUZPu0Q=";
    })
    (fetchpatch {
      name = "loosen-bounds-3.patch";
      url = "https://github.com/haskell/ThreadScope/commit/12819abaa2322976004b7582e598db1cf952707a.patch";
      sha256 = "sha256-r7MVw8wwKU4R5VmcypBzhOBfTlRCISoRJtwie3+2Vb0=";
    })
    (fetchpatch {
      name = "import-monad.patch";
      url = "https://github.com/haskell/ThreadScope/commit/8846508e9769a8dfd82b3ff66259ba4d58255932.patch";
      sha256 = "sha256-wBqDJWmqvmU1sFuw/ZlxHOb8xPhZO2RBuyYFP9bJCVI=";
    })
  ]
    super.threadscope);

  # http2 also overridden in all-packages.nix for mailctl.
  # twain is currently only used by mailctl, so the .overrideScope shouldn't
  # negatively affect any other packages, at least currently...
  # https://github.com/alexmingoia/twain/issues/5
  twain = super.twain.overrideScope (self: _: {
    http2 = self.http2_3_0_3;
    warp = self.warp_3_3_30;
  });

  # The latest release on hackage has an upper bound on containers which
  # breaks the build, though it works with the version of containers present
  # and the upper bound doesn't exist in code anymore:
  # > https://github.com/roelvandijk/numerals
  numerals = doJailbreak (dontCheck super.numerals);

  # Bound on containers is too strict but jailbreak doesn't work with conditional flags
  # https://github.com/NixOS/jailbreak-cabal/issues/24
  containers-unicode-symbols = overrideCabal {
    postPatch = ''
      substituteInPlace containers-unicode-symbols.cabal \
        --replace 'containers >= 0.5 && < 0.6.5' 'containers'
    '';
  } super.containers-unicode-symbols;

  # Test file not included on hackage
  numerals-base = dontCheck (doJailbreak super.numerals-base);

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;
  mysql-haskell = dontCheck super.mysql-haskell;

  # Test data missing
  # https://github.com/FPtje/GLuaFixer/issues/165
  glualint = dontCheck super.glualint;

  # The Hackage tarball is purposefully broken, because it's not intended to be, like, useful.
  # https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  git-annex = overrideCabal (drv: {
    src = pkgs.fetchgit {
      name = "git-annex-${super.git-annex.version}-src";
      url = "git://git-annex.branchable.com/";
      rev = "refs/tags/" + super.git-annex.version;
      sha256 = "sha256-adV7I1P0O/dqH1rEyf3c2Vp4GSiiHReJyqnkSOYQGT0=";
      # delete android and Android directories which cause issues on
      # darwin (case insensitive directory). Since we don't need them
      # during the build process, we can delete it to prevent a hash
      # mismatch on darwin.
      postFetch = ''
        rm -r $out/doc/?ndroid*
      '';
    };

    patches = drv.patches or [ ] ++ [
      # Prevent .desktop files from being installed to $out/usr/share.
      # TODO(@sternenseemann): submit upstreamable patch resolving this
      # (this should be possible by also taking PREFIX into account).
      ./patches/git-annex-no-usr-prefix.patch
    ];
  }) super.git-annex;

  # Too strict bounds on servant
  # Pending a hackage revision: https://github.com/berberman/arch-web/commit/5d08afee5b25e644f9e2e2b95380a5d4f4aa81ea#commitcomment-89230555
  arch-web = doJailbreak super.arch-web;

  # Too strict upper bound on hedgehog
  # https://github.com/circuithub/rel8/issues/248
  rel8 = doJailbreak super.rel8;

  # Fix test trying to access /home directory
  shell-conduit = overrideCabal (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";
  }) super.shell-conduit;

  # https://github.com/serokell/nixfmt/issues/130
  nixfmt = doJailbreak super.nixfmt;

  # Too strict upper bounds on turtle and text
  # https://github.com/awakesecurity/nix-deploy/issues/35
  nix-deploy = doJailbreak super.nix-deploy;

  # Too strict upper bound on algebraic-graphs
  # https://github.com/awakesecurity/nix-graph/issues/5
  nix-graph = doJailbreak super.nix-graph;

  # Manually maintained
  cachix-api = overrideCabal (drv: {
    version = "1.7.4";
    src = pkgs.fetchFromGitHub {
      owner = "cachix";
      repo = "cachix";
      rev = "v1.7.4";
      sha256 = "sha256-lHy5kgx6J8uD+16SO47dPrbob98sh+W1tf4ceSqPVK4=";
    };
    postUnpack = "sourceRoot=$sourceRoot/cachix-api";
  }) super.cachix-api;
  cachix = (overrideCabal (drv: {
    version = "1.7.4";
    src = pkgs.fetchFromGitHub {
      owner = "cachix";
      repo = "cachix";
      rev = "v1.7.4";
      sha256 = "sha256-lHy5kgx6J8uD+16SO47dPrbob98sh+W1tf4ceSqPVK4=";
    };
    postUnpack = "sourceRoot=$sourceRoot/cachix";
  }) (lib.pipe
        (super.cachix.override {
          nix = self.hercules-ci-cnix-store.nixPackage;
        })
        [
         (addBuildTool self.hercules-ci-cnix-store.nixPackage)
         (addBuildTool pkgs.buildPackages.pkg-config)
        ]
  ));

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # Tests require older versions of tasty.
  hzk = dontCheck super.hzk;
  resolv_0_1_2_0 = doJailbreak super.resolv_0_1_2_0;

  # Test suite doesn't compile with 9.6, 9.8
  # https://github.com/sebastiaanvisser/fclabels/issues/45
  # https://github.com/sebastiaanvisser/fclabels/issues/46
  fclabels = dontCheck super.fclabels;

  # Tests require a Kafka broker running locally
  haskakafka = dontCheck super.haskakafka;

  bindings-levmar = addExtraLibrary pkgs.blas super.bindings-levmar;

  # Requires wrapQtAppsHook
  qtah-cpp-qt5 = overrideCabal (drv: {
    buildDepends = [ pkgs.qt5.wrapQtAppsHook ];
  }) super.qtah-cpp-qt5;

  # The Haddock phase fails for one reason or another.
  deepseq-magic = dontHaddock super.deepseq-magic;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;

  # Fix build with time >= 1.10 while retaining compat with time < 1.9
  mbox = appendPatch ./patches/mbox-time-1.10.patch
    (overrideCabal { editedCabalFile = null; revision = null; } super.mbox);

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  inline-c-cpp = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace inline-c-cpp.cabal --replace "-optc-std=c++11" ""
    '';
  }) super.inline-c-cpp;

  inline-java = addBuildDepend pkgs.jdk super.inline-java;

  # Too strict upper bound on unicode-transforms
  # <https://gitlab.com/ngua/ipa-hs/-/issues/1>
  ipa = doJailbreak super.ipa;

  # Upstream notified by e-mail.
  permutation = dontCheck super.permutation;

  # https://github.com/jputcu/serialport/issues/25
  serialport = dontCheck super.serialport;

  # Test suite depends on source code being available
  simple-affine-space = dontCheck super.simple-affine-space;

  # Fails no apparent reason. Upstream has been notified by e-mail.
  assertions = dontCheck super.assertions;

  # 2023-01-29: Restrictive base bound already loosened on master but not released: https://github.com/sebastiaanvisser/clay/commit/4483bdf7a452903f177220958f1610030ab7f28a
  clay = throwIfNot (super.clay.version == "0.14.0") "Remove clay jailbreak in configuration-common.nix when you see this eval error." (doJailbreak super.clay);

  # These packages try to execute non-existent external programs.
  cmaes = dontCheck super.cmaes;                        # http://hydra.cryp.to/build/498725/log/raw
  dbmigrations = dontCheck super.dbmigrations;
  filestore = dontCheck super.filestore;
  graceful = dontCheck super.graceful;
  HList = dontCheck super.HList;
  ide-backend = dontCheck super.ide-backend;
  marquise = dontCheck super.marquise;                  # https://github.com/anchor/marquise/issues/69
  memcached-binary = dontCheck super.memcached-binary;
  msgpack-rpc = dontCheck super.msgpack-rpc;
  persistent-zookeeper = dontCheck super.persistent-zookeeper;
  pocket-dns = dontCheck super.pocket-dns;
  squeal-postgresql = dontCheck super.squeal-postgresql;
  postgrest-ws = dontCheck super.postgrest-ws;
  snowball = dontCheck super.snowball;
  sophia = dontCheck super.sophia;
  test-sandbox = dontCheck super.test-sandbox;
  texrunner = dontCheck super.texrunner;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  xkbcommon = dontCheck super.xkbcommon;
  xmlgen = dontCheck super.xmlgen;
  HerbiePlugin = dontCheck super.HerbiePlugin;
  wai-cors = dontCheck super.wai-cors;

  # 2022-01-29: Tests fail: https://github.com/psibi/streamly-bytestring/issues/27
  # 2022-02-14: Strict upper bound: https://github.com/psibi/streamly-bytestring/issues/30
  streamly-bytestring = dontCheck (doJailbreak super.streamly-bytestring);

  # 2024-05-18: Upstream tests against a different pandoc version
  pandoc-crossref = dontCheck super.pandoc-crossref;

  # base bound
  digit = doJailbreak super.digit;

  # 2022-01-29: Tests require package to be in ghc-db.
  aeson-schemas = dontCheck super.aeson-schemas;

  # 2023-04-20: Restrictive bytestring bound in tests.
  storablevector = doJailbreak super.storablevector;

  matterhorn = doJailbreak super.matterhorn;

  # Too strict bounds on transformers and resourcet
  # https://github.com/alphaHeavy/lzma-conduit/issues/23
  lzma-conduit = doJailbreak super.lzma-conduit;

  # 2020-06-05: HACK: does not pass own build suite - `dontCheck`
  # 2024-01-15: too strict bound on free < 5.2
  hnix = doJailbreak (dontCheck (super.hnix.override {
    # 2023-12-11: Needs older core due to remote
    hnix-store-core = self.hnix-store-core_0_6_1_0;
  }));


  # Too strict bounds on algebraic-graphs
  # https://github.com/haskell-nix/hnix-store/issues/180
  hnix-store-core_0_6_1_0 = doJailbreak super.hnix-store-core_0_6_1_0;
  # 2023-12-11: Needs older core
  hnix-store-remote = super.hnix-store-remote.override { hnix-store-core = self.hnix-store-core_0_6_1_0; };

  # Fails for non-obvious reasons while attempting to use doctest.
  focuslist = dontCheck super.focuslist;
  search = dontCheck super.search;

  # see https://github.com/LumiGuide/haskell-opencv/commit/cd613e200aa20887ded83256cf67d6903c207a60
  opencv = dontCheck (appendPatch ./patches/opencv-fix-116.patch super.opencv);
  opencv-extra = dontCheck (appendPatch ./patches/opencv-fix-116.patch super.opencv-extra);

  # https://github.com/ekmett/structures/issues/3
  structures = dontCheck super.structures;

  # Disable test suites to fix the build.
  acme-year = dontCheck super.acme-year;                # http://hydra.cryp.to/build/497858/log/raw
  aeson-lens = dontCheck super.aeson-lens;              # http://hydra.cryp.to/build/496769/log/raw
  aeson-schema = dontCheck super.aeson-schema;          # https://github.com/timjb/aeson-schema/issues/9
  angel = dontCheck super.angel;
  apache-md5 = dontCheck super.apache-md5;              # http://hydra.cryp.to/build/498709/nixlog/1/raw
  app-settings = dontCheck super.app-settings;          # http://hydra.cryp.to/build/497327/log/raw
  aws-kinesis = dontCheck super.aws-kinesis;            # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol;    # http://hydra.cryp.to/build/499749/log/raw
  binary-search = dontCheck super.binary-search;
  bloodhound = dontCheck super.bloodhound;              # https://github.com/plow-technologies/quickcheck-arbitrary-template/issues/10
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection;    # http://hydra.cryp.to/build/496948/log/raw
  cabal-meta = dontCheck super.cabal-meta;              # http://hydra.cryp.to/build/497892/log/raw
  camfort = dontCheck super.camfort;
  cjk = dontCheck super.cjk;
  CLI = dontCheck super.CLI;                            # Upstream has no issue tracker.
  command-qq = dontCheck super.command-qq;              # http://hydra.cryp.to/build/499042/log/raw
  conduit-connection = dontCheck super.conduit-connection;
  craftwerk = dontCheck super.craftwerk;
  crc = dontCheck super.crc;                            # https://github.com/MichaelXavier/crc/issues/2
  css-text = dontCheck super.css-text;
  damnpacket = dontCheck super.damnpacket;              # http://hydra.cryp.to/build/496923/log
  data-hash = dontCheck super.data-hash;
  Deadpan-DDP = dontCheck super.Deadpan-DDP;            # http://hydra.cryp.to/build/496418/log/raw
  DigitalOcean = dontCheck super.DigitalOcean;
  direct-sqlite = dontCheck super.direct-sqlite;
  directory-layout = dontCheck super.directory-layout;
  dlist = dontCheck super.dlist;
  docopt = dontCheck super.docopt;                      # http://hydra.cryp.to/build/499172/log/raw
  dom-selector = dontCheck super.dom-selector;          # http://hydra.cryp.to/build/497670/log/raw
  dotenv = dontCheck super.dotenv;                      # Tests fail because of missing test file on version 0.8.0.2 fixed on version 0.8.0.4
  dotfs = dontCheck super.dotfs;                        # http://hydra.cryp.to/build/498599/log/raw
  DRBG = dontCheck super.DRBG;                          # http://hydra.cryp.to/build/498245/nixlog/1/raw
  ed25519 = dontCheck super.ed25519;
  etcd = dontCheck super.etcd;
  fb = dontCheck super.fb;                              # needs credentials for Facebook
  fptest = dontCheck super.fptest;                      # http://hydra.cryp.to/build/499124/log/raw
  friday-juicypixels = dontCheck super.friday-juicypixels; #tarball missing test/rgba8.png
  ghc-events-parallel = dontCheck super.ghc-events-parallel;    # http://hydra.cryp.to/build/496828/log/raw
  ghc-imported-from = dontCheck super.ghc-imported-from;
  ghc-parmake = dontCheck super.ghc-parmake;
  git-vogue = dontCheck super.git-vogue;
  github-rest = dontCheck super.github-rest;  # test suite needs the network
  gitlib-cmdline = dontCheck super.gitlib-cmdline;
  GLFW-b = dontCheck super.GLFW-b;                      # https://github.com/bsl/GLFW-b/issues/50
  hackport = dontCheck super.hackport;
  hadoop-formats = dontCheck super.hadoop-formats;
  haeredes = dontCheck super.haeredes;
  hashed-storage = dontCheck super.hashed-storage;
  hashring = dontCheck super.hashring;
  hath = dontCheck super.hath;
  haxl = dontCheck super.haxl;                          # non-deterministic failure https://github.com/facebook/Haxl/issues/85
  haxl-facebook = dontCheck super.haxl-facebook;        # needs facebook credentials for testing
  hdbi-postgresql = dontCheck super.hdbi-postgresql;
  hedis = dontCheck super.hedis;
  hedis-pile = dontCheck super.hedis-pile;
  hedis-tags = dontCheck super.hedis-tags;
  hedn = dontCheck super.hedn;
  hgdbmi = dontCheck super.hgdbmi;
  hi = dontCheck super.hi;
  hierarchical-clustering = dontCheck super.hierarchical-clustering;
  hlibgit2 = disableHardening [ "format" ] super.hlibgit2;
  hmatrix-tests = dontCheck super.hmatrix-tests;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  hsexif = dontCheck super.hsexif;
  hspec-server = dontCheck super.hspec-server;
  HTF = overrideCabal (orig: {
    # The scripts in scripts/ are needed to build the test suite.
    preBuild = "patchShebangs --build scripts";
    # test suite doesn't compile with aeson >= 2.0
    # https://github.com/skogsbaer/HTF/issues/114
    doCheck = false;
  }) super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http-link-header = dontCheck super.http-link-header; # non deterministic failure https://hydra.nixos.org/build/75041105
  influxdb = dontCheck super.influxdb;
  integer-roots = dontCheck super.integer-roots; # requires an old version of smallcheck, will be fixed in > 1.0
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-slice = dontCheck super.language-slice;

  # Group of libraries by same upstream maintainer for interacting with
  # Telegram messenger. Bit-rotted a bit since 2020.
  tdlib = appendPatch (fetchpatch {
    # https://github.com/poscat0x04/tdlib/pull/3
    url = "https://github.com/poscat0x04/tdlib/commit/8eb9ecbc98c65a715469fdb8b67793ab375eda31.patch";
    hash = "sha256-vEI7fTsiafNGBBl4VUXVCClW6xKLi+iK53fjcubgkpc=";
  }) (doJailbreak super.tdlib) ;
  tdlib-types = doJailbreak super.tdlib-types;
  tdlib-gen = doJailbreak super.tdlib-gen;
  # https://github.com/poscat0x04/language-tl/pull/1
  language-tl = doJailbreak super.language-tl;

  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lvmrun = disableHardening ["format"] (dontCheck super.lvmrun);
  matplotlib = dontCheck super.matplotlib;
  memcache = dontCheck super.memcache;
  metrics = dontCheck super.metrics;
  milena = dontCheck super.milena;
  modular-arithmetic = dontCheck super.modular-arithmetic; # tests require a very old Glob (0.7.*)
  nats-queue = dontCheck super.nats-queue;
  netpbm = dontCheck super.netpbm;
  network = dontCheck super.network;
  network_2_6_3_1 = dontCheck super.network_2_6_3_1; # package is missing files for test
  network-dbus = dontCheck super.network-dbus;
  notcpp = dontCheck super.notcpp;
  ntp-control = dontCheck super.ntp-control;
  odpic-raw = dontCheck super.odpic-raw; # needs a running oracle database server
  opaleye = dontCheck super.opaleye;
  openpgp = dontCheck super.openpgp;
  optional = dontCheck super.optional;
  orgmode-parse = dontCheck super.orgmode-parse;
  os-release = dontCheck super.os-release;
  parameterized = dontCheck super.parameterized; # https://github.com/louispan/parameterized/issues/2
  persistent-redis = dontCheck super.persistent-redis;
  pipes-extra = dontCheck super.pipes-extra;
  pipes-websockets = dontCheck super.pipes-websockets;
  posix-pty = dontCheck super.posix-pty; # https://github.com/merijn/posix-pty/issues/12
  postgresql-binary = dontCheck super.postgresql-binary; # needs a running postgresql server
  powerdns = dontCheck super.powerdns; # Tests require networking and external services
  process-streaming = dontCheck super.process-streaming;
  punycode = dontCheck super.punycode;
  pwstore-cli = dontCheck super.pwstore-cli;
  quantities = dontCheck super.quantities;
  redis-io = dontCheck super.redis-io;
  rethinkdb = dontCheck super.rethinkdb;
  Rlang-QQ = dontCheck super.Rlang-QQ;
  safecopy = dontCheck super.safecopy;
  sai-shape-syb = dontCheck super.sai-shape-syb;
  scp-streams = dontCheck super.scp-streams;
  sdl2 = dontCheck super.sdl2; # the test suite needs an x server
  separated = dontCheck super.separated;
  shadowsocks = dontCheck super.shadowsocks;
  shake-language-c = dontCheck super.shake-language-c;
  snap-core = doJailbreak (dontCheck super.snap-core); # attoparsec bound is too strict. This has been fixed on master
  snap-server = doJailbreak super.snap-server; # attoparsec bound is too strict
  sourcemap = dontCheck super.sourcemap;
  static-resources = dontCheck super.static-resources;
  strive = dontCheck super.strive;                      # fails its own hlint test with tons of warnings
  svndump = dontCheck super.svndump;
  tar = dontCheck super.tar; #https://hydra.nixos.org/build/25088435/nixlog/2 (fails only on 32-bit)
  th-printf = dontCheck super.th-printf;
  thumbnail-plus = dontCheck super.thumbnail-plus;
  tickle = dontCheck super.tickle;
  tpdb = dontCheck super.tpdb;
  translatable-intset = dontCheck super.translatable-intset;
  ua-parser = dontCheck super.ua-parser;
  unagi-chan = dontCheck super.unagi-chan;
  universe-some = dontCheck super.universe-some;
  wai-logger = dontCheck super.wai-logger;
  WebBits = dontCheck super.WebBits;                    # http://hydra.cryp.to/build/499604/log/raw
  webdriver = dontCheck super.webdriver;
  webdriver-angular = dontCheck super.webdriver-angular;
  xsd = dontCheck super.xsd;
  zip-archive = dontCheck super.zip-archive;  # https://github.com/jgm/zip-archive/issues/57

  # 2023-01-11: Too strict bounds on optparse-applicative
  # https://github.com/Gabriella439/bench/issues/49
  bench = doJailbreak super.bench;

  # 2023-06-26: Test failure: https://hydra.nixos.org/build/224869905
  comfort-blas = dontCheck super.comfort-blas;

  # 2022-06-26: Too strict lower bound on semialign.
  trie-simple = doJailbreak super.trie-simple;

  # These test suites run for ages, even on a fast machine. This is nuts.
  Random123 = dontCheck super.Random123;
  systemd = dontCheck super.systemd;

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  # https://github.com/bos/snappy/pull/10
  snappy = appendPatches [
    (pkgs.fetchpatch {
      url = "https://github.com/bos/snappy/commit/8687802c0b85ed7fbbb1b1945a75f14fb9a9c886.patch";
      sha256 = "sha256-p6rMzkjPAZVljsC1Ubj16/mNr4mq5JpxfP5xwT+Gt5M=";
    })
    (pkgs.fetchpatch {
      url = "https://github.com/bos/snappy/commit/21c3250c1f3d273cdcf597e2b7909a22aeaa710f.patch";
      sha256 = "sha256-qHEQ8FFagXGxvtblBvo7xivRARzXlaMLw8nt0068nt0=";
    })
  ] (dontCheck super.snappy);

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/pixbi/duplo/issues/25
  duplo = doJailbreak super.duplo;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary pkgs.libmikmod super.mikmod;

  # Missing module.
  rematch = dontCheck super.rematch;            # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text;  # https://github.com/tcrayford/rematch/issues/6

  # Package exists only to be example of documentation, yet it has restrictive
  # "base" dependency.
  haddock-cheatsheet = doJailbreak super.haddock-cheatsheet;

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal (drv: { testTarget = "local"; }) super.paypal-adaptive-hoops;

  # Avoid "QuickCheck >=2.3 && <2.10" dependency we cannot fulfill in lts-11.x.
  test-framework = dontCheck super.test-framework;

  # Depends on broken test-framework-quickcheck.
  apiary = dontCheck super.apiary;
  apiary-authenticate = dontCheck super.apiary-authenticate;
  apiary-clientsession = dontCheck super.apiary-clientsession;
  apiary-cookie = dontCheck super.apiary-cookie;
  apiary-eventsource = dontCheck super.apiary-eventsource;
  apiary-logger = dontCheck super.apiary-logger;
  apiary-memcached = dontCheck super.apiary-memcached;
  apiary-mongoDB = dontCheck super.apiary-mongoDB;
  apiary-persistent = dontCheck super.apiary-persistent;
  apiary-purescript = dontCheck super.apiary-purescript;
  apiary-session = dontCheck super.apiary-session;
  apiary-websockets = dontCheck super.apiary-websockets;

  # https://github.com/junjihashimoto/test-sandbox-compose/issues/2
  test-sandbox-compose = dontCheck super.test-sandbox-compose;

  # Test suite won't compile against tasty-hunit 0.10.x.
  binary-parsers = dontCheck super.binary-parsers;

  # https://github.com/ndmitchell/shake/issues/804
  shake = dontCheck super.shake;

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

  # Missing file in source distribution:
  # - https://github.com/karun012/doctest-discover/issues/22
  # - https://github.com/karun012/doctest-discover/issues/23
  #
  # When these are fixed the following needs to be enabled again:
  #
  # # Depends on itself for testing
  # doctest-discover = addBuildTool super.doctest-discover
  #   (if pkgs.stdenv.buildPlatform != pkgs.stdenv.hostPlatform
  #    then self.buildHaskellPackages.doctest-discover
  #    else dontCheck super.doctest-discover);
  doctest-discover = dontCheck super.doctest-discover;

  # Too strict lower bound on tasty-hedgehog
  # https://github.com/qfpl/tasty-hedgehog/issues/70
  tasty-sugar = doJailbreak super.tasty-sugar;

  # Too strict lower bound on aeson
  # https://github.com/input-output-hk/hedgehog-extras/issues/39
  hedgehog-extras = doJailbreak super.hedgehog-extras;

  # Known issue with nondeterministic test suite failure
  # https://github.com/nomeata/tasty-expected-failure/issues/21
  tasty-expected-failure = dontCheck super.tasty-expected-failure;

  # Waiting on https://github.com/RaphaelJ/friday/pull/36
  friday = doJailbreak super.friday;

  # Won't compile with recent versions of QuickCheck.
  inilist = dontCheck super.inilist;

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # curl 7.87.0 introduces a preprocessor typechecker of sorts which fails on
  # incorrect usages of curl_easy_getopt and similar functions. Presumably
  # because the wrappers in curlc.c don't use static values for the different
  # arguments to curl_easy_getinfo, it complains and needs to be disabled.
  # https://github.com/GaloisInc/curl/issues/28
  curl = appendConfigureFlags [
    "--ghc-option=-DCURL_DISABLE_TYPECHECK"
  ] super.curl;

  # https://github.com/hvr/token-bucket/issues/3
  token-bucket = dontCheck super.token-bucket;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # FPCO's fork of Cabal won't succeed its test suite.
  Cabal-ide-backend = dontCheck super.Cabal-ide-backend;

  # This package can't be built on non-Windows systems.
  Win32 = overrideCabal (drv: { broken = !pkgs.stdenv.isCygwin; }) super.Win32;
  inline-c-win32 = dontDistribute super.inline-c-win32;
  Southpaw = dontDistribute super.Southpaw;

  # https://ghc.haskell.org/trac/ghc/ticket/9825
  vimus = overrideCabal (drv: { broken = pkgs.stdenv.isLinux && pkgs.stdenv.isi686; }) super.vimus;

  # https://github.com/kazu-yamamoto/logger/issues/42
  logger = dontCheck super.logger;

  # vector dependency < 0.12
  imagemagick = doJailbreak super.imagemagick;

  # Elm is no longer actively maintained on Hackage: https://github.com/NixOS/nixpkgs/pull/9233.
  Elm = markBroken super.Elm;
  elm-build-lib = markBroken super.elm-build-lib;
  elm-compiler = markBroken super.elm-compiler;
  elm-get = markBroken super.elm-get;
  elm-make = markBroken super.elm-make;
  elm-package = markBroken super.elm-package;
  elm-reactor = markBroken super.elm-reactor;
  elm-repl = markBroken super.elm-repl;
  elm-server = markBroken super.elm-server;
  elm-yesod = markBroken super.elm-yesod;

  # https://github.com/Euterpea/Euterpea2/issues/40
  Euterpea = doJailbreak super.Euterpea;

  # Byte-compile elisp code for Emacs.
  ghc-mod = overrideCabal (drv: {
    preCheck = "export HOME=$TMPDIR";
    testToolDepends = drv.testToolDepends or [] ++ [self.cabal-install];
    doCheck = false;            # https://github.com/kazu-yamamoto/ghc-mod/issues/335
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.buildPackages.emacs];
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/*/${drv.pname}-${drv.version}/elisp" )
      make -C $lispdir
      mkdir -p $data/share/emacs/site-lisp
      ln -s "$lispdir/"*.el{,c} $data/share/emacs/site-lisp/
    '';
  }) super.ghc-mod;

  # Apply compatibility patches until a new release arrives
  # https://github.com/phadej/spdx/issues/33
  spdx = appendPatches [
    (fetchpatch {
      name = "spdx-ghc-9.4.patch";
      url = "https://github.com/phadej/spdx/pull/30/commits/545dc69f433225c837375fba4cbbdb7f9cc7b09b.patch";
      sha256 = "0p2h8dxkjy2v0dx7h6v62clmx5n5j3c4zh4myh926fijympi1glz";
    })
    (fetchpatch {
      name = "spdx-ghc-9.6.patch";
      url = "https://github.com/phadej/spdx/pull/32/commits/b51f665e9960614274ff6a9ac658802c1a785687.patch";
      sha256 = "01vf1h0djr84yxsjfhym715ncx0w5q4l02k3dkbmg40pnc62ql4h";
      excludes = [ ".github/**" ];
    })
  ] super.spdx;

  # 2022-03-19: Testsuite is failing: https://github.com/puffnfresh/haskell-jwt/issues/2
  jwt = dontCheck super.jwt;

  # Build Selda with the latest git version.
  # See https://github.com/valderman/selda/issues/187
  inherit (let
    mkSeldaPackage = name: overrideCabal (drv: {
      version = "2023-02-05-unstable";
      src = pkgs.fetchFromGitHub {
        owner = "valderman";
        repo = "selda";
        rev = "ab9619db13b93867d1a244441bb4de03d3e1dadb";
        hash = "sha256-P0nqAYzbeTyEEgzMij/3mKcs++/p/Wgc7Y6bDudXt2U=";
      } + "/${name}";
    }) super.${name};
  in
    lib.genAttrs [ "selda" "selda-sqlite" "selda-json" ] mkSeldaPackage
  )
  selda
  selda-sqlite
  selda-json
  ;

  # 2024-03-10: Getting the test suite to run requires a correctly crafted GHC_ENVIRONMENT variable.
  graphql-client = dontCheck super.graphql-client;

  # Build the latest git version instead of the official release. This isn't
  # ideal, but Chris doesn't seem to make official releases any more.
  structured-haskell-mode = overrideCabal (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "projectional-haskell";
      repo = "structured-haskell-mode";
      rev = "7f9df73f45d107017c18ce4835bbc190dfe6782e";
      sha256 = "1jcc30048j369jgsbbmkb63whs4wb37bq21jrm3r6ry22izndsqa";
    };
    version = "20170205-git";
    editedCabalFile = null;
    # Make elisp files available at a location where people expect it. We
    # cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
  }) super.structured-haskell-mode;

  # Make elisp files available at a location where people expect it.
  hindent = (overrideCabal (drv: {
    # We cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.targetPrefix}${self.ghc.haskellCompilerName}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
    doCheck = false; # https://github.com/chrisdone/hindent/issues/299
  }) super.hindent);

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = overrideSrc {
    version = "unstable-2023-11-20";
    src = pkgs.fetchFromGitHub {
      owner = "augustss";
      repo = "djinn";
      rev = "69b3fbad9f42f0b1b2c49977976b8588c967d76e";
      hash = "sha256-ibxn6DXk4pqsOsWhi8KcrlH/THnuMWvIu5ENOn3H3So=";
    };
  } super.djinn;

  mueval = doJailbreak super.mueval;

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  }) super.stunclient;

  d-bus = let
    # The latest release on hackage is missing necessary patches for recent compilers
    # https://github.com/Philonous/d-bus/issues/24
    newer = overrideSrc {
      version = "unstable-2021-01-08";
      src = pkgs.fetchFromGitHub {
        owner = "Philonous";
        repo = "d-bus";
        rev = "fb8a948a3b9d51db618454328dbe18fb1f313c70";
        hash = "sha256-R7/+okb6t9DAkPVUV70QdYJW8vRcvBdz4zKJT13jb3A=";
      };
    } super.d-bus;
  # Add now required extension on recent compilers.
  # https://github.com/Philonous/d-bus/pull/23
  in appendPatch (fetchpatch {
    url = "https://github.com/Philonous/d-bus/commit/e5f37900a3a301c41d98bdaa134754894c705681.patch";
    sha256 = "6rQ7H9t483sJe1x95yLPAZ0BKTaRjgqQvvrQv7HkJRE=";
  }) newer;

  # * The standard libraries are compiled separately.
  # * We need a few patches from master to fix compilation with
  #   updated dependencies which can be
  #   removed when the next idris release comes around.
  idris = lib.pipe super.idris [
    dontCheck
    doJailbreak
    (appendPatch (fetchpatch {
      name = "idris-bumps.patch";
      url = "https://github.com/idris-lang/Idris-dev/compare/c99bc9e4af4ea32d2172f873152b76122ee4ee14...cf78f0fb337d50f4f0dba235b6bbe67030f1ff47.patch";
      hash = "sha256-RCMIRHIAK1PCm4B7v+5gXNd2buHXIqyAxei4bU8+eCk=";
    }))
    (self.generateOptparseApplicativeCompletions [ "idris" ])
  ];

  # Too strict bound on hspec
  # https://github.com/lspitzner/multistate/issues/9#issuecomment-1367853016
  multistate = doJailbreak super.multistate;

  # https://github.com/pontarius/pontarius-xmpp/issues/105
  pontarius-xmpp = dontCheck super.pontarius-xmpp;

  # fails with sandbox
  yi-keymap-vim = dontCheck super.yi-keymap-vim;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = doJailbreak super.applicative-quoters;

  # https://hydra.nixos.org/build/42769611/nixlog/1/raw
  # note: the library is unmaintained, no upstream issue
  dataenc = doJailbreak super.dataenc;

  # horribly outdated (X11 interface changed a lot)
  sindre = markBroken super.sindre;

  # Test suite occasionally runs for 1+ days on Hydra.
  distributed-process-tests = dontCheck super.distributed-process-tests;

  # https://github.com/mulby/diff-parse/issues/9
  diff-parse = doJailbreak super.diff-parse;

  # No upstream issue tracker
  hspec-expectations-pretty-diff = dontCheck super.hspec-expectations-pretty-diff;

  # Don't depend on chell-quickcheck, which doesn't compile due to restricting
  # QuickCheck to versions ">=2.3 && <2.9".
  system-filepath = dontCheck super.system-filepath;

  # The tests spuriously fail
  libmpd = dontCheck super.libmpd;

  # https://github.com/xu-hao/namespace/issues/1
  namespace = doJailbreak super.namespace;

  # https://github.com/danidiaz/streaming-eversion/issues/1
  streaming-eversion = dontCheck super.streaming-eversion;

  # https://github.com/danidiaz/tailfile-hinotify/issues/2
  tailfile-hinotify = doJailbreak (dontCheck super.tailfile-hinotify);

  # Test suite fails: https://github.com/lymar/hastache/issues/46.
  # Don't install internal mkReadme tool.
  hastache = overrideCabal (drv: {
    doCheck = false;
    postInstall = "rm $out/bin/mkReadme && rmdir $out/bin";
  }) super.hastache;

  # Has a dependency on outdated versions of directory.
  cautious-file = doJailbreak (dontCheck super.cautious-file);

  # missing dependencies: blaze-html >=0.5 && <0.9, blaze-markup >=0.5 && <0.8
  digestive-functors-blaze = doJailbreak super.digestive-functors-blaze;
  digestive-functors = doJailbreak super.digestive-functors;

  # Wrap the generated binaries to include their run-time dependencies in
  # $PATH. Also, cryptol needs a version of sbl that's newer than what we have
  # in LTS-13.x.
  cryptol = overrideCabal (drv: {
    buildTools = drv.buildTools or [] ++ [ pkgs.buildPackages.makeWrapper ];
    postInstall = drv.postInstall or "" + ''
      for b in $out/bin/cryptol $out/bin/cryptol-html; do
        wrapProgram $b --prefix 'PATH' ':' "${lib.getBin pkgs.z3}/bin"
      done
    '';
  }) super.cryptol;

  # Tests try to invoke external process and process == 1.4
  grakn = dontCheck (doJailbreak super.grakn);

  # test suite requires git and does a bunch of git operations
  restless-git = dontCheck super.restless-git;

  # patch out a flaky test that depends on output from hspec >= v2.11.7.
  # https://github.com/hspec/sensei/issues/125
  sensei = appendPatch (fetchpatch {
    url = "https://github.com/hspec/sensei/commit/5c11026fa48e13ea1c351ab882765eb0966f2e97.patch";
    hash = "sha256-eUCDvypj2bxTRnHLzrcembLMKHg5c3W3quNfclBDsso=";
  }) (overrideCabal (drv: {
    # sensei passes `-package hspec-meta` to GHC in the tests, but doesn't
    # depend on it itself.
    testHaskellDepends = drv.testHaskellDepends or [] ++ [ self.hspec-meta ];
    # requires git at test-time *and* runtime, but we'll just rely on users to
    # bring their own git at runtime.
    testToolDepends = drv.testToolDepends or [] ++ [ pkgs.git ];
  }) super.sensei);

  # Depends on broken fluid.
  fluid-idl-http-client = markBroken super.fluid-idl-http-client;
  fluid-idl-scotty = markBroken super.fluid-idl-scotty;

  # Work around https://github.com/haskell/c2hs/issues/192.
  c2hs = dontCheck super.c2hs;

  # Needs pginit to function and pgrep to verify.
  tmp-postgres = overrideCabal (drv: {
    # Flaky tests: https://github.com/jfischoff/tmp-postgres/issues/274
    doCheck = false;

    preCheck = ''
      export HOME="$TMPDIR"
    '' + (drv.preCheck or "");
    libraryToolDepends = drv.libraryToolDepends or [] ++ [pkgs.buildPackages.postgresql];
    testToolDepends = drv.testToolDepends or [] ++ [pkgs.procps];
  }) super.tmp-postgres;

  # Needs QuickCheck <2.10, which we don't have.
  edit-distance = doJailbreak super.edit-distance;
  int-cast = doJailbreak super.int-cast;

  # Needs QuickCheck <2.10, HUnit <1.6 and base <4.10
  pointfree = doJailbreak super.pointfree;

  # Needs tasty-quickcheck ==0.8.*, which we don't have.
  gitHUD = dontCheck super.gitHUD;
  githud = dontCheck super.githud;

  # Test suite fails due to trying to create directories
  path-io = dontCheck super.path-io;

  # Duplicate instance with smallcheck.
  store = dontCheck super.store;

  # With ghc-8.2.x haddock would time out for unknown reason
  # See https://github.com/haskell/haddock/issues/679
  language-puppet = dontHaddock super.language-puppet;

  # https://github.com/alphaHeavy/protobuf/issues/34
  protobuf = dontCheck super.protobuf;

  # jailbreak tasty < 1.2 until servant-docs > 0.11.3 is on hackage.
  snap-templates = doJailbreak super.snap-templates; # https://github.com/snapframework/snap-templates/issues/22

  # The test suite does not know how to find the 'alex' binary.
  alex = overrideCabal (drv: {
    testSystemDepends = (drv.testSystemDepends or []) ++ [pkgs.which];
    preCheck = ''export PATH="$PWD/dist/build/alex:$PATH"'';
  }) super.alex;

  # 2023-07-14: Restrictive upper bounds: https://github.com/luke-clifton/shh/issues/76
  shh = doJailbreak super.shh;
  shh-extras = doJailbreak super.shh-extras;

  # This package refers to the wrong library (itself in fact!)
  vulkan = super.vulkan.override { vulkan = pkgs.vulkan-loader; };

  # Compiles some C or C++ source which requires these headers
  VulkanMemoryAllocator = addExtraLibrary pkgs.vulkan-headers super.VulkanMemoryAllocator;
  # dontCheck can be removed on the next package set bump
  vulkan-utils = dontCheck (addExtraLibrary pkgs.vulkan-headers super.vulkan-utils);

  # https://github.com/dmwit/encoding/pull/3
  encoding = doJailbreak (appendPatch ./patches/encoding-Cabal-2.0.patch super.encoding);

  # Work around overspecified constraint on github ==0.18.
  github-backup = doJailbreak super.github-backup;

  # dontCheck: https://github.com/haskell-servant/servant-auth/issues/113
  servant-auth-client = dontCheck super.servant-auth-client;
  # Allow lens-aeson >= 1.2 https://github.com/haskell-servant/servant/issues/1703
  servant-auth-server = doJailbreak super.servant-auth-server;
  # Allow hspec >= 2.10 https://github.com/haskell-servant/servant/issues/1704
  servant-foreign = doJailbreak super.servant-foreign;

  # Generate cli completions for dhall.
  dhall = self.generateOptparseApplicativeCompletions [ "dhall" ] super.dhall;
  dhall-json = self.generateOptparseApplicativeCompletions ["dhall-to-json" "dhall-to-yaml"] super.dhall-json;
  # 2023-12-19: jailbreaks due to hnix-0.17 https://github.com/dhall-lang/dhall-haskell/pull/2559
  # until dhall-nix 1.1.26+, dhall-nixpkgs 1.0.10+
  dhall-nix = self.generateOptparseApplicativeCompletions [ "dhall-to-nix" ] (doJailbreak super.dhall-nix);
  dhall-nixpkgs = self.generateOptparseApplicativeCompletions [ "dhall-to-nixpkgs" ] (doJailbreak super.dhall-nixpkgs);
  dhall-yaml = self.generateOptparseApplicativeCompletions ["dhall-to-yaml-ng" "yaml-to-dhall"] super.dhall-yaml;

  # musl fixes
  # dontCheck: use of non-standard strptime "%s" which musl doesn't support; only used in test
  unix-time = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.unix-time else super.unix-time;

  # Workaround for https://github.com/sol/hpack/issues/528
  # The hpack test suite can't deal with the CRLF line endings hackage revisions insert
  hpack = overrideCabal (drv: {
    postPatch = drv.postPatch or "" + ''
      "${lib.getBin pkgs.buildPackages.dos2unix}/bin/dos2unix" *.cabal
    '';
  }) super.hpack;

  # hslua has tests that break when using musl.
  # https://github.com/hslua/hslua/issues/106
  hslua-core = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.hslua-core else super.hslua-core;

  # Missing files required by the test suite.
  # https://github.com/deemp/flakes/issues/4
  lima = dontCheck super.lima;

  # The test suite runs for 20+ minutes on a very fast machine, which feels kinda disproportionate.
  prettyprinter = dontCheck super.prettyprinter;

  # Fix with Cabal 2.2, https://github.com/guillaume-nargeot/hpc-coveralls/pull/73
  hpc-coveralls = appendPatch (fetchpatch {
    url = "https://github.com/guillaume-nargeot/hpc-coveralls/pull/73/commits/344217f513b7adfb9037f73026f5d928be98d07f.patch";
    sha256 = "056rk58v9h114mjx62f41x971xn9p3nhsazcf9zrcyxh1ymrdm8j";
  }) super.hpc-coveralls;

  # sexpr is old, broken and has no issue-tracker. Let's fix it the best we can.
  sexpr = appendPatch ./patches/sexpr-0.2.1.patch
    (overrideCabal (drv: {
      isExecutable = false;
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [self.QuickCheck];
    }) super.sexpr);

  # https://github.com/haskell/hoopl/issues/50
  hoopl = dontCheck super.hoopl;

  # https://github.com/DanielG/cabal-helper/pull/123
  cabal-helper = doJailbreak super.cabal-helper;

  # TODO(Profpatsch): factor out local nix store setup from
  # lib/tests/release.nix and use that for the tests of libnix
  # libnix = overrideCabal (old: {
  #   testToolDepends = old.testToolDepends or [] ++ [ pkgs.nix ];
  # }) super.libnix;
  libnix = dontCheck super.libnix;

  # dontCheck: The test suite tries to mess with ALSA, which doesn't work in the build sandbox.
  xmobar = dontCheck super.xmobar;

  # https://github.com/mgajda/json-autotype/issues/25
  json-autotype = dontCheck super.json-autotype;

  postgresql-simple-migration = overrideCabal (drv: {
      preCheck = ''
        PGUSER=test
        PGDATABASE=test
      '';
      testToolDepends = drv.testToolDepends or [] ++ [
        pkgs.postgresql
        pkgs.postgresqlTestHook
      ];
    }) (doJailbreak super.postgresql-simple-migration);

  postgresql-simple = addTestToolDepends [
    pkgs.postgresql
    pkgs.postgresqlTestHook
  ] super.postgresql-simple;

  beam-postgres = lib.pipe super.beam-postgres [
    # Requires pg_ctl command during tests
    (addTestToolDepends [pkgs.postgresql])
    (dontCheckIf (!pkgs.postgresql.doCheck))
  ];

  # Requires pqueue <1.5 but it works fine with pqueue-1.5.0.0
  # https://github.com/haskell-beam/beam/pull/705
  beam-migrate = doJailbreak super.beam-migrate;

  users-postgresql-simple = addTestToolDepends [
    pkgs.postgresql
    pkgs.postgresqlTestHook
  ] super.users-postgresql-simple;

  # Need https://github.com/obsidiansystems/gargoyle/pull/45
  gargoyle = doJailbreak super.gargoyle;
  gargoyle-postgresql = doJailbreak super.gargoyle-postgresql;
  gargoyle-postgresql-nix = doJailbreak (addBuildTool [pkgs.postgresql] super.gargoyle-postgresql-nix);
  gargoyle-postgresql-connect = doJailbreak super.gargoyle-postgresql-connect;

  # PortMidi needs an environment variable to have ALSA find its plugins:
  # https://github.com/NixOS/nixpkgs/issues/6860
  PortMidi = overrideCabal (drv: {
    patches = (drv.patches or []) ++ [ ./patches/portmidi-alsa-plugins.patch ];
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace portmidi/pm_linux/pmlinuxalsa.c \
        --replace @alsa_plugin_dir@ "${pkgs.alsa-plugins}/lib/alsa-lib"
    '';
  }) super.PortMidi;

  # Fix for base >= 4.11
  scat = overrideCabal (drv: {
    patches = [
      # Fix build with base >= 4.11
      (fetchpatch {
        url = "https://github.com/redelmann/scat/commit/429f22944b7634b8789cb3805292bcc2b23e3e9f.diff";
        hash = "sha256-FLr1KfBaSYzI6MiZIBY1CkgAb5sThvvgjrSAN8EV0h4=";
      })
      # Fix build with vector >= 0.13
      (fetchpatch {
        url = "https://github.com/redelmann/scat/commit/e21cc9c17b5b605b5bc0aacad66d44bbe0beb8c4.diff";
        hash = "sha256-MifHb2EKZx8skOcs+2t54CzxAS4PaEC0OTEfq4yVXzk=";
      })
    ];
  }) super.scat;

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch ./patches/xattr-fix-build.patch super.xattr;

  esqueleto =
    overrideCabal
      (drv: {
        postPatch = drv.postPatch or "" + ''
          # patch out TCP usage: https://nixos.org/manual/nixpkgs/stable/#sec-postgresqlTestHook-tcp
          sed -i test/PostgreSQL/Test.hs \
            -e s^host=localhost^^
        '';
        # Match the test suite defaults (or hardcoded values?)
        preCheck = drv.preCheck or "" + ''
          PGUSER=esqutest
          PGDATABASE=esqutest
        '';
        testFlags = drv.testFlags or [] ++ [
          # We don't have a MySQL test hook yet
          "--skip=/Esqueleto/MySQL"
        ];
        testToolDepends = drv.testToolDepends or [] ++ [
          pkgs.postgresql
          pkgs.postgresqlTestHook
        ];
      })
      # https://github.com/NixOS/nixpkgs/issues/198495
      (dontCheckIf (!pkgs.postgresql.doCheck) super.esqueleto);

  # Requires API keys to run tests
  algolia = dontCheck super.algolia;
  openai-hs = dontCheck super.openai-hs;

  # antiope-s3's latest stackage version has a hspec < 2.6 requirement, but
  # hspec which isn't in stackage is already past that
  antiope-s3 = doJailbreak super.antiope-s3;

  # Has tasty < 1.2 requirement, but works just fine with 1.2
  temporary-resourcet = doJailbreak super.temporary-resourcet;

  # Test suite doesn't work with current QuickCheck
  # https://github.com/pruvisto/heap/issues/11
  heap = dontCheck super.heap;

  # Test suite won't link for no apparent reason.
  constraints-deriving = dontCheck super.constraints-deriving;

  # https://github.com/elliottt/hsopenid/issues/15
  openid = markBroken super.openid;

  # https://github.com/erikd/hjsmin/issues/32
  hjsmin = dontCheck super.hjsmin;

  # too strict bounds on text in the test suite
  # https://github.com/audreyt/string-qq/pull/3
  string-qq = doJailbreak super.string-qq;

  # Remove for hail > 0.2.0.0
  hail = overrideCabal (drv: {
    patches = [
      (fetchpatch {
        # Relax dependency constraints,
        # upstream PR: https://github.com/james-preston/hail/pull/13
        url = "https://patch-diff.githubusercontent.com/raw/james-preston/hail/pull/13.patch";
        sha256 = "039p5mqgicbhld2z44cbvsmam3pz0py3ybaifwrjsn1y69ldsmkx";
      })
      (fetchpatch {
        # Relax dependency constraints,
        # upstream PR: https://github.com/james-preston/hail/pull/16
        url = "https://patch-diff.githubusercontent.com/raw/james-preston/hail/pull/16.patch";
        sha256 = "0dpagpn654zjrlklihsg911lmxjj8msylbm3c68xa5aad1s9gcf7";
      })
    ];
  }) super.hail;

  # https://github.com/kazu-yamamoto/dns/issues/150
  dns = dontCheck super.dns;

  # https://github.com/haskell-servant/servant-ekg/issues/15
  servant-ekg = doJailbreak super.servant-ekg;

  # the test suite has an overly tight restriction on doctest
  # See https://github.com/ekmett/perhaps/pull/5
  perhaps = doJailbreak super.perhaps;

  # it wants to build a statically linked binary by default
  hledger-flow = overrideCabal (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace hledger-flow.cabal --replace "-static" ""
    '';
  }) super.hledger-flow;

  # Chart-tests needs and compiles some modules from Chart itself
  Chart-tests = overrideCabal (old: {
    # https://github.com/timbod7/haskell-chart/issues/233
    jailbreak = true;
    preCheck = old.preCheck or "" + ''
      tar --one-top-level=../chart --strip-components=1 -xf ${self.Chart.src}
    '';
  }) (addExtraLibrary self.QuickCheck super.Chart-tests);

  # This breaks because of version bounds, but compiles and runs fine.
  # Last commit is 5 years ago, so we likely won't get upstream fixed soon.
  # https://bitbucket.org/rvlm/hakyll-contrib-hyphenation/src/master/
  # Therefore we jailbreak it.
  hakyll-contrib-hyphenation = doJailbreak super.hakyll-contrib-hyphenation;
  # 2021-10-04: too strict upper bound on Hakyll
  hakyll-filestore = doJailbreak super.hakyll-filestore;

  # The test suite depends on an impure cabal-install installation in
  # $HOME, which we don't have in our build sandbox.
  # 2022-08-31: Jailbreak is done to allow aeson 2.0.*:
  # https://github.com/haskell-CI/haskell-ci/commit/6ad0d5d701cbe101013335d597acaf5feadd3ab9#r82681900
  cabal-install-parsers = doJailbreak (dontCheck (super.cabal-install-parsers.override {
    Cabal-syntax = self.Cabal-syntax_3_10_3_0;
  }));

  # Test suite requires database
  persistent-mysql = dontCheck super.persistent-mysql;
  persistent-postgresql =
    # TODO: move this override to configuration-nix.nix
    overrideCabal
      (drv: {
        postPatch = drv.postPath or "" + ''
          # patch out TCP usage: https://nixos.org/manual/nixpkgs/stable/#sec-postgresqlTestHook-tcp
          # NOTE: upstream host variable takes only two values...
          sed -i test/PgInit.hs \
            -e s^'host=" <> host <> "'^^
        '';
        # https://github.com/commercialhaskell/stackage/issues/6884
        # persistent-postgresql-2.13.5.1 needs persistent-test >= 2.13.1.3 which
        # is incompatible with the stackage version of persistent, so the tests
        # are disabled temporarily.
        doCheck = false;
        preCheck = drv.preCheck or "" + ''
          PGDATABASE=test
          PGUSER=test
        '';
        testToolDepends = drv.testToolDepends or [] ++ [
          pkgs.postgresql
          pkgs.postgresqlTestHook
        ];
      })
      # https://github.com/NixOS/nixpkgs/issues/198495
      (dontCheckIf (!pkgs.postgresql.doCheck) super.persistent-postgresql);

  # Test suite requires a later version of persistent-test which depends on persistent 2.14
  # https://github.com/commercialhaskell/stackage/issues/6884
  persistent-sqlite = dontCheck super.persistent-sqlite;

  # 2021-12-26: Too strict bounds on doctest
  polysemy-plugin = doJailbreak super.polysemy-plugin;

  # 2024-02-28: The Hackage version dhall-lsp-server-1.1.3 requires
  # lsp-1.4.0.0 which is hard to build with this LTS. However, the latest
  # git version of dhall-lsp-server works with lsp-2.1.0.0, and only
  # needs jailbreaking to build successfully.
  dhall-lsp-server = lib.pipe
    (super.dhall-lsp-server.overrideScope (lself: lsuper: {
      lsp = doJailbreak lself.lsp_2_1_0_0;  # sorted-list <0.2.2
      lsp-types = lself.lsp-types_2_0_2_0;
    }))
    [
      # Use latest main branch version of dhall-lsp-server.
      (assert super.dhall-lsp-server.version == "1.1.3"; overrideSrc {
        version = "unstable-2024-02-19";
        src = pkgs.fetchFromGitHub {
          owner = "dhall-lang";
          repo = "dhall-haskell";
          rev = "277d8b1b3637ba2ce125783cc1936dc9591e67a7";
          hash = "sha256-YvL3XEltU9sdU45ULHeD3j1mPGZoO1J81MW7f2+10ok=";
        } + "/dhall-lsp-server";
      })
      # New version needs an extra dependency
      (addBuildDepend self.text-rope)
      # bounds too strict: mtl <2.3, transformers <0.6
      doJailbreak
    ];

  jsaddle-dom = overrideCabal (old: {
    postPatch = old.postPatch or "" + ''
      rm Setup.hs
    '';
  }) super.jsaddle-dom;
  jsaddle-hello = doJailbreak super.jsaddle-hello;
  ghcjs-dom-hello = doJailbreak super.ghcjs-dom-hello;

  # Too strict upper bounds on text
  lsql-csv = doJailbreak super.lsql-csv;

  reflex-dom = lib.pipe super.reflex-dom [
      (appendPatch
        (fetchpatch {
          name = "bump-reflex-dom-bounds.patch";
          url = "https://github.com/reflex-frp/reflex-dom/commit/70ff88942f9d2bcd364e301c70df8702f452df38.patch";
          sha256 = "sha256-xzk1+6CnfhEBfXdL5RUFbLRSn7knMwydmV8v2F2W5gE=";
          relative = "reflex-dom";
        })
      )
      (overrideCabal (drv: {
        editedCabalFile = null;
        revision = null;
      }))
    ];

  # Tests disabled and broken override needed because of missing lib chrome-test-utils: https://github.com/reflex-frp/reflex-dom/issues/392
  # 2022-03-16: Pullrequest for ghc 9 compat https://github.com/reflex-frp/reflex-dom/pull/433
  reflex-dom-core = lib.pipe super.reflex-dom-core [
      doDistribute
      unmarkBroken
      dontCheck
      (appendPatches [
        (fetchpatch {
          name = "fix-th-build-order.patch";
          url = "https://github.com/reflex-frp/reflex-dom/commit/1814640a14c6c30b1b2299e74d08fb6fcaadfb94.patch";
          sha256 = "sha256-QyX2MLd7Tk0M1s0DU0UV3szXs8ngz775i3+KI62Q3B8=";
          relative = "reflex-dom-core";
        })
        (fetchpatch {
          name = "bump-reflex-dom-core-bounds.patch";
          url = "https://github.com/reflex-frp/reflex-dom/commit/51cdd96dde9d65fcde326a16a797397bf62102d9.patch";
          sha256 = "sha256-Ct8gMbXqN+6vqTwFiqnKxddAfs+YFaBocF4G7PPMzFo=";
          relative = "reflex-dom-core";
        })
        (fetchpatch {
          name = "new-mtl-compat.patch";
          url = "https://github.com/reflex-frp/reflex-dom/commit/df95bfc0b9baf70492f20daddfe6bb180f80c413.patch";
          sha256 = "sha256-zkLZtcnfqpfiv6zDEmkZjWHr2b7lOnZ4zujm0/pkxQg=";
          relative = "reflex-dom-core";
        })
      ])
    ];

  # Tests disabled because they assume to run in the whole jsaddle repo and not the hackage tarball of jsaddle-warp.
  jsaddle-warp = dontCheck super.jsaddle-warp;

  # 2020-06-24: Jailbreaking because of restrictive test dep bounds
  # Upstream issue: https://github.com/kowainik/trial/issues/62
  trial = doJailbreak super.trial;

  # 2024-03-19: Fix for mtl >= 2.3
  pattern-arrows = lib.pipe super.pattern-arrows [
    doJailbreak
    (appendPatches [./patches/pattern-arrows-add-fix-import.patch])
  ];

  # 2024-03-19: Fix for mtl >= 2.3
  cheapskate = lib.pipe super.cheapskate [
    doJailbreak
    (appendPatches [./patches/cheapskate-mtl-2-3-support.patch])
  ];

  # 2020-06-24: Tests are broken in hackage distribution.
  # See: https://github.com/robstewart57/rdf4h/issues/39
  rdf4h = dontCheck super.rdf4h;

  # hasn't bumped upper bounds
  # test fails because of a "Warning: Unused LANGUAGE pragma"
  # https://github.com/ennocramer/monad-dijkstra/issues/4
  monad-dijkstra = dontCheck super.monad-dijkstra;

  # Fixed upstream but not released to Hackage yet:
  # https://github.com/k0001/hs-libsodium/issues/2
  libsodium = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [self.buildHaskellPackages.c2hs];
  }) super.libsodium;

  svgcairo = overrideCabal (drv: {
    patches = drv.patches or [ ] ++ [
      # Remove when https://github.com/gtk2hs/svgcairo/pull/12 goes in.
      (fetchpatch {
        url = "https://github.com/gtk2hs/svgcairo/commit/348c60b99c284557a522baaf47db69322a0a8b67.patch";
        sha256 = "0akhq6klmykvqd5wsbdfnnl309f80ds19zgq06sh1mmggi54dnf3";
      })
      # Remove when https://github.com/gtk2hs/svgcairo/pull/13 goes in.
      (fetchpatch {
        url = "https://github.com/dalpd/svgcairo/commit/d1e0d7ae04c1edca83d5b782e464524cdda6ae85.patch";
        sha256 = "1pq9ld9z67zsxj8vqjf82qwckcp69lvvnrjb7wsyb5jc6jaj3q0a";
      })
    ];
    editedCabalFile = null;
    revision = null;
  }) super.svgcairo;

  # Upstream PR: https://github.com/jkff/splot/pull/9
  splot = appendPatch (fetchpatch {
    url = "https://github.com/jkff/splot/commit/a6710b05470d25cb5373481cf1cfc1febd686407.patch";
    sha256 = "1c5ck2ibag2gcyag6rjivmlwdlp5k0dmr8nhk7wlkzq2vh7zgw63";
  }) super.splot;

  # 2023-07-27: Fix build with newer monad-logger: https://github.com/obsidiansystems/monad-logger-extras/pull/5
  # 2024-03-02: jailbreak for ansi-terminal <0.12, mtl <2.3
  monad-logger-extras = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/monad-logger-extras/commit/55d414352e740a5ecacf313732074d9b4cf2a6b3.patch";
    sha256 = "sha256-xsQbr/QIrgWR0uwDPtV0NRTbVvP0tR9bY9NMe1JzqOw=";
  }) (doJailbreak super.monad-logger-extras);

  # Fails with encoding problems, likely needs locale data.
  # Test can be executed by adding which to testToolDepends and
  # $PWD/dist/build/haskeline-examples-Test to $PATH.
  haskeline_0_8_2_1 = doDistribute (dontCheck super.haskeline_0_8_2_1);

  # Too strict upper bound on HTF
  # https://github.com/nikita-volkov/stm-containers/issues/29
  stm-containers = doJailbreak super.stm-containers;

  # Test suite fails to compile https://github.com/agrafix/Spock/issues/177
  Spock = dontCheck super.Spock;

  # https://github.com/strake/filtrable.hs/issues/6
  filtrable = doJailbreak super.filtrable;

  # hasura packages need some extra care
  graphql-engine = overrideCabal (drv: {
    patches = [
      # Compat with unordered-containers >= 0.2.15.0
      (fetchpatch {
        name = "hasura-graphql-engine-updated-deps.patch";
        url = "https://github.com/hasura/graphql-engine/commit/d50aae87a58794bc1fc66c7a60acb0c34b5e70c7.patch";
        stripLen = 1;
        excludes = [ "cabal.project.freeze" ];
        sha256 = "0lb5l9vfynr85i9xs53w4mpgczp04ncxz7846n3y91ri34fa87v3";
      })
      # Compat with hashable >= 1.3.4.0
      (fetchpatch {
        name = "hasura-graphql-engine-hashable-1.3.4.0.patch";
        url = "https://github.com/hasura/graphql-engine/commit/e48b2287315fb09005ffd52c0a686dc321171ae2.patch";
        sha256 = "1jppnanmsyl8npyf59s0d8bgjy7bq50vkh5zx4888jy6jqh27jb6";
        stripLen = 1;
      })
      # Compat with unordered-containers >= 0.2.17.0
      (fetchpatch {
        name = "hasura-graphql-engine-unordered-containers-0.2.17.0.patch";
        url = "https://github.com/hasura/graphql-engine/commit/3a1eb3128a2ded2da7c5fef089738890828cce03.patch";
        sha256 = "0vz7s8m8mjvv728vm4q0dvvrirvydaw7xks30b5ddj9f6a72a2f1";
        stripLen = 1;
      })
    ];
    doHaddock = false;
    version = "2.3.1";
  }) (super.graphql-engine.override {
    immortal = self.immortal_0_2_2_1;
    resource-pool = self.hasura-resource-pool;
    ekg-core = self.hasura-ekg-core;
    ekg-json = self.hasura-ekg-json;
  });
  hasura-ekg-json = super.hasura-ekg-json.override {
    ekg-core = self.hasura-ekg-core;
  };
  pg-client = lib.pipe
    (super.pg-client.override {
      resource-pool = self.hasura-resource-pool;
      ekg-core = self.hasura-ekg-core;
    }) [
      (overrideCabal (drv: {
        librarySystemDepends = with pkgs; [ postgresql krb5.dev openssl.dev ];
        testToolDepends = drv.testToolDepends or [] ++ [
          pkgs.postgresql pkgs.postgresqlTestHook
        ];
        preCheck = drv.preCheck or "" + ''
          # empty string means use default connection
          export DATABASE_URL=""
        '';
      }))
      # https://github.com/NixOS/nixpkgs/issues/198495
      (dontCheckIf (!pkgs.postgresql.doCheck))
    ];

  hcoord = overrideCabal (drv: {
    # Remove when https://github.com/danfran/hcoord/pull/8 is merged.
    patches = [
      (fetchpatch {
        url = "https://github.com/danfran/hcoord/pull/8/commits/762738b9e4284139f5c21f553667a9975bad688e.patch";
        sha256 = "03r4jg9a6xh7w3jz3g4bs7ff35wa4rrmjgcggq51y0jc1sjqvhyz";
      })
    ];
    # Remove when https://github.com/danfran/hcoord/issues/9 is closed.
    doCheck = false;
  }) super.hcoord;

  # Break infinite recursion via tasty
  temporary = dontCheck super.temporary;

  # Break infinite recursion via doctest-lib
  utility-ht = dontCheck super.utility-ht;

  # Break infinite recursion via optparse-applicative (alternatively, dontCheck syb)
  prettyprinter-ansi-terminal = dontCheck super.prettyprinter-ansi-terminal;

  # Tests rely on `Int` being 64-bit: https://github.com/hspec/hspec/issues/431.
  # Also, we need QuickCheck-2.14.x to build the test suite, which isn't easy in LTS-16.x.
  # So let's not go there and just disable the tests altogether.
  hspec-core = dontCheck super.hspec-core;

  # tests seem to require a different version of hspec-core
  hspec-contrib = dontCheck super.hspec-contrib;

  # github.com/ucsd-progsys/liquidhaskell/issues/1729
  liquidhaskell-boot = super.liquidhaskell-boot.override { Diff = self.Diff_0_3_4; };
  Diff_0_3_4 = dontCheck super.Diff_0_3_4;

  # The test suite attempts to read `/etc/resolv.conf`, which doesn't work in the sandbox.
  domain-auth = dontCheck super.domain-auth;

  # - Deps are required during the build for testing and also during execution,
  #   so add them to build input and also wrap the resulting binary so they're in
  #   PATH.
  # - Patch can be removed on next package set bump (for v0.2.11)

  # 2023-06-26: Test failure: https://hydra.nixos.org/build/225081865
  update-nix-fetchgit = let
      deps = [ pkgs.git pkgs.nix pkgs.nix-prefetch-git ];
    in lib.pipe  super.update-nix-fetchgit [
      dontCheck
      (self.generateOptparseApplicativeCompletions [ "update-nix-fetchgit" ])
      (overrideCabal (drv: {
        buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
        postInstall = drv.postInstall or "" + ''
          wrapProgram "$out/bin/update-nix-fetchgit" --prefix 'PATH' ':' "${
            lib.makeBinPath deps
          }"
        '';
      }))
      (addTestToolDepends deps)
      # Patch for hnix compat.
      (appendPatch (fetchpatch {
        url = "https://github.com/expipiplus1/update-nix-fetchgit/commit/dfa34f9823e282aa8c5a1b8bc95ad8def0e8d455.patch";
        sha256 = "sha256-yBjn1gVihVTlLewKgJc2I9gEj8ViNBAmw0bcsb5rh1A=";
        excludes = [ "cabal.project" ];
      }))
    ];

  # Raise version bounds: https://github.com/idontgetoutmuch/binary-low-level/pull/16
  binary-strict = appendPatches [
    (fetchpatch {
      url = "https://github.com/idontgetoutmuch/binary-low-level/pull/16/commits/c16d06a1f274559be0dea0b1f7497753e1b1a8ae.patch";
      sha256 = "sha256-deSbudy+2je1SWapirWZ1IVWtJ0sJVR5O/fnaAaib2g=";
    })
  ] super.binary-strict;

  # 2020-11-15: nettle tests are pre MonadFail change
  # https://github.com/stbuehler/haskell-nettle/issues/10
  nettle = dontCheck super.nettle;

  # The tests for semver-range need to be updated for the MonadFail change in
  # ghc-8.8:
  # https://github.com/adnelson/semver-range/issues/15
  semver-range = dontCheck super.semver-range;

  # 2022-06-19: Disable checks because of https://github.com/reflex-frp/reflex/issues/475
  reflex = doJailbreak (dontCheck super.reflex);

  # 2024-03-02: hspec <2.11, primitive <0.8 - https://github.com/reflex-frp/reflex-vty/pull/80
  reflex-vty = assert super.reflex-vty.version == "0.5.2.0"; doJailbreak super.reflex-vty;
  # 2024-03-02: vty <5.39 - https://github.com/reflex-frp/reflex-ghci/pull/33
  reflex-ghci = assert super.reflex-ghci.version == "0.2.0.1"; doJailbreak super.reflex-ghci;

  # 2020-11-19: jailbreaking because of pretty-simple bound out of date
  # https://github.com/kowainik/stan/issues/408
  # Tests disabled because of: https://github.com/kowainik/stan/issues/409
  stan = doJailbreak (dontCheck super.stan);

  # Due to tests restricting base in 0.8.0.0 release
  http-media = doJailbreak super.http-media;

  # 2022-03-19: strict upper bounds https://github.com/poscat0x04/hinit/issues/2
  hinit = doJailbreak
    (self.generateOptparseApplicativeCompletions [ "hi" ]
      (super.hinit.override { haskeline = self.haskeline_0_8_2_1; }));

  # 2020-11-23: https://github.com/Rufflewind/blas-hs/issues/8
  blas-hs = dontCheck super.blas-hs;

  # Strange doctest problems
  # https://github.com/biocad/servant-openapi3/issues/30
  servant-openapi3 = dontCheck super.servant-openapi3;

  # Point hspec 2.7.10 to correct dependencies
  hspec_2_7_10 = super.hspec_2_7_10.override {
    hspec-discover = self.hspec-discover_2_7_10;
    hspec-core = self.hspec-core_2_7_10;
  };
  hspec-discover_2_7_10 = super.hspec-discover_2_7_10.override {
    hspec-meta = self.hspec-meta_2_7_8;
  };
  hspec-core_2_7_10 = doJailbreak (dontCheck super.hspec-core_2_7_10);

  # waiting for aeson bump
  servant-swagger-ui-core = doJailbreak super.servant-swagger-ui-core;

  hercules-ci-agent = self.generateOptparseApplicativeCompletions [ "hercules-ci-agent" ] super.hercules-ci-agent;

  # Test suite doesn't compile with aeson 2.0
  # https://github.com/hercules-ci/hercules-ci-agent/pull/387
  hercules-ci-api-agent = dontCheck super.hercules-ci-api-agent;

  hercules-ci-cli = lib.pipe super.hercules-ci-cli [
    unmarkBroken
    (overrideCabal (drv: { hydraPlatforms = super.hercules-ci-cli.meta.platforms; }))
    # See hercules-ci-optparse-applicative in non-hackage-packages.nix.
    (addBuildDepend super.hercules-ci-optparse-applicative)
    (self.generateOptparseApplicativeCompletions [ "hci" ])
  ];

  pipes-aeson = appendPatches [
    # Dependency of the aeson-2 patch
    (fetchpatch {
      name = "pipes-aeson-add-loop.patch";
      url = "https://github.com/k0001/pipes-aeson/commit/d22133b4a678edbb52bcaec5079dc88ccc0de1d3.patch";
      sha256 = "sha256-5o5ys1P1+QB4rjLCYok5AcPRWCtRiecP/TqCFm8ulVY=";
      includes = ["src/Pipes/Aeson.hs" "src/Pipes/Aeson/Internal.hs" "src/Pipes/Aeson/Unchecked.hs"];
    })
    # https://github.com/k0001/pipes-aeson/pull/20
    (fetchpatch {
      name = "pipes-aeson-aeson-2.patch";
      url = "https://github.com/hercules-ci/pipes-aeson/commit/ac735c9cd459c6ef51ba82325d1c55eb67cb7b2c.patch";
      sha256 = "sha256-viWZ6D5t79x50RXiOjP6UeQ809opgNFYZOP+h+1KJh0=";
      includes = ["src/Pipes/Aeson.hs" "src/Pipes/Aeson/Internal.hs" "src/Pipes/Aeson/Unchecked.hs"];
    })
  ] super.pipes-aeson;

  # Needs bytestring 0.11
  # https://github.com/Gabriella439/Haskell-Pipes-HTTP-Library/pull/17
  pipes-http = doJailbreak super.pipes-http;

  moto-postgresql = appendPatches [
    # https://gitlab.com/k0001/moto/-/merge_requests/3
    (fetchpatch {
      name = "moto-postgresql-monadfail.patch";
      url = "https://gitlab.com/k0001/moto/-/commit/09cc1c11d703c25f6e81325be6482dc7ec6cbf58.patch";
      relative = "moto-postgresql";
      sha256 = "sha256-f2JVX9VveShCeV+T41RQgacpUoh1izfyHlE6VlErkZM=";
    })
  ] (unmarkBroken super.moto-postgresql);

  moto = appendPatches [
    # https://gitlab.com/k0001/moto/-/merge_requests/3
    (fetchpatch {
      name = "moto-ghc-9.0.patch";
      url = "https://gitlab.com/k0001/moto/-/commit/5b6f015a1271765005f03762f1f1aaed3a3198ed.patch";
      relative = "moto";
      sha256 = "sha256-RMa9tk+2ip3Ks73UFv9Ea9GEnElRtzIjdpld1Fx+dno=";
    })
  ] super.moto;

  # Readline uses Distribution.Simple from Cabal 2, in a way that is not
  # compatible with Cabal 3. No upstream repository found so far
  readline = appendPatch ./patches/readline-fix-for-cabal-3.patch super.readline;

  # https://github.com/jgm/pandoc/issues/9589
  pandoc = assert super.pandoc.version == "3.1.11.1"; dontCheck super.pandoc;

  # 2020-12-06: Restrictive upper bounds w.r.t. pandoc-types (https://github.com/owickstrom/pandoc-include-code/issues/27)
  pandoc-include-code = doJailbreak super.pandoc-include-code;

  # 2023-07-08: Restrictive upper bounds on text: https://github.com/owickstrom/pandoc-emphasize-code/pull/14
  # 2023-07-08: Missing test dependency: https://github.com/owickstrom/pandoc-emphasize-code/pull/13
  pandoc-emphasize-code = dontCheck (doJailbreak super.pandoc-emphasize-code);

  # DerivingVia is not allowed in safe Haskell
  # https://github.com/strake/util.hs/issues/1
  util = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.util;
  category = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.category;
  alg = appendConfigureFlags [
    "--ghc-option=-fno-safe-haskell"
    "--haddock-option=--optghc=-fno-safe-haskell"
  ] super.alg;

  # Windows.normalise changed in filepath >= 1.4.100.4 which fails the equivalency
  # test suite. This is of no great consequence for us, though.
  # Patch solving this has been submitted to upstream by me (@sternenseemann).
  filepath-bytestring =
    lib.warnIf
      (lib.versionAtLeast super.filepath-bytestring.version "1.4.100.4")
      "filepath-bytestring override may be obsolete"
      dontCheck super.filepath-bytestring;

  # Break out of overspecified constraint on QuickCheck.
  haddock-library = doJailbreak super.haddock-library;

  # Test suite has overly strict bounds on tasty, jailbreaking fails.
  # https://github.com/input-output-hk/nothunks/issues/9
  nothunks = dontCheck super.nothunks;

  # Allow building with older versions of http-client.
  http-client-restricted = doJailbreak super.http-client-restricted;

  # Test suite fails, upstream not reachable for simple fix (not responsive on github)
  vivid-osc = dontCheck super.vivid-osc;
  vivid-supercollider = dontCheck super.vivid-supercollider;

  # Test suite does not compile.
  feed = dontCheck super.feed;

  spacecookie = overrideCabal (old: {
    buildTools = (old.buildTools or []) ++ [ pkgs.buildPackages.installShellFiles ];
    # let testsuite discover the resulting binary
    preCheck = ''
      export SPACECOOKIE_TEST_BIN=./dist/build/spacecookie/spacecookie
    '' + (old.preCheck or "");
    # install man pages shipped in the sdist
    postInstall = ''
      installManPage docs/man/*
    '' + (old.postInstall or "");
  }) super.spacecookie;

  # Patch and jailbreak can be removed at next release, chatter > 0.9.1.0
  # * Remove dependency on regex-tdfa-text
  # * Jailbreak as bounds on cereal are too strict
  # * Disable test suite which doesn't compile
  #   https://github.com/creswick/chatter/issues/38
  chatter = appendPatch
    (fetchpatch {
      url = "https://github.com/creswick/chatter/commit/e8c15a848130d7d27b8eb5e73e8a0db1366b2e62.patch";
      sha256 = "1dzak8d12h54vss5fxnrclygz0fz9ygbqvxd5aifz5n3vrwwpj3g";
    })
    (dontCheck (doJailbreak (super.chatter.override { regex-tdfa-text = null; })));

  # test suite doesn't compile anymore due to changed hunit/tasty APIs
  fullstop = dontCheck super.fullstop;

  crypton-x509 =
    lib.pipe
      super.crypton-x509
      [
        # Mistype in a dependency in a test.
        # https://github.com/kazu-yamamoto/crypton-certificate/pull/3
        (appendPatch
          (fetchpatch {
            name = "crypton-x509-rename-dep.patch";
            url = "https://github.com/kazu-yamamoto/crypton-certificate/commit/5281ff115a18621407b41f9560fd6cd65c602fcc.patch";
            hash = "sha256-pLzuq+baSDn+MWhtYIIBOrE1Js+tp3UsaEZy5MhWAjY=";
            relative = "x509";
          })
        )
        # There is a revision in crypton-x509, so the above patch won't
        # apply because of line endings in revised .cabal files.
        (overrideCabal {
           editedCabalFile = null;
           revision = null;
        })
      ];

  # * doctests don't work without cabal
  #   https://github.com/noinia/hgeometry/issues/132
  # * Too strict version bound on vector-builder
  #   https://github.com/noinia/hgeometry/commit/a6abecb1ce4a7fd96b25cc1a5c65cd4257ecde7a#commitcomment-49282301
  hgeometry-combinatorial = dontCheck (doJailbreak super.hgeometry-combinatorial);

  # Too strict version bounds on ansi-terminal
  # https://github.com/kowainik/co-log/pull/218
  co-log = doJailbreak super.co-log;

  # Test suite has a too strict bound on base
  # https://github.com/jswebtools/language-ecmascript/pull/88
  # Test suite doesn't compile anymore
  language-ecmascript = dontCheck (doJailbreak super.language-ecmascript);

  # Too strict bounds on containers
  # https://github.com/jswebtools/language-ecmascript-analysis/issues/1
  language-ecmascript-analysis = doJailbreak super.language-ecmascript-analysis;

  # Too strict bounds on optparse-applicative
  # https://github.com/faylang/fay/pull/474
  fay = doJailbreak super.fay;

  # Too strict version bounds on cryptonite.
  # Issue reported upstream, no bug tracker url yet.
  darcs = doJailbreak super.darcs;

  # Need https://github.com/obsidiansystems/cli-extras/pull/12 and more
  cli-extras = doJailbreak super.cli-extras;

  # https://github.com/obsidiansystems/cli-git/pull/7 turned into a flat patch
  cli-git = lib.pipe super.cli-git [
    (appendPatch (fetchpatch {
      url = "https://github.com/obsidiansystems/cli-git/commit/be378a97e2f46522174231b77c952f759df3fad6.patch";
      sha256 = "sha256-6RrhqkKpnb+FTHxccHNx6pdC7ClfqcJ2eoo+W7h+JUo=";
      excludes = [ ".github/**" ];
    }))
    doJailbreak
    (addBuildTool pkgs.git)
  ];

  # Need https://github.com/obsidiansystems/cli-nix/pull/5 and more
  cli-nix = addBuildTools [
    pkgs.nix
    pkgs.nix-prefetch-git
  ] (doJailbreak super.cli-nix);

  # https://github.com/obsidiansystems/nix-thunk/pull/51/
  nix-thunk = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/nix-thunk/commit/c3dc3e799e8ce7756330f98b9f73f59c4b7a5502.patch";
    sha256 = "sha256-C1ii1FXiCPFfw5NzyQZ0cEG6kIYGohVsnHycpYEJ24Q=";
  }) (doJailbreak super.nix-thunk);

  # list `modbus` in librarySystemDepends, correct to `libmodbus`
  libmodbus = doJailbreak (addExtraLibrary pkgs.libmodbus super.libmodbus);

  # 2021-04-02: Outdated optparse-applicative bound is fixed but not realeased on upstream.
  trial-optparse-applicative = assert super.trial-optparse-applicative.version == "0.0.0.0"; doJailbreak super.trial-optparse-applicative;

  # 2022-12-28: Too strict version bounds on bytestring
  iconv = doJailbreak super.iconv;

  ginger = doJailbreak super.ginger;

  # 2024-05-05 syntax changes: https://github.com/obsidiansystems/haveibeenpwned/pull/9
  haveibeenpwned = appendPatch
    (fetchpatch {
      url = "https://github.com/obsidiansystems/haveibeenpwned/pull/9/commits/14c134eec7de12f755b2d4667727762a8a1a6476.patch";
      sha256 = "sha256-fau5+b6tufJ+MscrLgbYvvBsekPe8R6QAy/4H31dcQ4";
    })
    (doJailbreak super.haveibeenpwned);


  # Too strict version bounds on ghc-events
  # https://github.com/mpickering/hs-speedscope/issues/16
  hs-speedscope = doJailbreak super.hs-speedscope;

  # Test suite doesn't support base16-bytestring >= 1.0
  # https://github.com/centromere/blake2/issues/6
  blake2 = dontCheck super.blake2;

  # Test suite doesn't support base16-bytestring >= 1.0
  # https://github.com/serokell/haskell-crypto/issues/25
  crypto-sodium = dontCheck super.crypto-sodium;

  taskell = super.taskell.override {
    # Does not support brick >= 1.0
    # https://github.com/smallhadroncollider/taskell/issues/125
    brick = self.brick_0_70_1;
  };

  # Polyfill for GHCs from the integer-simple days that don't bundle ghc-bignum
  ghc-bignum = super.ghc-bignum or self.mkDerivation {
    pname = "ghc-bignum";
    version = "1.0";
    sha256 = "0xl848q8z6qx2bi6xil0d35lra7wshwvysyfblki659d7272b1im";
    description = "GHC BigNum library";
    license = lib.licenses.bsd3;
    # ghc-bignum is not buildable if none of the three backends
    # is explicitly enabled. We enable Native for now as it doesn't
    # depend on anything else as oppossed to GMP and FFI.
    # Apply patch which fixes a compilation failure we encountered.
    # Will need to be kept until we can drop ghc-bignum entirely,
    # i. e. if GHC 8.10.* and 8.8.* have been removed.
    configureFlags = [ "-f" "Native" ];
    patches = [
      (fetchpatch {
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/08d1588bf38d83140a86817a7a615db486357d4f.patch";
        sha256 = "sha256-Y9WW0KDQ/qY2L9ObPvh1i/6lxXIlprbxzdSBDfiaMtE=";
        relative = "libraries/ghc-bignum";
      })
    ];
  };

  # 2021-04-09: outdated base and alex-tools
  # PR pending https://github.com/glguy/language-lua/pull/6
  language-lua = doJailbreak super.language-lua;

  # 2021-04-09: too strict time bound
  # PR pending https://github.com/zohl/cereal-time/pull/2
  cereal-time = doJailbreak super.cereal-time;

  # 2021-04-16: too strict bounds on QuickCheck and tasty
  # https://github.com/hasufell/lzma-static/issues/1
  lzma-static = doJailbreak super.lzma-static;

  # Too strict version bounds on base:
  # https://github.com/obsidiansystems/database-id/issues/1
  database-id-class = doJailbreak super.database-id-class;

  # https://github.com/softwarefactory-project/matrix-client-haskell/issues/36
  # Restrictive bounds on aeson
  matrix-client = doJailbreak super.matrix-client;

  cabal2nix-unstable = overrideCabal {
    passthru = {
      updateScript = ../../../maintainers/scripts/haskell/update-cabal2nix-unstable.sh;

      # This is used by regenerate-hackage-packages.nix to supply the configuration
      # values we can easily generate automatically without checking them in.
      compilerConfig =
        pkgs.runCommand
          "hackage2nix-${self.ghc.haskellCompilerName}-config.yaml"
          {
            nativeBuildInputs = [
              self.ghc
            ];
          }
          ''
            cat > "$out" << EOF
            # generated by haskellPackages.cabal2nix-unstable.compilerConfig
            compiler: ${self.ghc.haskellCompilerName}

            core-packages:
            EOF

            ghc-pkg list \
              | tail -n '+2' \
              | sed -e 's/[()]//g' -e 's/\s\+/  - /' \
              >> "$out"
          '';
    };
  } super.cabal2nix-unstable;

  # Too strict version bounds on base
  # https://github.com/gibiansky/IHaskell/issues/1217
  ihaskell-display = doJailbreak super.ihaskell-display;
  ihaskell-basic = doJailbreak super.ihaskell-basic;

  # Fixes too strict version bounds on regex libraries
  # Presumably to be removed at the next release
  # Test suite doesn't support hspec 2.8
  # https://github.com/yi-editor/yi/issues/1124
  yi-language = appendPatch (fetchpatch {
    url = "https://github.com/yi-editor/yi/commit/0d3bcb5ba4c237d57ce33a3dc39b63c56d890765.patch";
    relative = "yi-language";
    sha256 = "sha256-AVQLvul3ufxGQyoXud05qauclNanf6kunip0oJ/9lWQ=";
  }) (dontCheck super.yi-language);

  # Tests need to lookup target triple x86_64-unknown-linux
  # https://github.com/llvm-hs/llvm-hs/issues/334
  llvm-hs = dontCheckIf (pkgs.stdenv.targetPlatform.system != "x86_64-linux") super.llvm-hs;

  # Fix build with bytestring >= 0.11 (GHC 9.2)
  # https://github.com/llvm-hs/llvm-hs/pull/389
  llvm-hs-pure = appendPatches [
    (fetchpatch {
      name = "llvm-hs-pure-bytestring-0.11.patch";
      url = "https://github.com/llvm-hs/llvm-hs/commit/fe8fd556e8d2cc028f61d4d7b4b6bf18c456d090.patch";
      sha256 = "sha256-1d4wQg6JEJL3GwmXQpvbW7VOY5DwjUPmIsLEEur0Kps=";
      relative = "llvm-hs-pure";
      excludes = [ "**/Triple.hs" ]; # doesn't exist in 9.0.0
    })
  ] (overrideCabal {
    # Hackage Revision prevents patch from applying. Revision 1 does not allow
    # bytestring-0.11.4 which is bundled with 9.2.6.
    editedCabalFile = null;
    revision = null;
  } super.llvm-hs-pure);

  # * Fix build failure by picking patch from 8.5, we need
  #   this version of sbv for petrinizer
  # * Pin version of crackNum that still exposes its library
  sbv_7_13 = appendPatch (fetchpatch {
      url = "https://github.com/LeventErkok/sbv/commit/57014b9c7c67dd9b63619a996e2c66e32c33c958.patch";
      sha256 = "10npa8nh2413n6p6qld795qfkbld08icm02bspmk93y0kabpgmgm";
    })
    (super.sbv_7_13.override {
      crackNum = self.crackNum_2_4;
    });

  # Too strict bounds on dimensional
  # https://github.com/enomsg/science-constants-dimensional/pull/1
  science-constants-dimensional = doJailbreak super.science-constants-dimensional;

  # Tests are flaky on busy machines, upstream doesn't intend to fix
  # https://github.com/merijn/paramtree/issues/4
  paramtree = dontCheck super.paramtree;

  # https://github.com/haskell-gi/haskell-gi/issues/431
  haskell-gi = appendPatch (fetchpatch {
      url = "https://github.com/haskell-gi/haskell-gi/pull/430/commits/9ee545ad5028e5de8e1e1d96bbba2b9dbab47480.diff";
      hash = "sha256-kh32mZ7EdlOsg7HQILB7Y/EkHIqG/mozbnd/kbP+WDk=";
    })
    super.haskell-gi;

  # Too strict version bounds on haskell-gi
  # https://github.com/owickstrom/gi-gtk-declarative/issues/100
  gi-gtk-declarative = doJailbreak super.gi-gtk-declarative;
  gi-gtk-declarative-app-simple = doJailbreak super.gi-gtk-declarative-app-simple;

  gi-gtk_4 = self.gi-gtk_4_0_8;
  gi-gtk_4_0_8 = doDistribute (super.gi-gtk_4_0_8.override {
    gi-gdk = self.gi-gdk_4;
  });
  gi-gdk_4 = self.gi-gdk_4_0_7;
  gi-gdk_4_0_7 = doDistribute super.gi-gdk_4_0_7;
  # GSK is only used for GTK 4.
  gi-gsk = super.gi-gsk.override {
    gi-gdk = self.gi-gdk_4;
  };
  gi-adwaita = super.gi-adwaita.override {
    gi-gdk = self.gi-gdk_4;
    gi-gtk = self.gi-gtk_4;
  };

  # Missing dependency on gi-cairo
  # https://github.com/haskell-gi/haskell-gi/pull/420
  gi-vte =
    overrideCabal
      (oldAttrs: {
        # This is implemented as a sed expression instead of pulling a patch
        # from upstream because the gi-vte repo doesn't actually contain a
        # gi-vte.cabal file.  The gi-vte.cabal file is generated from metadata
        # in the repo.
        postPatch = (oldAttrs.postPatch or "") + ''
          sed -i 's/\(gi-gtk == .*\),/\1, gi-cairo == 1.0.*,/' ./gi-vte.cabal
        '';
        buildDepends = (oldAttrs.buildDepends or []) ++ [self.gi-cairo];
      })
      super.gi-vte;

  # 2023-04-09: haskell-ci needs Cabal-syntax 3.10
  # 2023-07-03: allow lattices-2.2, waiting on https://github.com/haskell-CI/haskell-ci/pull/664
  # 2024-03-21: pins specific version of ShellCheck
  haskell-ci = doJailbreak (super.haskell-ci.overrideScope (self: super: {
    Cabal-syntax = self.Cabal-syntax_3_10_3_0;
    ShellCheck = self.ShellCheck_0_9_0;
  }));

  # ShellCheck < 0.10.0 needs to be adjusted for changes in fgl >= 5.8
  # https://github.com/koalaman/shellcheck/issues/2677
  ShellCheck_0_9_0 = doJailbreak (appendPatches [
    (fetchpatch {
      name = "shellcheck-fgl-5.8.1.1.patch";
      url = "https://github.com/koalaman/shellcheck/commit/c05380d518056189412e12128a8906b8ca6f6717.patch";
      sha256 = "0gbx46x1a2sh5mvgpqxlx9xkqcw4wblpbgqdkqccxdzf7vy50xhm";
    })
  ] super.ShellCheck_0_9_0);

  # Too strict bound on hspec (<2.11)
  utf8-light = doJailbreak super.utf8-light;

  large-hashable = lib.pipe (super.large-hashable.override {
    # https://github.com/factisresearch/large-hashable/commit/5ec9d2c7233fc4445303564047c992b693e1155c
    utf8-light = null;
  }) [
    # 2022-03-21: use version from git which supports GHC 9.{0,2} and aeson 2.0
    (assert super.large-hashable.version == "0.1.0.4"; overrideSrc {
      version = "unstable-2022-06-10";
      src = pkgs.fetchFromGitHub {
        owner = "factisresearch";
        repo = "large-hashable";
        rev = "4d149c828c185bcf05556d1660f79ff1aec7eaa1";
        sha256 = "141349qcw3m93jw95jcha9rsg2y8sn5ca5j59cv8xmci38k2nam0";
      };
    })
    # Provide newly added dependencies
    (overrideCabal (drv: {
      libraryHaskellDepends = drv.libraryHaskellDepends or [] ++ [
        self.cryptonite
        self.memory
      ];
      testHaskellDepends = drv.testHaskellDepends or [] ++ [
        self.inspection-testing
      ];
    }))
    # https://github.com/factisresearch/large-hashable/issues/24
    (overrideCabal (drv: {
      testFlags = drv.testFlags or [] ++ [
        "-n" "^Data.LargeHashable.Tests.Inspection:genericSumGetsOptimized$"
      ];
    }))
    # https://github.com/factisresearch/large-hashable/issues/25
    # Currently broken with text >= 2.0
    (overrideCabal (lib.optionalAttrs (lib.versionAtLeast self.ghc.version "9.4") {
      broken = true;
      hydraPlatforms = [];
    }))
  ];

  # BSON defaults to requiring network instead of network-bsd which is
  # required nowadays: https://github.com/mongodb-haskell/bson/issues/26
  bson = appendConfigureFlag "-f-_old_network" (super.bson.override {
    network = self.network-bsd;
  });

  # Disable flaky tests
  # https://github.com/DavidEichmann/alpaca-netcode/issues/2
  alpaca-netcode = overrideCabal {
    testFlags = [ "--pattern" "!/[NOCI]/" ];
  } super.alpaca-netcode;

  # 2021-05-22: Tests fail sometimes (even consistently on hydra)
  # when running a fs-related test with >= 12 jobs. To work around
  # this, run tests with only a single job.
  # https://github.com/vmchale/libarchive/issues/20
  libarchive = overrideCabal {
    testFlags = [ "-j1" ];
  } super.libarchive;

  # Too strict bounds on QuickCheck
  # https://github.com/muesli4/table-layout/issues/16
  table-layout = doJailbreak super.table-layout;

  # 2021-06-20: Outdated upper bounds
  # https://github.com/Porges/email-validate-hs/issues/58
  email-validate = doJailbreak super.email-validate;

  # https://github.com/plow-technologies/hspec-golden-aeson/issues/17
  hspec-golden-aeson = dontCheck super.hspec-golden-aeson;

  # To strict bound on hspec
  # https://github.com/dagit/zenc/issues/5
  zenc = doJailbreak super.zenc;

  # https://github.com/ajscholl/basic-cpuid/pull/1
  basic-cpuid = appendPatch (fetchpatch {
    url = "https://github.com/ajscholl/basic-cpuid/commit/2f2bd7a7b53103fb0cf26883f094db9d7659887c.patch";
    sha256 = "0l15ccfdys100jf50s9rr4p0d0ikn53bkh7a9qlk9i0y0z5jc6x1";
  }) super.basic-cpuid;

  # 2021-08-18: streamly-posix was released with hspec 2.8.2, but it works with older versions too.
  streamly-posix = doJailbreak super.streamly-posix;

  # 2022-12-30: Restrictive upper bound on optparse-applicative
  retrie = doJailbreak super.retrie;

  # 2022-08-30 Too strict bounds on finite-typelits
  # https://github.com/jumper149/blucontrol/issues/1
  blucontrol = doJailbreak super.blucontrol;

  # Fix from https://github.com/brendanhay/gogol/pull/144 which has seen no release
  # Can't use fetchpatch as it required tweaking the line endings as the .cabal
  # file revision on hackage was gifted CRLF line endings
  gogol-core = appendPatch ./patches/gogol-core-144.patch super.gogol-core;

  # Stackage LTS 19 still has 10.*
  hadolint = super.hadolint.override {
    language-docker = self.language-docker_11_0_0;
  };

  # test suite requires stack to run, https://github.com/dino-/photoname/issues/24
  photoname = dontCheck super.photoname;

  # Upgrade of unordered-containers in Stackage causes ordering-sensitive test to fail
  # https://github.com/commercialhaskell/stackage/issues/6366
  # https://github.com/kapralVV/Unique/issues/9
  # Too strict bounds on hashable
   # https://github.com/kapralVV/Unique/pull/10
  Unique = assert super.Unique.version == "0.4.7.9"; overrideCabal (drv: {
    testFlags = [
      "--skip" "/Data.List.UniqueUnsorted.removeDuplicates/removeDuplicates: simple test/"
      "--skip" "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/unique: simple test/"
      "--skip" "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/repeatedBy: simple test/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.Unique);

  # https://github.com/AndrewRademacher/aeson-casing/issues/8
  aeson-casing = assert super.aeson-casing.version == "0.2.0.0"; overrideCabal (drv: {
    testFlags = [
      "-p" "! /encode train/"
    ] ++ drv.testFlags or [];
  }) super.aeson-casing;

  # https://github.com/emc2/HUnit-Plus/issues/26
  HUnit-Plus = dontCheck super.HUnit-Plus;
  # https://github.com/ewestern/haskell-postgis/issues/7
  haskell-postgis = overrideCabal (drv: {
    testFlags = [
      "--skip" "/Geo/Hexable/Encodes a linestring/"
    ] ++ drv.testFlags or [];
  }) super.haskell-postgis;
  # https://github.com/ChrisPenner/json-to-haskell/issues/5
  json-to-haskell = overrideCabal (drv: {
    testFlags = [
      "--match" "/should sanitize weird field and record names/"
    ] ++ drv.testFlags or [];
  }) super.json-to-haskell;
  # https://github.com/fieldstrength/aeson-deriving/issues/5
  aeson-deriving = dontCheck super.aeson-deriving;
  # https://github.com/morpheusgraphql/morpheus-graphql/issues/660
  morpheus-graphql-core = overrideCabal (drv: {
    testFlags = [
      "-p" "!/field.unexpected-value/&&!/field.missing-field/&&!/argument.unexpected-value/&&!/argument.missing-field/"
    ] ++ drv.testFlags or [];
  }) super.morpheus-graphql-core;
  morpheus-graphql = overrideCabal (drv: {
    testFlags = [
      "-p" "!/Test Rendering/"
    ] ++ drv.testFlags or [];
  }) super.morpheus-graphql;
  drunken-bishop = doJailbreak super.drunken-bishop;
  # https://github.com/SupercedeTech/dropbox-client/issues/1
  dropbox = overrideCabal (drv: {
    testFlags = [
      "--skip" "/Dropbox/Dropbox aeson aeson/encodes list folder correctly/"
    ] ++ drv.testFlags or [];
  }) super.dropbox;
  # https://github.com/alonsodomin/haskell-schema/issues/11
  hschema-aeson = overrideCabal (drv: {
    testFlags = [
      "--skip" "/toJsonSerializer/should generate valid JSON/"
    ] ++ drv.testFlags or [];
  }) super.hschema-aeson;
  # https://github.com/minio/minio-hs/issues/165
  # https://github.com/minio/minio-hs/pull/191 Use crypton-connection instead of unmaintained connection
  minio-hs = overrideCabal (drv: {
    testFlags = [
      "-p" "!/Test mkSelectRequest/"
    ] ++ drv.testFlags or [];
    patches = drv.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "use-crypton-connection.patch";
        url = "https://github.com/minio/minio-hs/commit/786cf1881f0b62b7539e63547e76afc3c1ade36a.patch";
        sha256 = "sha256-zw0/jhKzShpqV1sUyxWTl73sQOzm6kA/yQOZ9n0L1Ag";
      })
    ];
  }) (super.minio-hs.override { connection = self.crypton-connection; });

  # Invalid CPP in test suite: https://github.com/cdornan/memory-cd/issues/1
  memory-cd = dontCheck super.memory-cd;

  # https://github.com/haskell/fgl/pull/99
  fgl = doJailbreak super.fgl;
  fgl-arbitrary = doJailbreak super.fgl-arbitrary;

  # raaz-0.3 onwards uses backpack and it does not play nicely with
  # parallel builds using -j
  #
  # See: https://gitlab.haskell.org/ghc/ghc/-/issues/17188
  #
  # Overwrite the build cores
  raaz = overrideCabal (drv: {
    enableParallelBuilding = false;
  }) super.raaz;

  # https://github.com/andreymulik/sdp/issues/3
  sdp = disableLibraryProfiling super.sdp;
  sdp-binary = disableLibraryProfiling super.sdp-binary;
  sdp-deepseq = disableLibraryProfiling super.sdp-deepseq;
  sdp-hashable = disableLibraryProfiling super.sdp-hashable;
  sdp-io = disableLibraryProfiling super.sdp-io;
  sdp-quickcheck = disableLibraryProfiling super.sdp-quickcheck;
  sdp4bytestring = disableLibraryProfiling super.sdp4bytestring;
  sdp4text = disableLibraryProfiling super.sdp4text;
  sdp4unordered = disableLibraryProfiling super.sdp4unordered;
  sdp4vector = disableLibraryProfiling super.sdp4vector;

  # Unnecessarily strict bound on template-haskell
  # https://github.com/tree-sitter/haskell-tree-sitter/issues/298
  tree-sitter = doJailbreak super.tree-sitter;

  # 2022-08-07: Bounds are too restrictive: https://github.com/marcin-rzeznicki/libjwt-typed/issues/2
  # Also, the tests fail.
  libjwt-typed = dontCheck (doJailbreak super.libjwt-typed);

  # Test suite fails to compile
  # https://github.com/kuribas/mfsolve/issues/8
  mfsolve = dontCheck super.mfsolve;

  # Fixes compilation with GHC 9.0 and above
  # https://hub.darcs.net/shelarcy/regex-compat-tdfa/issue/3
  regex-compat-tdfa = appendPatches [
    ./patches/regex-compat-tdfa-ghc-9.0.patch
  ] (overrideCabal {
    # Revision introduces bound base < 4.15
    revision = null;
    editedCabalFile = null;
  } super.regex-compat-tdfa);

  # https://github.com/kowainik/validation-selective/issues/64
  validation-selective = doJailbreak super.validation-selective;
  # https://github.com/system-f/validation/issues/57
  validation = doJailbreak super.validation;

  # 2022-03-16: strict upper bounds https://github.com/monadfix/shower/issues/18
  shower = doJailbreak (dontCheck super.shower);

  # Test suite isn't supposed to succeed yet, apparently…
  # https://github.com/andrewufrank/uniform-error/blob/f40629ad119e90f8dae85e65e93d7eb149bddd53/test/Uniform/Error_test.hs#L124
  # https://github.com/andrewufrank/uniform-error/issues/2
  uniform-error = dontCheck super.uniform-error;
  # https://github.com/andrewufrank/uniform-fileio/issues/2
  uniform-fileio = dontCheck super.uniform-fileio;

  # The shipped Setup.hs file is broken.
  csv = overrideCabal (drv: { preCompileBuildDriver = "rm Setup.hs"; }) super.csv;
  # Build-type is simple, but ships a broken Setup.hs
  digits = overrideCabal (drv: { preCompileBuildDriver = "rm Setup.lhs"; }) super.digits;

  cabal-fmt = doJailbreak (super.cabal-fmt.override {
    # Needs newer Cabal-syntax version.
    Cabal-syntax = self.Cabal-syntax_3_10_3_0;
  });

  # 2023-07-18: https://github.com/srid/ema/issues/156
  ema = doJailbreak super.ema;

  # 2024-03-02: base <=4.18.0.0  https://github.com/srid/url-slug/pull/2
  url-slug = doJailbreak super.url-slug;

  glirc = doJailbreak (super.glirc.override {
    vty = self.vty_5_35_1;
  });

  # Too strict bounds on text and tls
  # https://github.com/barrucadu/irc-conduit/issues/54
  # Use crypton-connection instead of connection
  # https://github.com/barrucadu/irc-conduit/pull/60 https://github.com/barrucadu/irc-client/pull/101
  irc-conduit = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/barrucadu/irc-conduit/pull/60/commits/58f6b5ee0c23a0615e43292dbbacf40636dcd7a6.patch";
    hash = "sha256-d08tb9iL07mBWdlZ7PCfTLVFJLgcxeGVPzJ+jOej8io=";
  }) (doJailbreak (super.irc-conduit.override {
    connection = self.crypton-connection;
    x509-validation = self.crypton-x509-validation;
  }));
  irc-client = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/barrucadu/irc-client/pull/101/commits/0440b7e2ce943d960234c50957a55025771f567a.patch";
    hash = "sha256-iZyZMrodgViXFCMH9y2wIJZRnjd6WhkqInAdykqTdkY=";
  }) (doJailbreak (super.irc-client.override {
    connection = self.crypton-connection;
    x509 = self.crypton-x509;
    x509-store = self.crypton-x509-store;
    x509-validation = self.crypton-x509-validation;
  }));

  # 2022-02-25: Unmaintained and to strict upper bounds
  paths = doJailbreak super.paths;

  # 2022-02-26: https://github.com/emilypi/base64/issues/39
  base64 = dontCheck super.base64;

  # 2022-03-16: Upstream stopped updating bounds https://github.com/haskell-hvr/base-noprelude/pull/15
  base-noprelude = doJailbreak super.base-noprelude;

  # 2025-05-05: Bounds need to be loosened https://github.com/obsidiansystems/dependent-sum-aeson-orphans/pull/13
  dependent-monoidal-map = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/dependent-monoidal-map/commit/3f8be15fa9bd2796d1c917e9f0979b4d6c62cf91.patch";
    hash = "sha256-QKDUh4jO8xZrThrkjTVNnkoVY+GejxOhpXOVA4+n1H8=";
  }) super.dependent-monoidal-map;

  # 2025-05-05: Bounds need to be loosened https://github.com/obsidiansystems/dependent-sum-aeson-orphans/pull/13
  dependent-sum-aeson-orphans = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/dependent-sum-aeson-orphans/commit/9b4698154303a9865d7d68a2f01d280a8a39f108.patch";
    hash = "sha256-Pzjl2yp01XsYWcyhpLnsuccg7bOACgv+RpafauUox8c=";
  }) super.dependent-sum-aeson-orphans;

  # https://github.com/obsidiansystems/dependent-sum/pull/73
  dependent-sum-template = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/dependent-sum/commit/619727ba1792e39a68d23c62e75a923672e87a54.patch";
    hash = "sha256-SyD1/KrX1KUjrR82fvI+BRcqLC2Q3AbvSeKNrdGstjg=";
    relative = "dependent-sum-template";
  }) super.dependent-sum-template;

  aeson-gadt-th = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/aeson-gadt-th/commit/8f6922a6440019dece637d73d70766c473bcd6c0.patch";
    hash = "sha256-564DhfiubwNV8nAj8L5DzsWn4MdzqqaYYNmOSPUa7ys=";
    excludes = [ ".github/**" ];
  }) super.aeson-gadt-th;

  # Too strict bounds on chell: https://github.com/fpco/haskell-filesystem/issues/24
  system-fileio = doJailbreak super.system-fileio;

  # Bounds too strict on base and ghc-prim: https://github.com/tibbe/ekg-core/pull/43 (merged); waiting on hackage release
  ekg-core = assert super.ekg-core.version == "0.1.1.7"; doJailbreak super.ekg-core;
  hasura-ekg-core = doJailbreak super.hasura-ekg-core;

  # Test suite doesn't support hspec 2.8
  # https://github.com/zellige/hs-geojson/issues/29
  geojson = dontCheck super.geojson;

  # Test data missing from sdist
  # https://github.com/ngless-toolkit/ngless/issues/152
  NGLess = dontCheck super.NGLess;

  # Raise version bounds: https://github.com/well-typed/lens-sop/pull/4
  lens-sop = appendPatches [
    (fetchpatch {
      url = "https://github.com/well-typed/lens-sop/commit/d8657f27c12191a7c0a91701c0fcd9a590e0090e.patch";
      sha256 = "sha256-9ODfbOb6Bs3EVTY9b7cUvkNmqzzZPWUmgmlAneaN3Tw=";
    })
    (fetchpatch {
      url = "https://github.com/well-typed/lens-sop/commit/b7ecffdeb836d19373871659e2f8cd24da6f7312.patch";
      sha256 = "sha256-hDUQ2fW9Qyom65YvtW9bsbz7XtueRmdsAbAB42D+gu4=";
    })
  ] super.lens-sop;

  # Raise version bounds: https://github.com/kosmikus/records-sop/pull/15
  records-sop = appendPatch (fetchpatch {
    url = "https://github.com/kosmikus/records-sop/commit/fb149f453a816ff14d0cb20b3ea56b80ff49d9f1.patch";
    sha256 = "sha256-iHiF4EWL/GjJFnr/6aR+yMZKLMLAZK+gsgSxG8YaeDI=";
  }) super.records-sop;

  # Need https://github.com/well-typed/large-records/pull/151
  large-generics = doJailbreak super.large-generics;

  # Fix build failures for ghc 9 (https://github.com/mokus0/polynomial/pull/20)
  polynomial = appendPatch (fetchpatch {
    name = "haskell-polynomial.20.patch";
    url = "https://github.com/mokus0/polynomial/pull/20.diff";
    sha256 = "1bwivimpi2hiil3zdnl5qkds1inyn239wgxbn3y8l2pwyppnnfl0";
  })
  (overrideCabal (drv: {
    revision = null;
    editedCabalFile = null;
    doCheck = false; # Source dist doesn't include the checks
  })
  super.polynomial);

  # Tests likely broke because of https://github.com/nick8325/quickcheck/issues/359,
  # but fft is not on GitHub, so no issue reported.
  fft = dontCheck super.fft;

  # lucid-htmx has restrictive upper bounds on lucid and servant:
  #
  #   Setup: Encountered missing or private dependencies:
  #   lucid >=2.9.12.1 && <=2.11, servant >=0.18.3 && <0.19
  #
  # Can be removed once
  #
  # > https://github.com/MonadicSystems/lucid-htmx/issues/6
  #
  # has been resolved.
  lucid-htmx = doJailbreak super.lucid-htmx;

  # Too strict bounds on hspec
  # https://github.com/klapaucius/vector-hashtables/issues/11
  vector-hashtables = doJailbreak super.vector-hashtables;

  # doctest-parallel is broken with v1-style cabal-install / Setup.hs
  # https://github.com/martijnbastiaan/doctest-parallel/issues/22
  doctest-parallel = dontCheck super.doctest-parallel;
  clash-prelude = dontCheck super.clash-prelude;

  # Ships a broken Setup.hs
  # https://github.com/lehins/conduit-aeson/issues/1
  conduit-aeson = overrideCabal (drv: {
    postPatch = ''
      ${drv.postPatch or ""}
      rm Setup.hs
    '';
    # doctest suite uses doctest-parallel which still doesn't work in nixpkgs
    testTarget = "tests";
  }) super.conduit-aeson;

  # Upper bounds are too strict:
  # https://github.com/velveteer/hermes/pull/22
  hermes-json = doJailbreak super.hermes-json;

  # Disabling doctests.
  regex-tdfa = overrideCabal {
    testTarget = "regex-tdfa-unittest";
  } super.regex-tdfa;

  # Missing test files https://github.com/kephas/xdg-basedir-compliant/issues/1
  xdg-basedir-compliant = dontCheck super.xdg-basedir-compliant;

  # Test failure after libxcrypt migration, reported upstrem at
  # https://github.com/phadej/crypt-sha512/issues/13
  crypt-sha512 = dontCheck super.crypt-sha512;

  # Too strict upper bound on HTTP
  oeis = doJailbreak super.oeis;

  inherit
    (let
      # We need to build purescript with these dependencies and thus also its reverse
      # dependencies to avoid version mismatches in their dependency closure.
      # TODO: maybe unify with the spago overlay in configuration-nix.nix?
      purescriptOverlay = self: super: {
        # As of 2021-11-08, the latest release of `language-javascript` is 0.7.1.0,
        # but it has a problem with parsing the `async` keyword.  It doesn't allow
        # `async` to be used as an object key:
        # https://github.com/erikd/language-javascript/issues/131
        language-javascript = self.language-javascript_0_7_0_0;
      };
    in {
      purescript =
        lib.pipe
          (super.purescript.overrideScope purescriptOverlay)
          ([
            # PureScript uses nodejs to run tests, so the tests have been disabled
            # for now.  If someone is interested in figuring out how to get this
            # working, it seems like it might be possible.
            dontCheck
            # The current version of purescript (0.14.5) has version bounds for LTS-17,
            # but it compiles cleanly using deps in LTS-18 as well.  This jailbreak can
            # likely be removed when purescript-0.14.6 is released.
            doJailbreak
            # Generate shell completions
            (self.generateOptparseApplicativeCompletions [ "purs" ])
          ]);

      purenix = super.purenix.overrideScope purescriptOverlay;
    })
    purescript
    purenix
    ;

  # 2022-11-05: https://github.com/ysangkok/haskell-tzdata/issues/3
  tzdata = dontCheck super.tzdata;

  # We provide newer dependencies than upstream expects.
  swarm = doJailbreak super.swarm;

  # Too strict upper bound on bytestring
  # https://github.com/TravisWhitaker/rdf/issues/8
  rdf = doJailbreak super.rdf;

  # random <1.2
  unfoldable = doJailbreak super.unfoldable;

  # containers <0.6, semigroupoids <5.3
  data-lens = doJailbreak super.data-lens;

  # transformers <0.3
  monads-fd = doJailbreak super.monads-fd;

  # HTF <0.15
  cases = doJailbreak super.cases;

  # exceptions <0.9
  eprocess = doJailbreak super.eprocess;

  # hashable <1.4, mmorph <1.2
  composite-aeson = doJailbreak super.composite-aeson;

  # composite-aeson <0.8, composite-base <0.8
  compdoc = doJailbreak super.compdoc;

  # composite-aeson <0.8, composite-base <0.8
  haskell-coffee = doJailbreak super.haskell-coffee;

  # Test suite doesn't compile anymore
  twitter-types = dontCheck super.twitter-types;

  # base <4.14
  numbered-semigroups = doJailbreak super.numbered-semigroups;

  # Tests open file "data/test_vectors_aserti3-2d_run01.txt" but it doesn't exist
  haskoin-core = dontCheck super.haskoin-core;

  # base <4.9, transformers <0.5
  MonadCatchIO-transformers = doJailbreak super.MonadCatchIO-transformers;

  # unix-compat <0.5
  hxt-cache = doJailbreak super.hxt-cache;

  # base <4.16
  fast-builder = doJailbreak super.fast-builder;

  # QuickCheck <2.14
  term-rewriting = doJailbreak super.term-rewriting;

  # tests can't find the test binary anymore - parseargs-example
  parseargs = dontCheck super.parseargs;

  # base <4.14
  decimal-literals = doJailbreak super.decimal-literals;

  # multiple bounds too strict
  snaplet-sqlite-simple = doJailbreak super.snaplet-sqlite-simple;

  # Test failure https://gitlab.com/lysxia/ap-normalize/-/issues/2
  ap-normalize = dontCheck super.ap-normalize;

  heist-extra = doJailbreak super.heist-extra;  # base <4.18.0.0.0
  unionmount = doJailbreak super.unionmount;  # base <4.18
  path-tree = doJailbreak super.path-tree;  # base <4.18  https://github.com/srid/pathtree/pull/1
  tailwind = doJailbreak super.tailwind;  # base <=4.17.0.0
  tagtree = doJailbreak super.tagtree;  # base <=4.17  https://github.com/srid/tagtree/issues/1
  commonmark-wikilink = doJailbreak super.commonmark-wikilink; # base <4.18.0.0.0

  # 2024-03-02: Apply unreleased changes necessary for compatibility
  # with commonmark-extensions-0.2.5.3.
  commonmark-simple = assert super.commonmark-simple.version == "0.1.0.0";
    appendPatches (map ({ rev, hash }: fetchpatch {
      name = "commonmark-simple-${lib.substring 0 7 rev}.patch";
      url = "https://github.com/srid/commonmark-simple/commit/${rev}.patch";
      includes = [ "src/Commonmark/Simple.hs" ];
      inherit hash;
    }) [
      {
        rev = "71f5807ed4cbd8da915bf5ba04cd115b49980bcb";
        hash = "sha256-ibDQbyTd2BoA0V+ldMOr4XYurnqk1nWzbJ15tKizHrM=";
      }
      {
        rev = "fc106c94f781f6a35ef66900880edc08cbe3b034";
        hash = "sha256-9cpgRNFWhpSuSttAvnwPiLmi1sIoDSYbp0sMwcKWgDQ=";
      }
    ])
      (doJailbreak super.commonmark-simple);

  # Test files missing from sdist
  # https://github.com/tweag/webauthn/issues/166
  webauthn = dontCheck super.webauthn;

  # doctest <0.19
  polysemy = doJailbreak super.polysemy;

  # multiple bounds too strict
  co-log-polysemy = doJailbreak super.co-log-polysemy;
  co-log-polysemy-formatting = doJailbreak super.co-log-polysemy-formatting;

  # calls ghc in tests
  # https://github.com/brandonchinn178/tasty-autocollect/issues/54
  tasty-autocollect = dontCheck super.tasty-autocollect;

  postgrest = lib.pipe super.postgrest [
    # 2023-12-20: New version needs extra dependencies
    (addBuildDepends [ self.extra self.fuzzyset_0_2_4 self.cache self.timeit ])
    # 2022-12-02: Too strict bounds: https://github.com/PostgREST/postgrest/issues/2580
    doJailbreak
    # 2022-12-02: Hackage release lags behind actual releases: https://github.com/PostgREST/postgrest/issues/2275
    (overrideSrc rec {
      version = "12.0.2";
      src = pkgs.fetchFromGitHub {
        owner = "PostgREST";
        repo = "postgrest";
        rev = "v${version}";
        hash = "sha256-fpGeL8R6hziEtIgHUMfWLF7JAjo3FDYQw3xPSeQH+to=";
      };
    })
  ];

  # Too strict bounds on hspec < 2.11
  fuzzyset_0_2_4 = doJailbreak super.fuzzyset_0_2_4;
  swagger2 = doJailbreak super.swagger2;

  html-charset = dontCheck super.html-charset;

  # true-name-0.1.0.4 has been tagged, but has not been released to Hackage.
  # Also, beyond 0.1.0.4 an additional patch is required to make true-name
  # compatible with current versions of template-haskell
  # https://github.com/liyang/true-name/pull/4
  true-name = appendPatch (fetchpatch {
    url = "https://github.com/liyang/true-name/compare/0.1.0.3...nuttycom:true-name:update_template_haskell.patch";
    hash = "sha256-ZMBXGGc2X5AKXYbqgkLXkg5BhEwyj022E37sUEWahtc=";
  }) (overrideCabal (drv: {
    revision = null;
    editedCabalFile = null;
  }) super.true-name);

  # ffmpeg-light works against the ffmpeg-4 API, but the default ffmpeg in nixpkgs is ffmpeg-5.
  # https://github.com/NixOS/nixpkgs/pull/220972#issuecomment-1484017192
  ffmpeg-light = super.ffmpeg-light.override { ffmpeg = pkgs.ffmpeg_4; };

  # posix-api has had broken tests since 2020 (until at least 2023-01-11)
  # raehik has a fix pending: https://github.com/andrewthad/posix-api/pull/14
  posix-api = dontCheck super.posix-api;

  # bytestring <0.11.0, optparse-applicative <0.13.0
  # https://github.com/kseo/sfnt2woff/issues/1
  sfnt2woff = doJailbreak super.sfnt2woff;

  # 2023-03-05: restrictive bounds on base https://github.com/diagrams/diagrams-gtk/issues/11
  diagrams-gtk = doJailbreak super.diagrams-gtk;

  tomland = overrideCabal (drv: {
    # 2023-03-13: restrictive bounds on validation-selective (>=0.1.0 && <0.2).
    # Get rid of this in the next release: https://github.com/kowainik/tomland/commit/37f16460a6dfe4606d48b8b86c13635d409442cd
    jailbreak = true;
    # Fix compilation of test suite with GHC >= 9.8
    patches = drv.patches or [ ] ++ [
      (pkgs.fetchpatch {
        name = "tomland-disambiguate-string-type-for-ghc-9.8.patch";
        url = "https://github.com/kowainik/tomland/commit/0f107269b8835a8253f618b75930b11d3a3f1337.patch";
        sha256 = "13ndlfw32xh8jz5g6lpxzn2ks8zchb3y4j1jbbm2x279pdyvvars";
      })
    ];
  }) super.tomland;

  # libfuse3 fails to mount fuse file systems within the build environment
  libfuse3 = dontCheck super.libfuse3;

  # Merged upstream, but never released. Allows both intel and aarch64 darwin to build.
  # https://github.com/vincenthz/hs-gauge/pull/106
  gauge = appendPatch (pkgs.fetchpatch {
    name = "darwin-aarch64-fix.patch";
    url = "https://github.com/vincenthz/hs-gauge/commit/3d7776f41187c70c4f0b4517e6a7dde10dc02309.patch";
    hash = "sha256-4osUMo0cvTvyDTXF8lY9tQbFqLywRwsc3RkHIhqSriQ=";
  }) super.gauge;

  # Flaky QuickCheck tests
  # https://github.com/Haskell-Things/ImplicitCAD/issues/441
  implicit = dontCheck super.implicit;

  # The hackage source is somehow missing a file present in the repo (tests/ListStat.hs).
  sym = dontCheck super.sym;

  # 2024-01-23: https://github.com/composewell/unicode-data/issues/118
  unicode-data = dontCheck super.unicode-data;

  # 2024-01-24: https://github.com/haskellari/tree-diff/issues/79
  tree-diff = dontCheck super.tree-diff;

  # Too strict bounds on base, ghc-prim, primitive
  # https://github.com/kowainik/typerep-map/pull/128
  typerep-map = doJailbreak super.typerep-map;

  # Too strict bounds on base
  kewar = doJailbreak super.kewar;

  # Too strict bounds on mtl, servant and servant-client
  unleash-client-haskell = doJailbreak super.unleash-client-haskell;

  # Requires a newer zlib version than stackage provides
  futhark = super.futhark.override {
    zlib = self.zlib_0_7_1_0;
  };

  # Tests rely on (missing) submodule
  unleash-client-haskell-core = dontCheck super.unleash-client-haskell-core;

  # Workaround for Cabal failing to find nonexistent SDL2 library?!
  # https://github.com/NixOS/nixpkgs/issues/260863
  sdl2-gfx = overrideCabal { __propagatePkgConfigDepends = false; } super.sdl2-gfx;
  sdl2-ttf = overrideCabal { __onlyPropagateKnownPkgConfigModules = true; } super.sdl2-ttf;

  # Needs git for compile-time insertion of commit hash into --version string.
  kmonad = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [pkgs.buildPackages.git];
  }) super.kmonad;

  ghc-syntax-highlighter_0_0_11_0 = super.ghc-syntax-highlighter_0_0_11_0.overrideScope(self: super: {
    ghc-lib-parser = self.ghc-lib-parser_9_10_1_20240511;
  });

  # 2024-03-17: broken
  vaultenv = dontDistribute super.vaultenv;

  # Support base16 1.0
  nix-serve-ng = appendPatch (fetchpatch {
    url = "https://github.com/aristanetworks/nix-serve-ng/commit/4d9eacfcf753acbcfa0f513bec725e9017076270.patch";
    hash = "sha256-zugyUpEq/iVkxghrvguL95+lJDEpE8MLvZivken0p24=";
  }) super.nix-serve-ng;

  # Needs a matching version of ipython-kernel and a
  # ghc-syntax-highlighter compatible with a newer ghc-lib-parser it
  # transitively pulls in
  ihaskell = super.ihaskell.overrideScope (self: super: {
    ghc-syntax-highlighter = self.ghc-syntax-highlighter_0_0_10_0;
  });

  # 2024-01-24: support optparse-applicative 0.18
  niv = appendPatches [
    (fetchpatch {
      # needed for the following patch to apply
      url = "https://github.com/nmattia/niv/commit/7b76374b2b44152bfbf41fcb60162c2ce9182e7a.patch";
      includes = [ "src/*" ];
      hash = "sha256-3xG+GD6fUCGgi2EgS7WUpjfn6gvc2JurJcIrnyy4ys8=";
    })
    (fetchpatch {
      # Update to optparse-applicative 0.18
      url = "https://github.com/nmattia/niv/commit/290965abaa02be33b601032d850c588a6bafb1a5.patch";
      hash = "sha256-YxUdv4r/Fx+8YxHhqEuS9uZR1XKzVCPrLmj5+AY5GRA=";
    })
  ] super.niv;

  # 2024-03-25: HSH broken because of the unix-2.8.0.0 breaking change
  HSH = appendPatches [./patches/HSH-unix-openFd.patch] super.HSH;

  # Support unix < 2.8 to build in older ghc than 9.6
  linux-namespaces = appendPatch
    (fetchpatch {
      url = "https://github.com/redneb/hs-linux-namespaces/commit/f4a3546541bb6c7172fdd03e177a961da60e3951.patch";
      sha256 = "sha256-6Qv7NWIbzR3ktMGFogw5597bIqPH7Z4hoFvvBQAoquY=";
    })
    super.linux-namespaces;

  inherit
    (let
      unbreakRepa = packageName: drv: lib.pipe drv [
        # 2023-12-23: Apply build fixes for ghc >=9.4
        (appendPatches (lib.optionals (lib.versionAtLeast self.ghc.version "9.4") (repaPatches.${packageName} or [])))
        # 2023-12-23: jailbreak for base <4.17, vector <0.13
        doJailbreak
      ];
      # https://github.com/haskell-repa/repa/pull/27
      repaPatches = lib.mapAttrs (relative: hash: lib.singleton (pkgs.fetchpatch {
        name = "repa-pr-27.patch";
        url = "https://github.com/haskell-repa/repa/pull/27/commits/40cb2866bb4da51a8cac5e3792984744a64b016e.patch";
        inherit relative hash;
     })) {
        repa = "sha256-bcSnzvCJmmSBts9UQHA2dYL0Q+wXN9Fbz5LfkrmhCo8=";
        repa-io = "sha256-KsIN7NPWCyTpVzhR+xaBKGl8vC6rYH94llvlTawSxFk=";
        repa-examples = "sha256-//2JG1CW1h2sKS2BSJadVAujSE3v1TfS0F8zgcNkPI8=";
        repa-algorithms = "sha256-z/a7DpT3xJrIsif4cbciYcTSjapAtCoNNVX7PrZtc4I=";
      };
    in
      lib.mapAttrs unbreakRepa super)
    repa
    repa-io
    repa-examples
    repa-algorithms
    # The following packages aren't fixed yet, sorry:
    #   repa-array, repa-convert, repa-eval, repa-flow,
    #   repa-query, repa-scalar, repa-store, repa-stream
  ;

  # Use recent git version as the hackage version is outdated and not building on recent GHC versions
  haskell-to-elm = overrideSrc {
    version = "unstable-2023-12-02";
    src = pkgs.fetchFromGitHub {
      owner = "haskell-to-elm";
      repo = "haskell-to-elm";
      rev = "52ab086a320a14051aa38d0353d957fb6b2525e9";
      hash = "sha256-j6F4WplJy7NyhTAuiDd/tHT+Agk1QdyPjOEkceZSxq8=";
    };
  } super.haskell-to-elm;

  # https://github.com/dpwright/HaskellNet-SSL/pull/33 Use crypton-connection instead of connection
  HaskellNet-SSL = appendPatch (pkgs.fetchpatch {
    name = "HaskellNet-SSL-crypton-connection.patch";
    url = "https://github.com/dpwright/HaskellNet-SSL/pull/34/commits/cab639143efb65acf96abb35ae6c48db8d37867c.patch";
    hash = "sha256-hT4IZw70DxTw6iMofQHjPycz6IE6U76df72ftR2UB6Q=";
  }) (super.HaskellNet-SSL.override { connection = self.crypton-connection; });

  # https://github.com/isovector/type-errors/issues/9
  type-errors = dontCheck super.type-errors;

  # 2024-05-15: Hackage distribution is missing files needed for tests
  # https://github.com/isovector/cornelis/issues/150
  cornelis = dontCheck super.cornelis;

  cabal-gild = super.cabal-gild.overrideScope (self: super: {
    tasty = super.tasty_1_5;
    tasty-quickcheck = super.tasty-quickcheck_0_10_3;
  });

  # Fixes build on some platforms: https://github.com/obsidiansystems/commutative-semigroups/pull/18
  commutative-semigroups = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/commutative-semigroups/commit/e031495dd24ae73ffb808eca34e993f5df8e8d76.patch";
    hash = "sha256-d7AwvGGUJlh/sOXaAbfQLCay6+JyNInb73TTGKkBDz8=";
  }) super.commutative-semigroups;

  # Too strict bounds on text. Can be removed after https://github.com/alx741/currencies/pull/3 is merged
  currencies = doJailbreak super.currencies;

  # https://github.com/awakesecurity/proto3-wire/pull/104
  proto3-wire = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/awakesecurity/proto3-wire/commit/c1cadeb5fca2e82c5b28e2811c01f5b37eb21ed8.patch";
    hash = "sha256-tFOWpjGmZANC7H82QapZ36raaNWuZ6F3BgjxnfTXpMs=";
  }) super.proto3-wire;

} // import ./configuration-tensorflow.nix {inherit pkgs haskellLib;} self super
