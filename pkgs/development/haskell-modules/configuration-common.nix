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

  # Make sure that Cabal 3.8.* can be built as-is
  Cabal_3_8_1_0 = doDistribute (super.Cabal_3_8_1_0.override ({
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.2.5") {
    # Use process core package when possible
    process = self.process_1_6_17_0;
  }));

  # Make sure that Cabal 3.10.* can be built as-is
  Cabal_3_10_1_0 = doDistribute (super.Cabal_3_10_1_0.override ({
    Cabal-syntax = self.Cabal-syntax_3_10_1_0;
  } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.2.5") {
    # Use process core package when possible
    process = self.process_1_6_17_0;
  }));

  # cabal-install needs most recent versions of Cabal and Cabal-syntax,
  # so we need to put some extra work for non-latest GHCs
  inherit (
    let
      # !!! Use cself/csuper inside for the actual overrides
      cabalInstallOverlay = cself: csuper:
        lib.optionalAttrs (lib.versionOlder self.ghc.version "9.6") {
          Cabal = cself.Cabal_3_10_1_0;
          Cabal-syntax = cself.Cabal-syntax_3_10_1_0;
        } // lib.optionalAttrs (lib.versionOlder self.ghc.version "9.4") {
          # We need at least directory >= 1.3.7.0. Using the latest version
          # 1.3.8.* is not an option since it causes very annoying dependencies
          # on newer versions of unix and filepath than GHC 9.2 ships
          directory = cself.directory_1_3_7_1;
          # GHC 9.2.5 starts shipping 1.6.16.0 which is required by
          # cabal-install, but we need to recompile process even if the correct
          # version is available to prevent inconsistent dependencies:
          # process depends on directory.
          process = cself.process_1_6_17_0;

          # hspec < 2.10 depends on ghc (the library) directly which in turn
          # depends on directory, causing a dependency conflict which is practically
          # not solvable short of recompiling GHC. Instead of adding
          # allowInconsistentDependencies for all reverse dependencies of hspec-core,
          # just upgrade to an hspec version without the offending dependency.
          hspec-core = cself.hspec-core_2_11_1;
          hspec-discover = cself.hspec-discover_2_11_1;
          hspec = cself.hspec_2_11_1;

          # hspec-discover and hspec-core depend on hspec-meta for testing which
          # we need to avoid since it depends on ghc as well. Since hspec*_2_11*
          # are overridden to take the versioned attributes as inputs, we need
          # to make sure to override the versioned attribute with this fix.
          hspec-discover_2_11_1 = dontCheck csuper.hspec-discover_2_11_1;

          # Prevent dependency on doctest which causes an inconsistent dependency
          # due to depending on ghc which depends on directory etc.
          vector = dontCheck csuper.vector;
        };
    in
    {
      cabal-install = super.cabal-install.overrideScope cabalInstallOverlay;
      cabal-install-solver = super.cabal-install-solver.overrideScope cabalInstallOverlay;

      guardian = lib.pipe
        # Needs cabal-install >= 3.8 /as well as/ matching Cabal
        (super.guardian.overrideScope (self: super:
          cabalInstallOverlay self super // {
            # Needs at least path-io 1.8.0 due to canonicalizePath changes
            path-io = self.path-io_1_8_1;
          }
        ))
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

  #######################################
  ### HASKELL-LANGUAGE-SERVER SECTION ###
  #######################################

  haskell-language-server = (lib.pipe super.haskell-language-server [
    dontCheck
    (disableCabalFlag "stan") # Sorry stan is totally unmaintained and terrible to get to run. It only works on ghc 8.8 or 8.10 anyways …
  ]).overrideScope (lself: lsuper: {
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
  });

  # 2023-04-03: https://github.com/haskell/haskell-language-server/issues/3546#issuecomment-1494139751
  # There will probably be a new revision soon.
  hls-brittany-plugin = assert super.hls-brittany-plugin.version == "1.1.0.0"; doJailbreak super.hls-brittany-plugin;

  hls-hlint-plugin = super.hls-hlint-plugin.override {
    # For "ghc-lib" flag see https://github.com/haskell/haskell-language-server/issues/3185#issuecomment-1250264515
    hlint = enableCabalFlag "ghc-lib" super.hlint;
    apply-refact = self.apply-refact_0_11_0_0;
  };

  # For -f-auto see cabal.project in haskell-language-server.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser (disableCabalFlag "auto" super.ghc-lib-parser-ex);

  # Test ldap server test/ldap.js is missing from sdist
  # https://github.com/supki/ldap-client/issues/18
  ldap-client-og = dontCheck super.ldap-client-og;

  # For -fghc-lib see cabal.project in haskell-language-server.
  stylish-haskell = if lib.versionAtLeast super.ghc.version "9.2"
    then enableCabalFlag "ghc-lib"
      (if lib.versionAtLeast super.ghc.version "9.4"
       then super.stylish-haskell_0_14_4_0
       else super.stylish-haskell)
    else super.stylish-haskell;

  ###########################################
  ### END HASKELL-LANGUAGE-SERVER SECTION ###
  ###########################################

  vector = overrideCabal (old: {
    # Too strict bounds on doctest which isn't used, but is part of the configuration
    jailbreak = true;
    # vector-doctest seems to be broken when executed via ./Setup test
    testTarget = lib.concatStringsSep " " [
      "vector-tests-O0"
      "vector-tests-O2"
    ];
    patches = [
      # Workaround almost guaranteed floating point errors in test suite with quickcheck 2.14.3
      # https://github.com/haskell/vector/issues/460
      (pkgs.fetchpatch {
        name = "vector-quickcheck-2.14.3-float-workaround.patch";
        url = "https://github.com/haskell/vector/commit/df8dd8e8e84005aa6b187b03cd502f3c6e18cf3c.patch";
        sha256 = "040wg8mqlkdnrl5axy9wk0mlpn8rpc4vc4afpxignj9i7yc4pfjj";
        stripLen = 1;
     })
   ];
  }) super.vector;

  # Almost guaranteed failure due to floating point imprecision with QuickCheck-2.14.3
  # https://github.com/haskell/math-functions/issues/73
  math-functions = overrideCabal (drv: {
    testFlags = drv.testFlags or [] ++ [ "-p" "! /Kahan.t_sum_shifted/" ];
  }) super.math-functions;

  # Deal with infinite and NaN values generated by QuickCheck-2.14.3
  inherit (
    let
      aesonQuickCheckPatch = appendPatches [
        (pkgs.fetchpatch {
          name = "aeson-quickcheck-2.14.3-double-workaround.patch";
          url = "https://github.com/haskell/aeson/commit/58766a1916b4980792763bab74f0c86e2a7ebf20.patch";
          sha256 = "1jk2xyi9g6dfjsi6hvpvkpmag3ivimipwy1izpbidf3wvc9cixs3";
        })
      ];
    in
    {
      aeson = aesonQuickCheckPatch super.aeson;
      aeson_2_1_2_1 = aesonQuickCheckPatch super.aeson_2_1_2_1;
    }
  ) aeson
    aeson_2_1_2_1
    ;

  # 2023-06-28: Test error: https://hydra.nixos.org/build/225565149
  orbits = dontCheck super.orbits;

  # 2023-06-28: Test error: https://hydra.nixos.org/build/225559546
  monad-bayes = dontCheck super.monad-bayes;

  # Disable tests failing on odd floating point numbers generated by QuickCheck 2.14.3
  # https://github.com/haskell/statistics/issues/205
  statistics = overrideCabal (drv: {
    testFlags = [
      "-p" "! (/Pearson correlation/ || /t_qr/ || /Tests for: FDistribution.1-CDF is correct/)"
    ];
  }) super.statistics;

  # There are numerical tests on random data, that may fail occasionally
  lapack = dontCheck super.lapack;

  # fix tests failure for base≥4.15 (https://github.com/kim/leveldb-haskell/pull/41)
  leveldb-haskell = appendPatch (fetchpatch {
    url = "https://github.com/kim/leveldb-haskell/commit/f5249081f589233890ddb1945ec548ca9fb717cf.patch";
    sha256 = "14gllipl28lqry73c5dnclsskzk1bsrrgazibl4lkl8z98j2csjb";
  }) super.leveldb-haskell;

  # Arion's test suite needs a Nixpkgs, which is cumbersome to do from Nixpkgs
  # itself. For instance, pkgs.path has dirty sources and puts a huge .git in the
  # store. Testing is done upstream.
  arion-compose = dontCheck super.arion-compose;

  # This used to be a core package provided by GHC, but then the compiler
  # dropped it. We define the name here to make sure that old packages which
  # depend on this library still evaluate (even though they won't compile
  # successfully with recent versions of the compiler).
  bin-package-db = null;

  # Unnecessarily requires alex >= 3.3
  # https://github.com/glguy/config-value/commit/c5558c8258598fab686c259bff510cc1b19a0c50#commitcomment-119514821
  config-value = doJailbreak super.config-value;

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

  # 2023-04-17: https://gitlab.haskell.org/ghc/ghc-debug/-/issues/20
  ghc-debug-brick = doJailbreak super.ghc-debug-brick;

  # Needs older QuickCheck version
  attoparsec-varword = dontCheck super.attoparsec-varword;

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;
  ghc-vis = disableLibraryProfiling super.ghc-vis;

  # 2023-06-10: Too strict version bound on https://github.com/haskell/ThreadScope/issues/118
  threadscope = doJailbreak super.threadscope;

  # patat main branch has an unreleased commit that fixes the build by
  # relaxing restrictive upper boundaries. This can be removed once there's a
  # new release following version 0.8.8.0.
  patat = appendPatch (fetchpatch {
    url = "https://github.com/jaspervdj/patat/commit/be9e0fe5642ba6aa7b25705ba17950923e9951fa.patch";
    sha256 = "sha256-Vxxi46qrkIyzYQZ+fe1vNTPldcQEI2rX2H40GvFJR2M=";
    excludes = ["stack.yaml" "stack.yaml.lock"];
  }) super.patat;

  # The latest release on hackage has an upper bound on containers which
  # breaks the build, though it works with the version of containers present
  # and the upper bound doesn't exist in code anymore:
  # > https://github.com/roelvandijk/numerals
  numerals = doJailbreak (dontCheck super.numerals);

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;
  mysql-haskell = dontCheck super.mysql-haskell;

  # The Hackage tarball is purposefully broken, because it's not intended to be, like, useful.
  # https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  git-annex = overrideCabal (drv: {
    src = pkgs.fetchgit {
      name = "git-annex-${super.git-annex.version}-src";
      url = "git://git-annex.branchable.com/";
      rev = "refs/tags/" + super.git-annex.version;
      sha256 = "0mz1b3vnschsndv42787mm6kybpb2yskkdss3rcm7xc6jjh815ik";
      # delete android and Android directories which cause issues on
      # darwin (case insensitive directory). Since we don't need them
      # during the build process, we can delete it to prevent a hash
      # mismatch on darwin.
      postFetch = ''
        rm -r $out/doc/?ndroid*
      '';
    };

    # Git annex provides a restricted login shell. Setting
    # passthru.shellPath here allows a user's login shell to be set to
    # `git-annex-shell` by making `shell = haskellPackages.git-annex`.
    # https://git-annex.branchable.com/git-annex-shell/
    passthru.shellPath = "/bin/git-annex-shell";
  }) super.git-annex;

  # Too strict bounds on servant
  # Pending a hackage revision: https://github.com/berberman/arch-web/commit/5d08afee5b25e644f9e2e2b95380a5d4f4aa81ea#commitcomment-89230555
  arch-web = doJailbreak super.arch-web;

  # Fix test trying to access /home directory
  shell-conduit = overrideCabal (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";
  }) super.shell-conduit;

  cachix = self.generateOptparseApplicativeCompletions [ "cachix" ] super.cachix;

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # Tests require older versions of tasty.
  hzk = dontCheck super.hzk;
  resolv = doJailbreak super.resolv;

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

  pandoc-cli = throwIfNot (versionOlder super.pandoc.version "3.0.0") "pandoc-cli contains the pandoc executable starting with 3.0, this needs to be considered now." (markBroken (dontDistribute super.pandoc-cli));

  inline-c-cpp = overrideCabal (drv: {
    patches = drv.patches or [] ++ [
      (fetchpatch {
        # awaiting release >0.5.0.0
        url = "https://github.com/fpco/inline-c/commit/e176b8e8c3c94e7d8289a8b7cc4ce8e737741730.patch";
        name = "inline-c-cpp-pr-132-1.patch";
        sha256 = "sha256-CdZXAT3Ar4KKDGyAUu8A7hzddKe5/AuMKoZSjt3o0UE=";
        stripLen = 1;
      })
    ];
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace inline-c-cpp.cabal --replace "-optc-std=c++11" ""
    '';
  }) super.inline-c-cpp;

  inline-java = addBuildDepend pkgs.jdk super.inline-java;

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
  postgresql-simple = dontCheck super.postgresql-simple;
  squeal-postgresql = dontCheck super.squeal-postgresql;
  postgrest-ws = dontCheck super.postgrest-ws;
  snowball = dontCheck super.snowball;
  sophia = dontCheck super.sophia;
  test-sandbox = dontCheck super.test-sandbox;
  texrunner = dontCheck super.texrunner;
  users-postgresql-simple = dontCheck super.users-postgresql-simple;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  xkbcommon = dontCheck super.xkbcommon;
  xmlgen = dontCheck super.xmlgen;
  HerbiePlugin = dontCheck super.HerbiePlugin;
  wai-cors = dontCheck super.wai-cors;

  # 2022-01-29: Tests fail: https://github.com/psibi/streamly-bytestring/issues/27
  # 2022-02-14: Strict upper bound: https://github.com/psibi/streamly-bytestring/issues/30
  streamly-bytestring = dontCheck (doJailbreak super.streamly-bytestring);

  # The package requires streamly == 0.9.*.
  # (We can remove this once the assert starts failing.)
  streamly-archive = super.streamly-archive.override {
    streamly =
      assert (builtins.compareVersions pkgs.haskellPackages.streamly.version "0.9.0" < 0);
        pkgs.haskellPackages.streamly_0_9_0;
  };

  # The package requires streamly == 0.9.*.
  # (We can remove this once the assert starts failing.)
  streamly-lmdb = super.streamly-lmdb.override {
    streamly =
      assert (builtins.compareVersions pkgs.haskellPackages.streamly.version "0.9.0" < 0);
        self.streamly_0_9_0;
  };

  # base bound
  digit = doJailbreak super.digit;

  # 2022-01-29: Tests require package to be in ghc-db.
  aeson-schemas = dontCheck super.aeson-schemas;

  # 2023-04-20: Restrictive bytestring bound in tests.
  storablevector = doJailbreak super.storablevector;

  # 2023-04-20: Pretends to need brick 1.6 but the commit history here
  # https://github.com/matterhorn-chat/matterhorn/commits/master/matterhorn.cabal
  # makes very clear that 1.4 is equally fine.
  # Generally a slightly packaging hostile bound practice.
  matterhorn = doJailbreak super.matterhorn;

  # 2020-06-05: HACK: does not pass own build suite - `dontCheck`
  # 2022-11-24: jailbreak as it has too strict bounds on a bunch of things
  hnix = self.generateOptparseApplicativeCompletions [ "hnix" ] (dontCheck (doJailbreak super.hnix));
  # Too strict bounds on algebraic-graphs and bytestring
  # https://github.com/haskell-nix/hnix-store/issues/180
  hnix-store-core = doJailbreak super.hnix-store-core;

  # Fails for non-obvious reasons while attempting to use doctest.
  focuslist = dontCheck super.focuslist;
  search = dontCheck super.search;

  # see https://github.com/LumiGuide/haskell-opencv/commit/cd613e200aa20887ded83256cf67d6903c207a60
  opencv = dontCheck (appendPatch ./patches/opencv-fix-116.patch super.opencv);
  opencv-extra = dontCheck (appendPatch ./patches/opencv-fix-116.patch super.opencv-extra);

  # Too strict lower bound on hspec
  graphql =
    assert lib.versionOlder self.hspec.version "2.10";
    doJailbreak super.graphql;

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
  postgresql-simple-migration = dontCheck super.postgresql-simple-migration;
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
  saltine = dontCheck super.saltine; # https://github.com/tel/saltine/pull/56
  scp-streams = dontCheck super.scp-streams;
  sdl2 = dontCheck super.sdl2; # the test suite needs an x server
  sdl2-ttf = dontCheck super.sdl2-ttf; # as of version 0.2.1, the test suite requires user intervention
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
  wai-logger = dontCheck super.wai-logger;
  WebBits = dontCheck super.WebBits;                    # http://hydra.cryp.to/build/499604/log/raw
  webdriver = dontCheck super.webdriver;
  webdriver-angular = dontCheck super.webdriver-angular;
  xsd = dontCheck super.xsd;
  zip-archive = dontCheck super.zip-archive;  # https://github.com/jgm/zip-archive/issues/57

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

  # Test suite is missing an import from hspec
  # https://github.com/haskell-works/tasty-discover/issues/9
  # https://github.com/commercialhaskell/stackage/issues/6584#issuecomment-1326522815
  tasty-discover = assert super.tasty-discover.version == "4.2.2"; dontCheck super.tasty-discover;

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

  # Install icons, metadata and cli program.
  bustle = appendPatches [
    # Fix build with libpcap 1.10.2
    # https://gitlab.freedesktop.org/bustle/bustle/-/merge_requests/21
    (pkgs.fetchpatch {
      url = "https://gitlab.freedesktop.org/bustle/bustle/-/commit/77e2de892cd359f779c84739682431a66eb8cf31.patch";
      hash = "sha256-sPb6/Z/ANids53aL9VsMHa/v5y+TA1ZY3jwAXlEH3Ec=";
    })
  ] (overrideCabal (drv: {
    buildDepends = [ pkgs.libpcap ];
    buildTools = with pkgs.buildPackages; [ gettext perl help2man ];
    postInstall = ''
      make install PREFIX=$out
    '';
  }) super.bustle);

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

  # 2022-03-20: descriptive is unmaintained since 2018 and archived on github.com
  # It does not support aeson 2.0
  descriptive = super.descriptive.override { aeson = self.aeson_1_5_6_0; };

  # 2022-03-19: Testsuite is failing: https://github.com/puffnfresh/haskell-jwt/issues/2
  jwt = dontCheck super.jwt;

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

  bloomfilter = appendPatches [
    # https://github.com/bos/bloomfilter/issues/7
    ./patches/bloomfilter-fix-on-32bit.patch
    # Fix build with GHC >= 9.2 by using stock unsafeShift* functions
    # https://github.com/bos/bloomfilter/pull/20
    (pkgs.fetchpatch {
      name = "bloomfilter-ghc-9.2-shift.patch";
      url = "https://github.com/bos/bloomfilter/pull/20/commits/fb79b39c44404fd791a3bed973e9d844fb084f1e.patch";
      sha256 = "0clmr5iar4mhp8nbgh1c1rh4fl7dy0g2kbqqh0af8aqmhjpqzrq3";
    })
  ] (overrideCabal (drv: {
    # Make sure GHC 9.2 patch applies correctly
    revision = null;
    editedCabalFile = null;
    prePatch = drv.prePatch or "" + ''
      "${pkgs.buildPackages.dos2unix}/bin/dos2unix" *.cabal
    '';
  }) super.bloomfilter);

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = appendPatch (fetchpatch {
    url = "https://github.com/augustss/djinn/commit/6cb9433a137fb6b5194afe41d616bd8b62b95630.patch";
    sha256 = "0s021y5nzrh74gfp8xpxpxm11ivzfs3jwg6mkrlyry3iy584xqil";
  }) super.djinn;

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
  # * We need a patch from master to fix compilation with
  #   updated dependencies (haskeline and megaparsec) which can be
  #   removed when the next idris release comes around.
  idris = self.generateOptparseApplicativeCompletions [ "idris" ]
    (appendPatch (fetchpatch {
      name = "idris-libffi-0.2.patch";
      url = "https://github.com/idris-lang/Idris-dev/commit/6d6017f906c5aa95594dba0fd75e7a512f87883a.patch";
      hash = "sha256-wyLjqCyLh5quHMOwLM5/XjlhylVC7UuahAM79D8+uls=";
    }) (doJailbreak (dontCheck super.idris)));

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

  # requires git at test-time *and* runtime, but we'll just rely on users to
  # bring their own git at runtime
  sensei = overrideCabal (drv: {
    testHaskellDepends = drv.testHaskellDepends or [] ++ [ self.hspec-meta_2_10_5 ];
    testToolDepends = drv.testToolDepends or [] ++ [ pkgs.git ];
  }) (super.sensei.override {
    hspec = self.hspec_2_11_1;
    hspec-wai = self.hspec-wai.override {
      hspec = self.hspec_2_11_1;
    };
    hspec-contrib = self.hspec-contrib.override {
      hspec-core = self.hspec-core_2_11_1;
    };
    fsnotify = self.fsnotify_0_4_1_0;
  });

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

  # https://github.com/haskell-hvr/resolv/pull/6
  resolv_0_1_1_2 = dontCheck super.resolv_0_1_1_2;

  # The test suite does not know how to find the 'alex' binary.
  alex = overrideCabal (drv: {
    testSystemDepends = (drv.testSystemDepends or []) ++ [pkgs.which];
    preCheck = ''export PATH="$PWD/dist/build/alex:$PATH"'';
  }) super.alex;

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
  # doJailbreak: waiting on revision 1 to hit hackage
  servant-auth-client = doJailbreak (dontCheck super.servant-auth-client);
  servant-auth-server = doJailbreak super.servant-auth-server;

  # Generate cli completions for dhall.
  dhall = self.generateOptparseApplicativeCompletions [ "dhall" ] super.dhall;
  # For reasons that are not quire clear 'dhall-json' won't compile without 'tasty 1.4' due to its tests
  # https://github.com/commercialhaskell/stackage/issues/5795
  # This issue can be mitigated with 'dontCheck' which skips the tests and their compilation.
  dhall-json = self.generateOptparseApplicativeCompletions ["dhall-to-json" "dhall-to-yaml"] (dontCheck super.dhall-json);
  dhall-nix = self.generateOptparseApplicativeCompletions [ "dhall-to-nix" ]
    (overrideCabal (drv: {
      patches = [
        # Compatibility with hnix 0.16, waiting for release
        # https://github.com/dhall-lang/dhall-haskell/pull/2474
        (pkgs.fetchpatch {
          name = "dhall-nix-hnix-0.16.patch";
          url = "https://github.com/dhall-lang/dhall-haskell/commit/49b9b3e3ce1718a89773c2b1bfa3c2af1a6e8752.patch";
          sha256 = "12sh5md81nlhyzzkmf7jrll3w1rvg2j48m57hfyvjn8has9c4gw6";
          stripLen = 1;
          includes = [ "dhall-nix.cabal" "src/Dhall/Nix.hs" ];
        })
      ] ++ drv.patches or [];
      prePatch = drv.prePatch or "" + ''
        ${pkgs.buildPackages.dos2unix}/bin/dos2unix *.cabal
      '';
    }) super.dhall-nix);
  dhall-yaml = self.generateOptparseApplicativeCompletions ["dhall-to-yaml-ng" "yaml-to-dhall"] super.dhall-yaml;
  dhall-nixpkgs = self.generateOptparseApplicativeCompletions [ "dhall-to-nixpkgs" ]
    (overrideCabal (drv: {
      # Allow hnix 0.16, needs unreleased bounds change
      # https://github.com/dhall-lang/dhall-haskell/pull/2474
      jailbreak = assert drv.version == "1.0.9" && drv.revision == "1"; true;
    }) super.dhall-nixpkgs);

  stack =
    self.generateOptparseApplicativeCompletions
      [ "stack" ]
      (super.stack.override {
        # stack needs to use an exact hpack version.  When changing or removing
        # this override, double-check the upstream stack release to confirm
        # that we are using the correct hpack version. See
        # https://github.com/NixOS/nixpkgs/issues/223390 for more information.
        #
        # hpack tests fail because of https://github.com/sol/hpack/issues/528
        hpack = dontCheck self.hpack_0_35_0;
      });

  # Too strict version bound on hashable-time.
  # Tests require newer package version.
  aeson_1_5_6_0 = dontCheck (doJailbreak super.aeson_1_5_6_0);

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

  # Generate shell completion for spago
  spago = self.generateOptparseApplicativeCompletions [ "spago" ] super.spago;

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

  # Requires pg_ctl command during tests
  beam-postgres = overrideCabal (drv: {
    # https://github.com/NixOS/nixpkgs/issues/198495
    doCheck = pkgs.postgresql.doCheck;
    testToolDepends = (drv.testToolDepends or []) ++ [pkgs.postgresql];
  }) super.beam-postgres;

  # Fix for base >= 4.11
  scat = overrideCabal (drv: {
    patches = [(fetchpatch {
      url    = "https://github.com/redelmann/scat/pull/6.diff";
      sha256 = "07nj2p0kg05livhgp1hkkdph0j0a6lb216f8x348qjasy0lzbfhl";
    })];
  }) super.scat;

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch ./patches/xattr-fix-build.patch super.xattr;

  patch = dontCheck super.patch;

  esqueleto =
    overrideCabal
      (drv: {
        postPatch = drv.postPatch or "" + ''
          # patch out TCP usage: https://nixos.org/manual/nixpkgs/stable/#sec-postgresqlTestHook-tcp
          sed -i test/PostgreSQL/Test.hs \
            -e s^host=localhost^^
        '';
        # https://github.com/NixOS/nixpkgs/issues/198495
        doCheck = pkgs.postgresql.doCheck;
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
      super.esqueleto;

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
    Cabal-syntax = self.Cabal-syntax_3_10_1_0;
  }));

  # 2022-03-12: Pick patches from master for compat with Stackage Nightly
  # 2022-12-07: Lift bounds to allow dependencies shipped with LTS-20
  #             https://github.com/jgm/gitit/pull/683
  gitit = appendPatches [
    (fetchpatch {
      name = "gitit-fix-build-with-hoauth2-2.3.0.patch";
      url = "https://github.com/jgm/gitit/commit/fd534c0155eef1790500c834e612ab22cf9b67b6.patch";
      sha256 = "0hmlqkavn8hr0b4y4hxs1yyg0r79ylkzhzwy1dzbb3a2q86ydd2f";
    })
  ] (doJailbreak super.gitit);

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
        doCheck =
          # https://github.com/commercialhaskell/stackage/issues/6884
          # persistent-postgresql-2.13.5.1 needs persistent-test >= 2.13.1.3 which
          # is incompatible with the stackage version of persistent, so the tests
          # are disabled temporarily.
          false
          # https://github.com/NixOS/nixpkgs/issues/198495
          && pkgs.postgresql.doCheck;
        preCheck = drv.preCheck or "" + ''
          PGDATABASE=test
          PGUSER=test
        '';
        testToolDepends = drv.testToolDepends or [] ++ [
          pkgs.postgresql
          pkgs.postgresqlTestHook
        ];
      })
      super.persistent-postgresql;

  # Test suite requires a later version of persistent-test which depends on persistent 2.14
  # https://github.com/commercialhaskell/stackage/issues/6884
  persistent-sqlite = dontCheck super.persistent-sqlite;

  # 2021-12-26: Too strict bounds on doctest
  polysemy-plugin = doJailbreak super.polysemy-plugin;

  # hasn’t bumped upper bounds
  # upstream: https://github.com/obsidiansystems/which/pull/6
  which = doJailbreak super.which;

  # 2022-09-20: We have overridden lsp to not be the stackage version.
  # dhall-lsp-server needs the older 1.4.0.0 lsp
  dhall-lsp-server = super.dhall-lsp-server.override {
    lsp = dontCheck (super.lsp_1_4_0_0.override {
      lsp-types = super.lsp-types_1_4_0_1;
    });
  };

  # 2023-06-24: too strict upper bound on bytestring
  jsaddle-webkit2gtk =
    appendPatches [
      (pkgs.fetchpatch {
        name = "jsaddle-webkit2gtk-ghc-9.2.patch";
        url = "https://github.com/ghcjs/jsaddle/commit/d2ce9e6be1dcba0ab417314a0b848012d1a47e03.diff";
        stripLen = 1;
        includes = [ "jsaddle-webkit2gtk.cabal" ];
        sha256 = "16pcs3l7s8shhcnrhi80bwjgy7w23csd9b8qpmc5lnxn4wxr4c2r";
      })
      (pkgs.fetchpatch {
        name = "jsaddle-webkit2gtk-ghc-9.6.patch";
        url = "https://github.com/ghcjs/jsaddle/commit/99b23dac8b4c5b23f5ed7963e681a46c1abdd1a5.patch";
        sha256 = "02rdifap9vzf6bhjp5siw68ghjrxh2phzd0kwjihf3hxi4a2xlp3";
        stripLen = 1;
        includes = [ "jsaddle-webkit2gtk.cabal" ];
      })
    ] super.jsaddle-webkit2gtk;

  # 2022-03-16: lens bound can be loosened https://github.com/ghcjs/jsaddle-dom/issues/19
  jsaddle-dom = overrideCabal (old: {
    postPatch = old.postPatch or "" + ''
      sed -i 's/lens.*4.20/lens/' jsaddle-dom.cabal
    '';
  }) (doJailbreak super.jsaddle-dom);

  # Tests disabled and broken override needed because of missing lib chrome-test-utils: https://github.com/reflex-frp/reflex-dom/issues/392
  # 2022-03-16: Pullrequest for ghc 9 compat https://github.com/reflex-frp/reflex-dom/pull/433
  reflex-dom-core = overrideCabal (old: {
    postPatch = old.postPatch or "" + ''
      sed -i 's/template-haskell.*2.17/template-haskell/' reflex-dom-core.cabal
    '';
    })
    ((appendPatches [
      (fetchpatch {
        url = "https://github.com/reflex-frp/reflex-dom/commit/1814640a14c6c30b1b2299e74d08fb6fcaadfb94.patch";
        sha256 = "sha256-QyX2MLd7Tk0M1s0DU0UV3szXs8ngz775i3+KI62Q3B8=";
        relative = "reflex-dom-core";
      })
      (fetchpatch {
        url = "https://github.com/reflex-frp/reflex-dom/commit/56fa8a484ccfc7d3365d07fea3caa430155dbcac.patch";
        sha256 = "sha256-IogAYJZac17Bg99ZnnFX/7I44DAnHo2PRBWD0iVHbNA=";
        relative = "reflex-dom-core";
      })
    ]
          (doDistribute (unmarkBroken (dontCheck (doJailbreak super.reflex-dom-core))))));

  # Tests disabled because they assume to run in the whole jsaddle repo and not the hackage tarball of jsaddle-warp.
  jsaddle-warp = dontCheck super.jsaddle-warp;

  # 2020-06-24: Jailbreaking because of restrictive test dep bounds
  # Upstream issue: https://github.com/kowainik/trial/issues/62
  trial = doJailbreak super.trial;

  # 2020-06-24: Tests are broken in hackage distribution.
  # See: https://github.com/robstewart57/rdf4h/issues/39
  rdf4h = dontCheck super.rdf4h;

  # hasn't bumped upper bounds
  # test fails: "floskell-test: styles/base.md: openBinaryFile: does not exist (No such file or directory)"
  # https://github.com/ennocramer/floskell/issues/48
  floskell = dontCheck (doJailbreak super.floskell);

  # hasn't bumped upper bounds
  # test fails because of a "Warning: Unused LANGUAGE pragma"
  # https://github.com/ennocramer/monad-dijkstra/issues/4
  monad-dijkstra = dontCheck super.monad-dijkstra;

  # Fixed upstream but not released to Hackage yet:
  # https://github.com/k0001/hs-libsodium/issues/2
  libsodium = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [self.buildHaskellPackages.c2hs];
  }) super.libsodium;

  svgcairo = appendPatches [
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
  ] super.svgcairo;

  # Upstream PR: https://github.com/jkff/splot/pull/9
  splot = appendPatch (fetchpatch {
    url = "https://github.com/jkff/splot/commit/a6710b05470d25cb5373481cf1cfc1febd686407.patch";
    sha256 = "1c5ck2ibag2gcyag6rjivmlwdlp5k0dmr8nhk7wlkzq2vh7zgw63";
  }) super.splot;

  # Fix build with newer monad-logger: https://github.com/obsidiansystems/monad-logger-extras/pull/5
  monad-logger-extras = appendPatch (fetchpatch {
    url = "https://github.com/obsidiansystems/monad-logger-extras/commit/55d414352e740a5ecacf313732074d9b4cf2a6b3.patch";
    sha256 = "sha256-xsQbr/QIrgWR0uwDPtV0NRTbVvP0tR9bY9NMe1JzqOw=";
  }) super.monad-logger-extras;

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
  pg-client = overrideCabal (drv: {
    librarySystemDepends = with pkgs; [ postgresql krb5.dev openssl.dev ];
    testToolDepends = drv.testToolDepends or [] ++ [
      pkgs.postgresql pkgs.postgresqlTestHook
    ];
    # https://github.com/NixOS/nixpkgs/issues/198495
    doCheck = pkgs.postgresql.doCheck;
    preCheck = drv.preCheck or "" + ''
      # empty string means use default connection
      export DATABASE_URL=""
    '';
  }) (super.pg-client.override {
    resource-pool = self.hasura-resource-pool;
    ekg-core = self.hasura-ekg-core;
  });

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

  # Tests rely on `Int` being 64-bit: https://github.com/hspec/hspec/issues/431.
  # Also, we need QuickCheck-2.14.x to build the test suite, which isn't easy in LTS-16.x.
  # So let's not go there and just disable the tests altogether.
  hspec-core = dontCheck super.hspec-core;
  hspec-core_2_7_10 = doDistribute (dontCheck super.hspec-core_2_7_10);

  # tests seem to require a different version of hspec-core
  hspec-contrib = dontCheck super.hspec-contrib;

  # github.com/ucsd-progsys/liquidhaskell/issues/1729
  liquidhaskell = super.liquidhaskell.override { Diff = self.Diff_0_3_4; };
  Diff_0_3_4 = dontCheck super.Diff_0_3_4;

  # The test suite attempts to read `/etc/resolv.conf`, which doesn't work in the sandbox.
  domain-auth = dontCheck super.domain-auth;

  # - Deps are required during the build for testing and also during execution,
  #   so add them to build input and also wrap the resulting binary so they're in
  #   PATH.
  # - Patch can be removed on next package set bump (for v0.2.11)

  # 2023-06-26: Test failure: https://hydra.nixos.org/build/225081865
  update-nix-fetchgit = dontCheck (let deps = [ pkgs.git pkgs.nix pkgs.nix-prefetch-git ];
  in self.generateOptparseApplicativeCompletions [ "update-nix-fetchgit" ] (overrideCabal
    (drv: {
      buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/update-nix-fetchgit" --prefix 'PATH' ':' "${
          lib.makeBinPath deps
        }"
      '';
    }) (addTestToolDepends deps super.update-nix-fetchgit)));

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

  # https://github.com/obsidiansystems/dependent-sum/issues/55
  dependent-sum = doJailbreak super.dependent-sum;

  # 2022-06-19: Disable checks because of https://github.com/reflex-frp/reflex/issues/475
  reflex = doJailbreak (dontCheck super.reflex);

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

  # Give latest hspec correct dependency versions without overrideScope
  hspec_2_11_1 = doDistribute (super.hspec_2_11_1.override {
    hspec-discover = self.hspec-discover_2_11_1;
    hspec-core = self.hspec-core_2_11_1;
  });
  hspec-discover_2_11_1 = doDistribute (super.hspec-discover_2_11_1.override {
    hspec-meta = self.hspec-meta_2_10_5;
  });
  # Need to disable tests to prevent an infinite recursion if hspec-core_2_11_1
  # is overlayed to hspec-core.
  hspec-core_2_11_1 = doDistribute (dontCheck (super.hspec-core_2_11_1.override {
    hspec-meta = self.hspec-meta_2_10_5;
    hspec-expectations = self.hspec-expectations_0_8_3;
  }));

  # Point hspec 2.7.10 to correct dependencies
  hspec_2_7_10 = super.hspec_2_7_10.override {
    hspec-discover = self.hspec-discover_2_7_10;
    hspec-core = self.hspec-core_2_7_10;
  };

  # waiting for aeson bump
  servant-swagger-ui-core = doJailbreak super.servant-swagger-ui-core;

  hercules-ci-agent = lib.pipe super.hercules-ci-agent [
    (appendPatches [
      # https://github.com/hercules-ci/hercules-ci-agent/pull/507
      (fetchpatch {
        url = "https://github.com/hercules-ci/hercules-ci-agent/commit/f5c39d0cbde36a056419cab8d69a67302eb8b0e4.patch";
        sha256 = "sha256-J8N4+HUQ6vlJBCwCyxv8Fv5HSbtiim64Qh1n9CaRe1o=";
        stripLen = 1;
      })
      # https://github.com/hercules-ci/hercules-ci-agent/pull/526
      ./patches/hercules-ci-agent-cachix-1.6.patch
    ])
    (self.generateOptparseApplicativeCompletions [ "hercules-ci-agent" ])
  ];

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

  # 2020-12-05: this package requires a newer version of http-client,
  # but it still compiles with older version:
  # https://github.com/turion/essence-of-live-coding/pull/86
  essence-of-live-coding-warp = doJailbreak super.essence-of-live-coding-warp;

  # 2020-12-06: Restrictive upper bounds w.r.t. pandoc-types (https://github.com/owickstrom/pandoc-include-code/issues/27)
  pandoc-include-code = doJailbreak super.pandoc-include-code;

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

  # Break out of overspecified constraint on QuickCheck.
  filepath-bytestring = doJailbreak super.filepath-bytestring;
  haddock-library = doJailbreak super.haddock-library;

  # Test suite has overly strict bounds on tasty, jailbreaking fails.
  # https://github.com/input-output-hk/nothunks/issues/9
  nothunks = dontCheck super.nothunks;

  # Allow building with older versions of http-client.
  http-client-restricted = doJailbreak super.http-client-restricted;

  # Test suite fails, upstream not reachable for simple fix (not responsive on github)
  vivid-osc = dontCheck super.vivid-osc;
  vivid-supercollider = dontCheck super.vivid-supercollider;

  # while waiting for a new release: https://github.com/brendanhay/amazonka/pull/572
  amazonka = appendPatches [
    (fetchpatch {
      relative = "amazonka";
      url = "https://github.com/brendanhay/amazonka/commit/43ddd87b1ebd6af755b166e16336259ec025b337.patch";
      sha256 = "sha256-9Ed3qrLGRaNCdvqWMyg8ydAnqDkFqWKLLoObv/5jG54=";
    })
  ] (doJailbreak super.amazonka);

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

  # https://github.com/jgm/pandoc/issues/7163
  pandoc = dontCheck super.pandoc;

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

  # Too strict version bounds on cryptonite and github.
  # PRs are merged, will be fixed next release or Hackage revision.
  nix-thunk = appendPatches [
    (fetchpatch {
      url = "https://github.com/obsidiansystems/nix-thunk/commit/49d27a85dd39cd9413c99958c67e596756a502b5.patch";
      sha256 = "1p1n0123yrbdqyfk4kx3gq6bdv65l1bxgbsg51ckcwclg54xp2p5";
    })
    (fetchpatch {
      url = "https://github.com/obsidiansystems/nix-thunk/commit/512867c651977265d5d8f456b538f7a364ec8a8b.patch";
      sha256 = "121yg26y4g28k8xv7y1j6c3pxm17vsjn3vi62kkc8g928c47yd02";
    })
  ] super.nix-thunk;

  # list `modbus` in librarySystemDepends, correct to `libmodbus`
  libmodbus = doJailbreak (addExtraLibrary pkgs.libmodbus super.libmodbus);

  # 2021-04-02: Outdated optparse-applicative bound is fixed but not realeased on upstream.
  trial-optparse-applicative = assert super.trial-optparse-applicative.version == "0.0.0.0"; doJailbreak super.trial-optparse-applicative;

  # 2022-12-28: Too strict version bounds on bytestring
  iconv = doJailbreak super.iconv;

  # 2021-04-02: iCalendar is basically unmaintained.
  # There is a PR for fixing the build: https://github.com/chrra/iCalendar/pull/50
  iCalendar = appendPatches [
    (fetchpatch {
      url = "https://github.com/chrra/iCalendar/commit/66b408f10b2d87929ecda715109b26093c711823.patch";
      sha256 = "sha256-MU5OHUx3L8CaX+xAmoQhAAOMxT7u9Xk1OcOaUHBwK3Y=";
    })
    (fetchpatch {
      url = "https://github.com/chrra/iCalendar/commit/76f5d2e8328cb985f1ee5176e86a5cdd05a17934.patch";
      sha256 = "sha256-Z5V8VTA5Ml9YIRANQn2aD7dljAbR9dq13N11Y3LZdoE=";
    })
   ] super.iCalendar;

  ginger = doJailbreak super.ginger;

  # Too strict version bounds on cryptonite
  # https://github.com/obsidiansystems/haveibeenpwned/issues/7
  haveibeenpwned = doJailbreak super.haveibeenpwned;

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
              # Hack: The following package is a core package of GHCJS. If we don't declare
              # it, then hackage2nix will generate a Hackage database where all dependants
              # of this library are marked as "broken".
              - ghcjs-base-0

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

  # 2022-03-16: Upstream is not bumping bounds https://github.com/ghcjs/jsaddle/issues/123
  jsaddle = overrideCabal (drv: {
    # lift conditional version constraint on ref-tf
    postPatch = ''
      sed -i 's/ref-tf.*,/ref-tf,/' jsaddle.cabal
      sed -i 's/attoparsec.*,/attoparsec,/' jsaddle.cabal
      sed -i 's/time.*,/time,/' jsaddle.cabal
      sed -i 's/(!name)/(! name)/' src/Language/Javascript/JSaddle/Object.hs
    '' + (drv.postPatch or "");
  }) (doJailbreak super.jsaddle);

  # 2022-03-22: Jailbreak for base bound: https://github.com/reflex-frp/reflex-dom/pull/433
  reflex-dom = assert super.reflex-dom.version == "0.6.1.1"; doJailbreak super.reflex-dom;

  # Tests need to lookup target triple x86_64-unknown-linux
  # https://github.com/llvm-hs/llvm-hs/issues/334
  llvm-hs = overrideCabal {
    doCheck = pkgs.stdenv.targetPlatform.system == "x86_64-linux";
  } super.llvm-hs;

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

  # Too strict version bounds on haskell-gi
  # https://github.com/owickstrom/gi-gtk-declarative/issues/100
  gi-gtk-declarative = doJailbreak super.gi-gtk-declarative;
  gi-gtk-declarative-app-simple = doJailbreak super.gi-gtk-declarative-app-simple;

  # 2023-04-09: haskell-ci needs Cabal-syntax 3.10
  haskell-ci = super.haskell-ci.overrideScope (self: super: {
    Cabal-syntax = self.Cabal-syntax_3_10_1_0;
  });

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

  # Needs Cabal >= 3.4
  chs-cabal = super.chs-cabal.override {
    Cabal = self.Cabal_3_6_3_0;
  };

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

  nix-tree = super.nix-tree;

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
  minio-hs = overrideCabal (drv: {
    testFlags = [
      "-p" "!/Test mkSelectRequest/"
    ] ++ drv.testFlags or [];
  }) super.minio-hs;

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

  cabal-fmt = doJailbreak (super.cabal-fmt.override {
    # Needs newer Cabal-syntax version.
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  });

  # Tests require ghc-9.2.
  ema = dontCheck super.ema;

  glirc = doJailbreak (super.glirc.override {
    vty = self.vty_5_35_1;
  });

  # 2022-02-25: Unmaintained and to strict upper bounds
  paths = doJailbreak super.paths;

  # 2022-02-26: https://github.com/emilypi/base64/issues/39
  base64 = dontCheck super.base64;

  # 2022-03-16: Upstream stopped updating bounds https://github.com/haskell-hvr/base-noprelude/pull/15
  base-noprelude = doJailbreak super.base-noprelude;

  # 2022-03-16: Bounds need to be loosened https://github.com/obsidiansystems/dependent-sum-aeson-orphans/issues/10
  dependent-sum-aeson-orphans = doJailbreak super.dependent-sum-aeson-orphans;

  # 2022-03-16: package qualified import issue: https://github.com/ghcjs/ghcjs-dom/issues/101
  ghcjs-dom = assert super.ghcjs-dom.version == "0.9.5.0"; overrideCabal (old: {
    postPatch = ''
      sed -i 's/import "jsaddle-dom" GHCJS.DOM.Document/import "ghcjs-dom-jsaddle" GHCJS.DOM.Document/' src/GHCJS/DOM/Document.hs
    '' + (old.postPatch or "");
    })
    super.ghcjs-dom;

  # Too strict bounds on chell: https://github.com/fpco/haskell-filesystem/issues/24
  system-fileio = doJailbreak super.system-fileio;

  # Bounds too strict on base and ghc-prim: https://github.com/tibbe/ekg-core/pull/43 (merged); waiting on hackage release
  ekg-core = assert super.ekg-core.version == "0.1.1.7"; doJailbreak super.ekg-core;
  hasura-ekg-core = doJailbreak super.hasura-ekg-core;

  # https://github.com/Synthetica9/nix-linter/issues/65
  nix-linter = super.nix-linter.overrideScope (self: super: {
    aeson = self.aeson_1_5_6_0;
  });

  # Test suite doesn't support hspec 2.8
  # https://github.com/zellige/hs-geojson/issues/29
  geojson = dontCheck super.geojson;

  # Test data missing from sdist
  # https://github.com/ngless-toolkit/ngless/issues/152
  NGLess = dontCheck super.NGLess;

  # Raise version bounds for hspec
  records-sop = appendPatch (fetchpatch {
    url = "https://github.com/kosmikus/records-sop/pull/11/commits/d88831388ab3041190130fec3cdd679a4217b3c7.patch";
    sha256 = "sha256-O+v/OxvqnlWX3HaDvDIBZnJ+Og3xs/SJqI3gaouU3ZI=";
  }) super.records-sop;

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

  # Unreleased bound relaxing patch allowing scotty 0.12
  taffybar = appendPatch (pkgs.fetchpatch {
    name = "taffybar-allow-scotty-0.12.patch";
    url = "https://github.com/taffybar/taffybar/commit/2e428ba550fc51067526a0350b91185acef72d19.patch";
    sha256 = "1lpcz671mk5cwqffjfi9ncc0d67bmwgzypy3i37a2fhfmxd0y3nl";
  }) ((p: assert p.version == "4.0.0"; p) super.taffybar);

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

  # 2022-09-20: Restrictive upper bound on lsp
  futhark = doJailbreak super.futhark;

  # Too strict bounds on hspec
  # https://github.com/klapaucius/vector-hashtables/issues/11
  vector-hashtables = doJailbreak super.vector-hashtables;

  # doctest-parallel is broken with v1-style cabal-install / Setup.hs
  # https://github.com/martijnbastiaan/doctest-parallel/issues/22
  doctest-parallel = dontCheck super.doctest-parallel;
  clash-prelude = dontCheck super.clash-prelude;

  # Too strict upper bound on th-desugar, fixed in 3.1.1
  singletons-th = assert super.singletons-th.version == "3.1"; doJailbreak super.singletons-th;
  singletons-base = doJailbreak super.singletons-base;

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
      # TODO(@cdepillabout): maybe unify with the spago overlay in configuration-nix.nix?
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

  # 2022-11-15: Needs newer witch package and brick 1.3 which in turn works with text-zipper 0.12
  # Other dependencies are resolved with doJailbreak for both swarm and brick_1_3
  swarm = doJailbreak (super.swarm.override {
    brick = doJailbreak (dontCheck super.brick_1_9);
  });

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

  emanote = super.emanote.overrideScope (lself: lsuper: {
    commonmark-extensions = lself.commonmark-extensions_0_2_3_2;
  });

  # Test files missing from sdist
  # https://github.com/tweag/webauthn/issues/166
  webauthn = dontCheck super.webauthn;

  # Too strict lower bound on hspec
  wai-token-bucket-ratelimiter =
    assert lib.versionOlder self.hspec.version "2.10";
    doJailbreak super.wai-token-bucket-ratelimiter;

  # doctest <0.19
  polysemy = doJailbreak super.polysemy;

  # multiple bounds too strict
  co-log-polysemy = doJailbreak super.co-log-polysemy;
  co-log-polysemy-formatting = doJailbreak super.co-log-polysemy-formatting;

  # 2022-12-02: Needs newer postgrest package
  # 2022-12-02: Hackage release lags behind actual releases: https://github.com/PostgREST/postgrest/issues/2275
  # 2022-12-02: Too strict bounds: https://github.com/PostgREST/postgrest/issues/2580
  # 2022-12-02: Tests require running postresql server
  postgrest = dontCheck (doJailbreak (overrideSrc rec {
    version = "10.1.1";
    src = pkgs.fetchFromGitHub {
      owner = "PostgREST";
      repo = "postgrest";
      rev = "v${version}";
      sha256 = "sha256-ceSPBH+lzGU1OwjolcaE1BCpkKCJrvMU5G8TPeaJesM=";
    };
  } super.postgrest));

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

  # 2023-03-13: restrictive bounds on validation-selective (>=0.1.0 && <0.2).
  # Get rid of this in the next release: https://github.com/kowainik/tomland/commit/37f16460a6dfe4606d48b8b86c13635d409442cd
  tomland = doJailbreak super.tomland;

  # 2023-04-05: The last version to support libsoup-2.4, required for
  # compatibility with other gi- packages.
  # Take another look when gi-webkit2 updates as it may have become compatible with libsoup-3
  gi-soup = assert versions.major self.gi-webkit2.version == "4"; self.gi-soup_2_4_28;

  llvm-ffi = super.llvm-ffi.override {
    LLVM = pkgs.llvmPackages_13.libllvm;
  };

  # libfuse3 fails to mount fuse file systems within the build environment
  libfuse3 = dontCheck super.libfuse3;

  # Tests fail due to the newly-build fourmolu not being in PATH
  # https://github.com/fourmolu/fourmolu/issues/231
  fourmolu_0_13_0_0 = dontCheck (super.fourmolu_0_13_0_0.overrideScope (lself: lsuper: {
    Cabal-syntax = lself.Cabal-syntax_3_10_1_0;
    ghc-lib-parser = lself.ghc-lib-parser_9_6_2_20230523;
    parsec = lself.parsec_3_1_16_1;
    text = lself.text_2_0_2;
  }));

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
} // import ./configuration-tensorflow.nix {inherit pkgs haskellLib;} self super
