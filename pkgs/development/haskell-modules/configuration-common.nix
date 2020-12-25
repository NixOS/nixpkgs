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

with haskellLib;

self: super: {

  # Arion's test suite needs a Nixpkgs, which is cumbersome to do from Nixpkgs
  # itself. For instance, pkgs.path has dirty sources and puts a huge .git in the
  # store. Testing is done upstream.
  arion-compose = dontCheck super.arion-compose;

  # This used to be a core package provided by GHC, but then the compiler
  # dropped it. We define the name here to make sure that old packages which
  # depend on this library still evaluate (even though they won't compile
  # successfully with recent versions of the compiler).
  bin-package-db = null;

  # waiting for release: https://github.com/jwiegley/c2hsc/issues/41
  c2hsc = appendPatch super.c2hsc (pkgs.fetchpatch {
    url = "https://github.com/jwiegley/c2hsc/commit/490ecab202e0de7fc995eedf744ad3cb408b53cc.patch";
    sha256 = "1c7knpvxr7p8c159jkyk6w29653z5yzgjjqj11130bbb8mk9qhq7";
  });

  # Some Hackage packages reference this attribute, which exists only in the
  # GHCJS package set. We provide a dummy version here to fix potential
  # evaluation errors.
  ghcjs-base = null;
  ghcjs-prim = null;

  # enable using a local hoogle with extra packagages in the database
  # nix-shell -p "haskellPackages.hoogleLocal { packages = with haskellPackages; [ mtl lens ]; }"
  # $ hoogle server
  hoogleLocal = { packages ? [] }: self.callPackage ./hoogle.nix { inherit packages; };

  # Needs older QuickCheck version
  attoparsec-varword = dontCheck super.attoparsec-varword;

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;
  mysql-haskell = dontCheck super.mysql-haskell;

  # The Hackage tarball is purposefully broken, because it's not intended to be, like, useful.
  # https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  git-annex = (overrideSrc super.git-annex {
    src = pkgs.fetchgit {
      name = "git-annex-${super.git-annex.version}-src";
      url = "git://git-annex.branchable.com/";
      rev = "refs/tags/" + super.git-annex.version;
      sha256 = "1l2syrslba4mrxjzj0iblflz72siw3ibqri6p5hf59fk7rmm30a8";
    };
  }).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  # Backport fix for bash: compgen: command not found
  # which happens in nix-shell when a non-interactive bash is on PATH
  # PR to master: https://github.com/pcapriotti/optparse-applicative/pull/408
  optparse-applicative = appendPatch super.optparse-applicative (pkgs.fetchpatch {
    name = "optparse-applicative-0.15.1-hercules-ci-compgen.diff";
    url = "https://github.com/hercules-ci/optparse-applicative/compare/0.15.1...hercules-ci:0.15.1-nixpkgs-compgen.diff";
    sha256 = "1bcp6b7gvc8pqbn1n1ybhizkkl5if7hk9ipgl746vk08v0d3xxql";
  });

  # Fix test trying to access /home directory
  shell-conduit = overrideCabal super.shell-conduit (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";

    # the tests for shell-conduit on Darwin illegitimatey assume non-GNU echo
    # see: https://github.com/psibi/shell-conduit/issues/12
    doCheck = !pkgs.stdenv.isDarwin;
  });

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # Tests require older tasty
  hzk = dontCheck super.hzk;

  # Tests require a Kafka broker running locally
  haskakafka = dontCheck super.haskakafka;

  # Depends on broken "lss" package.
  snaplet-lss = dontDistribute super.snaplet-lss;

  # Depends on broken "NewBinary" package.
  ASN1 = dontDistribute super.ASN1;

  # Depends on broken "frame" package.
  frame-markdown = dontDistribute super.frame-markdown;

  # Depends on broken "Elm" package.
  hakyll-elm = dontDistribute super.hakyll-elm;
  haskelm = dontDistribute super.haskelm;
  snap-elm = dontDistribute super.snap-elm;

  # Depends on broken "hails" package.
  hails-bin = dontDistribute super.hails-bin;

  bindings-levmar = overrideCabal super.bindings-levmar (drv: {
    extraLibraries = [ pkgs.blas ];
  });

  # The Haddock phase fails for one reason or another.
  deepseq-magic = dontHaddock super.deepseq-magic;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # sse2 flag due to https://github.com/haskell/vector/issues/47.
  vector = if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector;

  conduit-extra = if pkgs.stdenv.isDarwin
    then super.conduit-extra.overrideAttrs (drv: { __darwinAllowLocalNetworking = true; })
    else super.conduit-extra;

  # Fix Darwin build.
  halive = if pkgs.stdenv.isDarwin
    then addBuildDepend super.halive pkgs.darwin.apple_sdk.frameworks.AppKit
    else super.halive;

  # Test suite fails due golden tests checking text representation
  # of normalized dhall expressions, and newer dhall versions format
  # differently.
  hpack-dhall =
    if pkgs.lib.versionOlder "0.5.2" super.hpack-dhall.version
    then throw "Drop dontCheck override for hpack-dhall > 0.5.2"
    else dontCheck super.hpack-dhall;

  barbly = addBuildDepend super.barbly pkgs.darwin.apple_sdk.frameworks.AppKit;

  # Hakyll's tests are broken on Darwin (3 failures); and they require util-linux
  hakyll = if pkgs.stdenv.isDarwin
    then dontCheck (overrideCabal super.hakyll (drv: {
      testToolDepends = [];
    }))
    else super.hakyll;

  double-conversion = if !pkgs.stdenv.isDarwin
    then super.double-conversion
    else addExtraLibrary super.double-conversion pkgs.libcxx;

  inline-c-cpp = overrideCabal super.inline-c-cpp (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace inline-c-cpp.cabal --replace "-optc-std=c++11" ""
    '';
  });

  inline-java = addBuildDepend super.inline-java pkgs.jdk;

  # Upstream notified by e-mail.
  permutation = dontCheck super.permutation;

  # https://github.com/jputcu/serialport/issues/25
  serialport = dontCheck super.serialport;

  # Test suite depends on source code being available
  simple-affine-space = dontCheck super.simple-affine-space;

  # Fails no apparent reason. Upstream has been notified by e-mail.
  assertions = dontCheck super.assertions;

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
  postgrest = dontCheck super.postgrest;
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

  # base bound
  digit = doJailbreak super.digit;

  # 2020-06-05: HACK: does not pass own build suite - `dontCheck` We should
  # generate optparse-applicative completions for the hnix executable.  Sadly
  # building of the executable has been disabled for ghc < 8.10 in hnix.
  # Generating the completions should be activated again, once we default to
  # ghc 8.10.
  hnix = dontCheck (super.hnix.override {
    # 2020-09-18: Those packages are all needed by hnix at versions newer than on stackage
    prettyprinter = self.prettyprinter_1_7_0; # at least 1.7

  });

  # Fails for non-obvious reasons while attempting to use doctest.
  search = dontCheck super.search;

  # see https://github.com/LumiGuide/haskell-opencv/commit/cd613e200aa20887ded83256cf67d6903c207a60
  opencv = dontCheck (appendPatch super.opencv ./patches/opencv-fix-116.patch);
  opencv-extra = dontCheck (appendPatch super.opencv-extra ./patches/opencv-fix-116.patch);

  # https://github.com/ekmett/structures/issues/3
  structures = dontCheck super.structures;

  # Disable test suites to fix the build.
  acme-year = dontCheck super.acme-year;                # http://hydra.cryp.to/build/497858/log/raw
  aeson-lens = dontCheck super.aeson-lens;              # http://hydra.cryp.to/build/496769/log/raw
  aeson-schema = dontCheck super.aeson-schema;          # https://github.com/timjb/aeson-schema/issues/9
  angel = dontCheck super.angel;
  apache-md5 = dontCheck super.apache-md5;              # http://hydra.cryp.to/build/498709/nixlog/1/raw
  app-settings = dontCheck super.app-settings;          # http://hydra.cryp.to/build/497327/log/raw
  aws = appendPatch (dontCheck super.aws)               # needs aws credentials
        (pkgs.fetchpatch {
          # https://github.com/aristidb/aws/pull/271
          # bump a version bound
          url = https://github.com/aristidb/aws/commit/3639262ccd6761dea76f052692ac3aefbd254723.patch;
          sha256 = "0nxaspldgayqjnidda8w7wps5gdpr2wz6vynl7vkaw8kzxks9bci";
        });
  aws-kinesis = dontCheck super.aws-kinesis;            # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol;    # http://hydra.cryp.to/build/499749/log/raw
  binary-search = dontCheck super.binary-search;
  bits = dontCheck super.bits;                          # http://hydra.cryp.to/build/500239/log/raw
  bloodhound = dontCheck super.bloodhound;
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection;    # http://hydra.cryp.to/build/496948/log/raw
  cabal-meta = dontCheck super.cabal-meta;              # http://hydra.cryp.to/build/497892/log/raw
  camfort = dontCheck super.camfort;
  cjk = dontCheck super.cjk;
  CLI = dontCheck super.CLI;                            # Upstream has no issue tracker.
  command-qq = dontCheck super.command-qq;              # http://hydra.cryp.to/build/499042/log/raw
  conduit-connection = dontCheck super.conduit-connection;
  craftwerk = dontCheck super.craftwerk;
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
  ghc-events = dontCheck super.ghc-events;              # http://hydra.cryp.to/build/498226/log/raw
  ghc-events-parallel = dontCheck super.ghc-events-parallel;    # http://hydra.cryp.to/build/496828/log/raw
  ghc-imported-from = dontCheck super.ghc-imported-from;
  ghc-parmake = dontCheck super.ghc-parmake;
  ghcid = dontCheck super.ghcid;
  git-vogue = dontCheck super.git-vogue;
  github-rest = dontCheck super.github-rest;  # test suite needs the network
  gitlib-cmdline = dontCheck super.gitlib-cmdline;
  GLFW-b = dontCheck super.GLFW-b;                      # https://github.com/bsl/GLFW-b/issues/50
  #next release supports random 1.1; jailbroken because i didn't know about vty when glguy was updating the bounds
  #should be fixed soon. maybe even before this is merged. currently glirc is 2.37
  glirc = doJailbreak (super.glirc.override { random = self.random_1_2_0; });
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
  hlibgit2 = disableHardening super.hlibgit2 [ "format" ];
  hmatrix-tests = dontCheck super.hmatrix-tests;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  hsexif = dontCheck super.hsexif;
  hspec-server = dontCheck super.hspec-server;
  HTF = dontCheck super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http-link-header = dontCheck super.http-link-header; # non deterministic failure https://hydra.nixos.org/build/75041105
  ihaskell = dontCheck super.ihaskell;
  influxdb = dontCheck super.influxdb;
  integer-roots = dontCheck super.integer-roots; # requires an old version of smallcheck, will be fixed in > 1.0
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-nix = if (pkgs.stdenv.hostPlatform.isAarch64 || pkgs.stdenv.hostPlatform.isi686) then dontCheck super.language-nix else super.language-nix; # aarch64: https://ghc.haskell.org/trac/ghc/ticket/15275
  language-slice = dontCheck super.language-slice;
  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lvmrun = disableHardening (dontCheck super.lvmrun) ["format"];
  math-functions = if pkgs.stdenv.isDarwin
    then dontCheck super.math-functions # "erf table" test fails on Darwin https://github.com/bos/math-functions/issues/63
    else super.math-functions;
  matplotlib = dontCheck super.matplotlib;
  # https://github.com/matterhorn-chat/matterhorn/issues/679 they do not want to be on stackage
  matterhorn = doJailbreak super.matterhorn; # this is needed until the end of time :')
  memcache = dontCheck super.memcache;
  metrics = dontCheck super.metrics;
  milena = dontCheck super.milena;
  mockery = if pkgs.stdenv.isDarwin
    then overrideCabal super.mockery (drv: { preCheck = "export TRAVIS=true"; }) # darwin doesn't have sub-second resolution https://github.com/hspec/mockery/issues/11
    else super.mockery;
  modular-arithmetic = dontCheck super.modular-arithmetic; # tests require a very old Glob (0.7.*)
  nats-queue = dontCheck super.nats-queue;
  netpbm = dontCheck super.netpbm;
  network = dontCheck super.network;
  network-dbus = dontCheck super.network-dbus;
  notcpp = dontCheck super.notcpp;
  ntp-control = dontCheck super.ntp-control;
  numerals = dontCheck super.numerals;
  odpic-raw = dontCheck super.odpic-raw; # needs a running oracle database server
  opaleye = dontCheck super.opaleye;
  openpgp = dontCheck super.openpgp;
  optional = dontCheck super.optional;
  orgmode-parse = dontCheck super.orgmode-parse;
  os-release = dontCheck super.os-release;
  persistent-redis = dontCheck super.persistent-redis;
  pipes-extra = dontCheck super.pipes-extra;
  pipes-websockets = dontCheck super.pipes-websockets;
  posix-pty = dontCheck super.posix-pty; # https://github.com/merijn/posix-pty/issues/12
  postgresql-binary = dontCheck super.postgresql-binary; # needs a running postgresql server
  postgresql-simple-migration = dontCheck super.postgresql-simple-migration;
  process-streaming = dontCheck super.process-streaming;
  punycode = dontCheck super.punycode;
  pwstore-cli = dontCheck super.pwstore-cli;
  quantities = dontCheck super.quantities;
  QuickCheck_2_14_2 = super.QuickCheck_2_14_2.override( {
    splitmix = self.splitmix_0_1_0_3;
  });
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
  snap-core = dontCheck super.snap-core;
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
  trifecta = if pkgs.stdenv.hostPlatform.isAarch64 then dontCheck super.trifecta else super.trifecta; # affected by this bug https://gitlab.haskell.org/ghc/ghc/-/issues/15275#note_295461
  ua-parser = dontCheck super.ua-parser;
  unagi-chan = dontCheck super.unagi-chan;
  wai-logger = dontCheck super.wai-logger;
  WebBits = dontCheck super.WebBits;                    # http://hydra.cryp.to/build/499604/log/raw
  webdriver = dontCheck super.webdriver;
  webdriver-angular = dontCheck super.webdriver-angular;
  xsd = dontCheck super.xsd;
  zip-archive = dontCheck super.zip-archive;  # https://github.com/jgm/zip-archive/issues/57

  random_1_2_0 = super.random_1_2_0.override ({ splitmix = self.splitmix_0_1_0_3; });
  # These test suites run for ages, even on a fast machine. This is nuts.
  Random123 = dontCheck super.Random123;
  systemd = dontCheck super.systemd;

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  snappy = dontCheck super.snappy;

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  vty = dontCheck super.vty;

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/pixbi/duplo/issues/25
  duplo = dontCheck super.duplo;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary super.mikmod pkgs.libmikmod;

  # https://github.com/basvandijk/threads/issues/10
  threads = dontCheck super.threads;

  # Missing module.
  rematch = dontCheck super.rematch;            # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text;  # https://github.com/tcrayford/rematch/issues/6

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal super.paypal-adaptive-hoops (drv: { testTarget = "local"; });

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

  # Waiting on language-python 0.5.8 https://github.com/bjpop/language-python/issues/60
  xcffib = dontCheck super.xcffib;

  # https://github.com/afcowie/locators/issues/1
  locators = dontCheck super.locators;

  # Test suite won't compile against tasty-hunit 0.9.x.
  zlib = dontCheck super.zlib;

  # Test suite won't compile against tasty-hunit 0.10.x.
  binary-parser = dontCheck super.binary-parser;
  binary-parsers = dontCheck super.binary-parsers;
  bytestring-strict-builder = dontCheck super.bytestring-strict-builder;
  bytestring-tree-builder = dontCheck super.bytestring-tree-builder;

  # https://github.com/byteverse/bytebuild/issues/19
  bytebuild = dontCheck super.bytebuild;

  # https://github.com/andrewthad/haskell-ip/issues/67
  ip = dontCheck super.ip;

  # https://github.com/ndmitchell/shake/issues/206
  # https://github.com/ndmitchell/shake/issues/267
  shake = overrideCabal super.shake (drv: { doCheck = !pkgs.stdenv.isDarwin && false; });

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
  #   (if pkgs.buildPlatform != pkgs.hostPlatform
  #    then self.buildHaskellPackages.doctest-discover
  #    else dontCheck super.doctest-discover);
  doctest-discover = dontCheck super.doctest-discover;

  # Depends on itself for testing
  tasty-discover = addBuildTool super.tasty-discover
    (if pkgs.buildPlatform != pkgs.hostPlatform
     then self.buildHaskellPackages.tasty-discover
     else dontCheck super.tasty-discover);

  # Waiting on https://github.com/RaphaelJ/friday/pull/36
  friday = doJailbreak super.friday;

  # Won't compile with recent versions of QuickCheck.
  inilist = dontCheck super.inilist;

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # https://github.com/hvr/token-bucket/issues/3
  token-bucket = dontCheck super.token-bucket;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # FPCO's fork of Cabal won't succeed its test suite.
  Cabal-ide-backend = dontCheck super.Cabal-ide-backend;

  # QuickCheck version, also set in cabal2nix
  websockets = dontCheck super.websockets;

  # Avoid spurious test suite failures.
  fft = dontCheck super.fft;

  # This package can't be built on non-Windows systems.
  Win32 = overrideCabal super.Win32 (drv: { broken = !pkgs.stdenv.isCygwin; });
  inline-c-win32 = dontDistribute super.inline-c-win32;
  Southpaw = dontDistribute super.Southpaw;

  # Hydra no longer allows building texlive packages.
  lhs2tex = dontDistribute super.lhs2tex;

  # https://ghc.haskell.org/trac/ghc/ticket/9825
  vimus = overrideCabal super.vimus (drv: { broken = pkgs.stdenv.isLinux && pkgs.stdenv.isi686; });

  # https://github.com/kazu-yamamoto/logger/issues/42
  logger = dontCheck super.logger;

  # vector dependency < 0.12
  imagemagick = doJailbreak super.imagemagick;

  # https://github.com/liyang/thyme/issues/36
  thyme = dontCheck super.thyme;

  # https://github.com/k0ral/hbro-contrib/issues/1
  hbro-contrib = dontDistribute super.hbro-contrib;

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
  Euterpea = appendPatch super.Euterpea (pkgs.fetchpatch {
    url = "https://github.com/Euterpea/Euterpea2/pull/38.patch";
    sha256 = "13g462qmj8c7if797gnyvf8h0cddmm3xy0pjldw48w8f8sr4qsj0";
  });

  # Install icons, metadata and cli program.
  bustle = overrideCabal super.bustle (drv: {
    buildDepends = [ pkgs.libpcap ];
    buildTools = with pkgs.buildPackages; [ gettext perl help2man ];
    postInstall = ''
      make install PREFIX=$out
    '';
  });

  # Byte-compile elisp code for Emacs.
  ghc-mod = overrideCabal super.ghc-mod (drv: {
    preCheck = "export HOME=$TMPDIR";
    testToolDepends = drv.testToolDepends or [] ++ [self.cabal-install];
    doCheck = false;            # https://github.com/kazu-yamamoto/ghc-mod/issues/335
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.emacs];
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.name}/*/${drv.pname}-${drv.version}/elisp" )
      make -C $lispdir
      mkdir -p $data/share/emacs/site-lisp
      ln -s "$lispdir/"*.el{,c} $data/share/emacs/site-lisp/
    '';
  });

  # Build the latest git version instead of the official release. This isn't
  # ideal, but Chris doesn't seem to make official releases any more.
  structured-haskell-mode = overrideCabal super.structured-haskell-mode (drv: {
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
      local lispdir=( "$data/share/${self.ghc.name}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
  });

  # Make elisp files available at a location where people expect it.
  hindent = (overrideCabal super.hindent (drv: {
    # We cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.name}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
    doCheck = false; # https://github.com/chrisdone/hindent/issues/299
  }));

  # https://github.com/bos/configurator/issues/22
  configurator = dontCheck super.configurator;

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/bos/bloomfilter/issues/7
  bloomfilter = appendPatch super.bloomfilter ./patches/bloomfilter-fix-on-32bit.patch;

  # https://github.com/ashutoshrishi/hunspell-hs/pull/3
  hunspell-hs = addPkgconfigDepend (dontCheck (appendPatch super.hunspell-hs ./patches/hunspell.patch)) pkgs.hunspell;

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = appendPatch super.djinn (pkgs.fetchpatch {
    url = "https://github.com/augustss/djinn/commit/6cb9433a137fb6b5194afe41d616bd8b62b95630.patch";
    sha256 = "0s021y5nzrh74gfp8xpxpxm11ivzfs3jwg6mkrlyry3iy584xqil";
  });

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal super.stunclient (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  });

  # The standard libraries are compiled separately.
  idris = generateOptparseApplicativeCompletion "idris" (dontCheck super.idris);

  # build servant docs from the repository
  servant =
    let
      ver = super.servant.version;
      docs = pkgs.stdenv.mkDerivation {
        name = "servant-sphinx-documentation-${ver}";
        src = "${pkgs.fetchFromGitHub {
          owner = "haskell-servant";
          repo = "servant";
          rev = "v${ver}";
          sha256 = "0xk3czk3jhqjxhy0g8r2248m8yxgvmqhgn955k92z0h7p02lfs89";
        }}/doc";
        # Needed after sphinx 1.7.9 -> 1.8.3
        postPatch = ''
          substituteInPlace conf.py --replace "'.md': CommonMarkParser," ""
        '';
        nativeBuildInputs = with pkgs.buildPackages.python3Packages; [ sphinx recommonmark sphinx_rtd_theme ];
        makeFlags = [ "html" ];
        installPhase = ''
          mv _build/html $out
        '';
      };
    in overrideCabal super.servant (old: {
      postInstall = old.postInstall or "" + ''
        ln -s ${docs} ''${!outputDoc}/share/doc/servant
      '';
    });

  # https://github.com/pontarius/pontarius-xmpp/issues/105
  pontarius-xmpp = dontCheck super.pontarius-xmpp;

  # fails with sandbox
  yi-keymap-vim = dontCheck super.yi-keymap-vim;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = doJailbreak super.applicative-quoters;

  # https://hydra.nixos.org/build/42769611/nixlog/1/raw
  # note: the library is unmaintained, no upstream issue
  dataenc = doJailbreak super.dataenc;

  # https://github.com/divipp/ActiveHs-misc/issues/10
  data-pprint = doJailbreak super.data-pprint;

  # horribly outdated (X11 interface changed a lot)
  sindre = markBroken super.sindre;

  # Test suite occasionally runs for 1+ days on Hydra.
  distributed-process-tests = dontCheck super.distributed-process-tests;

  # https://github.com/mulby/diff-parse/issues/9
  diff-parse = doJailbreak super.diff-parse;

  # https://github.com/josefs/STMonadTrans/issues/4
  STMonadTrans = dontCheck super.STMonadTrans;

  # No upstream issue tracker
  hspec-expectations-pretty-diff = dontCheck super.hspec-expectations-pretty-diff;

  # Don't depend on chell-quickcheck, which doesn't compile due to restricting
  # QuickCheck to versions ">=2.3 && <2.9".
  system-filepath = dontCheck super.system-filepath;

  # https://github.com/hvr/uuid/issues/28
  uuid-types = doJailbreak super.uuid-types;
  uuid = doJailbreak super.uuid;

  # The tests spuriously fail
  libmpd = dontCheck super.libmpd;

  # https://github.com/diagrams/diagrams-lib/issues/288
  diagrams-lib = overrideCabal super.diagrams-lib (drv: { doCheck = !pkgs.stdenv.isi686; });

  # https://github.com/danidiaz/streaming-eversion/issues/1
  streaming-eversion = dontCheck super.streaming-eversion;

  # https://github.com/danidiaz/tailfile-hinotify/issues/2
  tailfile-hinotify = dontCheck super.tailfile-hinotify;

  # Test suite fails: https://github.com/lymar/hastache/issues/46.
  # Don't install internal mkReadme tool.
  hastache = overrideCabal super.hastache (drv: {
    doCheck = false;
    postInstall = "rm $out/bin/mkReadme && rmdir $out/bin";
  });

  # Has a dependency on outdated versions of directory.
  cautious-file = doJailbreak (dontCheck super.cautious-file);

  # https://github.com/diagrams/diagrams-solve/issues/4
  diagrams-solve = dontCheck super.diagrams-solve;

  # test suite does not compile with recent versions of QuickCheck
  integer-logarithms = dontCheck (super.integer-logarithms);

  # missing dependencies: blaze-html >=0.5 && <0.9, blaze-markup >=0.5 && <0.8
  digestive-functors-blaze = doJailbreak super.digestive-functors-blaze;
  digestive-functors = doJailbreak super.digestive-functors;

  # https://github.com/takano-akio/filelock/issues/5
  filelock = dontCheck super.filelock;

  # Wrap the generated binaries to include their run-time dependencies in
  # $PATH. Also, cryptol needs a version of sbl that's newer than what we have
  # in LTS-13.x.
  cryptol = overrideCabal super.cryptol (drv: {
    buildTools = drv.buildTools or [] ++ [ pkgs.makeWrapper ];
    postInstall = drv.postInstall or "" + ''
      for b in $out/bin/cryptol $out/bin/cryptol-html; do
        wrapProgram $b --prefix 'PATH' ':' "${pkgs.lib.getBin pkgs.z3}/bin"
      done
    '';
  });

  # Tests try to invoke external process and process == 1.4
  grakn = dontCheck (doJailbreak super.grakn);

  # test suite requires git and does a bunch of git operations
  restless-git = dontCheck super.restless-git;

  # Depends on broken fluid.
  fluid-idl-http-client = markBroken super.fluid-idl-http-client;
  fluid-idl-scotty = markBroken super.fluid-idl-scotty;

  # Work around https://github.com/haskell/c2hs/issues/192.
  c2hs = dontCheck super.c2hs;

  # Needs pginit to function and pgrep to verify.
  tmp-postgres = overrideCabal super.tmp-postgres (drv: {
    libraryToolDepends = drv.libraryToolDepends or [] ++ [pkgs.postgresql];
    testToolDepends = drv.testToolDepends or [] ++ [pkgs.procps];
  });

  # Needs QuickCheck <2.10, which we don't have.
  edit-distance = doJailbreak super.edit-distance;
  blaze-html = doJailbreak super.blaze-html;
  int-cast = doJailbreak super.int-cast;

  # Needs QuickCheck <2.10, HUnit <1.6 and base <4.10
  pointfree = doJailbreak super.pointfree;

  # Depends on base <4.12
  # See https://github.com/haskell-hvr/cryptohash-sha512/pull/3
  # , https://github.com/haskell-hvr/cryptohash-sha512/issues/4
  # and https://github.com/haskell-hvr/cryptohash-sha512/pull/5
  cryptohash-sha512 = doJailbreak super.cryptohash-sha512;

  # Depends on tasty < 1.x, which we don't have.
  cryptohash-sha256 = doJailbreak super.cryptohash-sha256;

  # Needs tasty-quickcheck ==0.8.*, which we don't have.
  cryptohash-sha1 = doJailbreak super.cryptohash-sha1;
  cryptohash-md5 = doJailbreak super.cryptohash-md5;
  gitHUD = dontCheck super.gitHUD;
  githud = dontCheck super.githud;

  # https://github.com/aisamanra/config-ini/issues/12
  config-ini = dontCheck super.config-ini;

  # doctest >=0.9 && <0.12
  path = dontCheck super.path;

  # Test suite fails due to trying to create directories
  path-io = dontCheck super.path-io;

  # Duplicate instance with smallcheck.
  store = dontCheck super.store;

  # With ghc-8.2.x haddock would time out for unknown reason
  # See https://github.com/haskell/haddock/issues/679
  language-puppet = dontHaddock super.language-puppet;
  filecache = overrideCabal super.filecache (drv: { doCheck = !pkgs.stdenv.isDarwin; });

  # https://github.com/alphaHeavy/protobuf/issues/34
  protobuf = dontCheck super.protobuf;

  # https://github.com/bos/text-icu/issues/32
  text-icu = dontCheck super.text-icu;

  # aarch64 and armv7l fixes.
  happy = if (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.happy else super.happy; # Similar to https://ghc.haskell.org/trac/ghc/ticket/13062
  hashable = if (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.hashable else super.hashable; # https://github.com/tibbe/hashable/issues/95
  servant-docs =
    let
      f = if (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64)
          then dontCheck
          else pkgs.lib.id;
    in doJailbreak (f super.servant-docs); # jailbreak tasty < 1.2 until servant-docs > 0.11.3 is on hackage.
  snap-templates = doJailbreak super.snap-templates; # https://github.com/snapframework/snap-templates/issues/22
  swagger2 = if (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) then dontHaddock (dontCheck super.swagger2) else super.swagger2;

  # hledger-lib requires the latest version of pretty-simple
  hledger-lib = super.hledger-lib.override { pretty-simple = self.pretty-simple_4_0_0_0; };
  pretty-simple_4_0_0_0 = super.pretty-simple_4_0_0_0.overrideScope (self: super: { prettyprinter = self.prettyprinter_1_7_0; });

  # Copy hledger man pages from data directory into the proper place. This code
  # should be moved into the cabal2nix generator.
  hledger = overrideCabal super.hledger (drv: {
    postInstall = ''
      # Don't install files that don't belong into this package to avoid
      # conflicts when hledger and hledger-ui end up in the same profile.
      rm embeddedfiles/hledger-{api,ui,web}.*
      for i in $(seq 1 9); do
        for j in embeddedfiles/*.$i; do
          mkdir -p $out/share/man/man$i
          cp -v $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp -v embeddedfiles/*.info* $out/share/info/
    '';
  });
  hledger-ui = overrideCabal super.hledger-ui (drv: {
    postInstall = ''
      for i in $(seq 1 9); do
        for j in *.$i; do
          mkdir -p $out/share/man/man$i
          cp -v $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp -v *.info* $out/share/info/
    '';
  });
  hledger-web = overrideCabal super.hledger-web (drv: {
    preCheck = "export HOME=$TMPDIR";
    postInstall = ''
      for i in $(seq 1 9); do
        for j in *.$i; do
          mkdir -p $out/share/man/man$i
          cp -v $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp -v *.info* $out/share/info/
    '';
  });


  # https://github.com/haskell-hvr/resolv/pull/6
  resolv_0_1_1_2 = dontCheck super.resolv_0_1_1_2;

  # spdx 0.2.2.0 needs older tasty
  # was fixed in spdx master (4288df6e4b7840eb94d825dcd446b42fef25ef56)
  spdx = dontCheck super.spdx;

  # The test suite does not know how to find the 'alex' binary.
  alex = overrideCabal super.alex (drv: {
    testSystemDepends = (drv.testSystemDepends or []) ++ [pkgs.which];
    preCheck = ''export PATH="$PWD/dist/build/alex:$PATH"'';
  });

  # This package refers to the wrong library (itself in fact!)
  vulkan = super.vulkan.override { vulkan = pkgs.vulkan-loader; };

  # Compiles some C or C++ source which requires these headers
  VulkanMemoryAllocator = addExtraLibrary super.VulkanMemoryAllocator pkgs.vulkan-headers;
  vulkan-utils = addExtraLibrary super.vulkan-utils pkgs.vulkan-headers;

  # https://github.com/dmwit/encoding/pull/3
  encoding = doJailbreak (appendPatch super.encoding ./patches/encoding-Cabal-2.0.patch);

  # Work around overspecified constraint on github ==0.18.
  github-backup = doJailbreak super.github-backup;

  # Test suite depends on cabal-install
  doctest = dontCheck super.doctest;

  # dontCheck: https://github.com/haskell-servant/servant-auth/issues/113
  # doJailbreak: waiting on revision 1 to hit hackage
  servant-auth-client = doJailbreak (dontCheck super.servant-auth-client);

  # Generate cli completions for dhall.
  dhall = generateOptparseApplicativeCompletion "dhall" super.dhall;
  dhall-json = generateOptparseApplicativeCompletions ["dhall-to-json" "dhall-to-yaml"] super.dhall-json;
  dhall-nix = generateOptparseApplicativeCompletion "dhall-to-nix" super.dhall-nix;

  # https://github.com/haskell-hvr/netrc/pull/2#issuecomment-469526558
  netrc = doJailbreak super.netrc;

  # https://github.com/haskell-hvr/hgettext/issues/14
  hgettext = doJailbreak super.hgettext;

  # Generate shell completion.
  cabal2nix = generateOptparseApplicativeCompletion "cabal2nix" super.cabal2nix;
  niv = generateOptparseApplicativeCompletion "niv" super.niv;
  ormolu = generateOptparseApplicativeCompletion "ormolu" super.ormolu;
  stack = generateOptparseApplicativeCompletion "stack" super.stack;

  # musl fixes
  # dontCheck: use of non-standard strptime "%s" which musl doesn't support; only used in test
  unix-time = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.unix-time else super.unix-time;
  # dontCheck: printf double rounding behavior
  prettyprinter = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.prettyprinter else super.prettyprinter;

  # Fix with Cabal 2.2, https://github.com/guillaume-nargeot/hpc-coveralls/pull/73
  hpc-coveralls = appendPatch super.hpc-coveralls (pkgs.fetchpatch {
    url = "https://github.com/guillaume-nargeot/hpc-coveralls/pull/73/commits/344217f513b7adfb9037f73026f5d928be98d07f.patch";
    sha256 = "056rk58v9h114mjx62f41x971xn9p3nhsazcf9zrcyxh1ymrdm8j";
  });

  # sexpr is old, broken and has no issue-tracker. Let's fix it the best we can.
  sexpr =
    appendPatch (overrideCabal super.sexpr (drv: {
      isExecutable = false;
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [self.QuickCheck];
    })) ./patches/sexpr-0.2.1.patch;

  # https://github.com/haskell/hoopl/issues/50
  hoopl = dontCheck super.hoopl;

  purescript =
    let
      purescriptWithOverrides = super.purescript.override {
        # PureScript requires an older version of happy.
        happy = self.happy_1_19_9;
      };

      # PureScript is built against LTS-13, so we need to jailbreak it to
      # accept more recent versions of the libraries it requires.
      jailBrokenPurescript = doJailbreak purescriptWithOverrides;

      # Haddocks for PureScript can't be built.
      # https://github.com/purescript/purescript/pull/3745
      dontHaddockPurescript = dontHaddock jailBrokenPurescript;
    in
    # Generate shell completions
    generateOptparseApplicativeCompletion "purs" dontHaddockPurescript;

  # Generate shell completion for spago
  spago = generateOptparseApplicativeCompletion "spago" super.spago;

  # 2020-06-05: HACK: Package can not pass test suite,
  # Upstream Report: https://github.com/kcsongor/generic-lens/issues/83
  generic-lens = dontCheck super.generic-lens;

  # https://github.com/danfran/cabal-macosx/issues/13
  cabal-macosx = dontCheck super.cabal-macosx;

  # https://github.com/DanielG/cabal-helper/pull/123
  cabal-helper = doJailbreak super.cabal-helper;

  # TODO(Profpatsch): factor out local nix store setup from
  # lib/tests/release.nix and use that for the tests of libnix
  # libnix = overrideCabal super.libnix (old: {
  #   testToolDepends = old.testToolDepends or [] ++ [ pkgs.nix ];
  # });
  libnix = dontCheck super.libnix;

  # dontCheck: The test suite tries to mess with ALSA, which doesn't work in the build sandbox.
  xmobar = dontCheck super.xmobar;

  # https://github.com/mgajda/json-autotype/issues/25
  json-autotype = dontCheck super.json-autotype;

  # Requires pg_ctl command during tests
  beam-postgres = overrideCabal super.beam-postgres (drv: {
    testToolDepends = (drv.testToolDepends or []) ++ [pkgs.postgresql];
    });

  # Fix for base >= 4.11
  scat = overrideCabal super.scat (drv: {
    patches = [(pkgs.fetchpatch {
      url    = "https://github.com/redelmann/scat/pull/6.diff";
      sha256 = "07nj2p0kg05livhgp1hkkdph0j0a6lb216f8x348qjasy0lzbfhl";
    })];
  });

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch super.xattr ./patches/xattr-fix-build.patch;

  # Some tests depend on a postgresql instance
  esqueleto = dontCheck super.esqueleto;

  # Requires API keys to run tests
  algolia = dontCheck super.algolia;

  # antiope-s3's latest stackage version has a hspec < 2.6 requirement, but
  # hspec which isn't in stackage is already past that
  antiope-s3 = doJailbreak super.antiope-s3;

  # Has tasty < 1.2 requirement, but works just fine with 1.2
  temporary-resourcet = doJailbreak super.temporary-resourcet;

  # Requires dhall >= 1.23.0
  ats-pkg = dontCheck (super.ats-pkg.override { dhall = self.dhall_1_29_0; });

  # fake a home dir and capture generated man page
  ats-format = overrideCabal super.ats-format (old : {
    preConfigure = "export HOME=$PWD";
    postBuild = "mv .local/share $out";
  });

  # Test suite doesn't work with current QuickCheck
  # https://github.com/pruvisto/heap/issues/11
  heap = dontCheck super.heap;

  # Test suite won't link for no apparent reason.
  constraints-deriving = dontCheck super.constraints-deriving;

  # https://github.com/elliottt/hsopenid/issues/15
  openid = markBroken super.openid;

  # The test suite needs the packages's executables in $PATH to succeed.
  arbtt = overrideCabal super.arbtt (drv: {
    preCheck = ''
      for i in $PWD/dist/build/*; do
        export PATH="$i:$PATH"
      done
    '';
  });

  # https://github.com/erikd/hjsmin/issues/32
  hjsmin = dontCheck super.hjsmin;

  nix-tools = super.nix-tools.overrideScope (self: super: {
    # Needs https://github.com/peti/hackage-db/pull/9
    hackage-db = super.hackage-db.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "ElvishJerricco";
        repo = "hackage-db";
        rev = "84ca9fc75ad45a71880e938e0d93ea4bde05f5bd";
        sha256 = "0y3kw1hrxhsqmyx59sxba8npj4ya8dpgjljc21gkgdvdy9628q4c";
      };
    });
  });

  # upstream issue: https://github.com/vmchale/atspkg/issues/12
  language-ats = dontCheck super.language-ats;

  # Remove for hail > 0.2.0.0
  hail = overrideCabal super.hail (drv: {
    patches = [
      (pkgs.fetchpatch {
        # Relax dependency constraints,
        # upstream PR: https://github.com/james-preston/hail/pull/13
        url = "https://patch-diff.githubusercontent.com/raw/james-preston/hail/pull/13.patch";
        sha256 = "039p5mqgicbhld2z44cbvsmam3pz0py3ybaifwrjsn1y69ldsmkx";
      })
      (pkgs.fetchpatch {
        # Relax dependency constraints,
        # upstream PR: https://github.com/james-preston/hail/pull/16
        url = "https://patch-diff.githubusercontent.com/raw/james-preston/hail/pull/16.patch";
        sha256 = "0dpagpn654zjrlklihsg911lmxjj8msylbm3c68xa5aad1s9gcf7";
      })
    ];
  });

  # https://github.com/kazu-yamamoto/dns/issues/150
  dns = dontCheck super.dns;

  # https://github.com/haskell-servant/servant-blaze/issues/17
  servant-blaze = doJailbreak super.servant-blaze;

  # https://github.com/haskell-servant/servant-ekg/issues/15
  servant-ekg = doJailbreak super.servant-ekg;

  # the test suite has an overly tight restriction on doctest
  # See https://github.com/ekmett/perhaps/pull/5
  perhaps = doJailbreak super.perhaps;

  # it wants to build a statically linked binary by default
  hledger-flow = overrideCabal super.hledger-flow ( drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace hledger-flow.cabal --replace "-static" ""
    '';
  });

  # gtk/gtk3 needs to be told on Darwin to use the Quartz
  # rather than X11 backend (see eg https://github.com/gtk2hs/gtk2hs/issues/249).
  gtk3 = appendConfigureFlags super.gtk3 (pkgs.lib.optional pkgs.stdenv.isDarwin "-f have-quartz-gtk");
  gtk = appendConfigureFlags super.gtk (pkgs.lib.optional pkgs.stdenv.isDarwin "-f have-quartz-gtk");

  # Chart-tests needs and compiles some modules from Chart itself
  Chart-tests = (addExtraLibrary super.Chart-tests self.QuickCheck).overrideAttrs (old: {
    preCheck = old.postPatch or "" + ''
      tar --one-top-level=../chart --strip-components=1 -xf ${self.Chart.src}
    '';
  });

  # This breaks because of version bounds, but compiles and runs fine.
  # Last commit is 5 years ago, so we likely won't get upstream fixed soon.
  # https://bitbucket.org/rvlm/hakyll-contrib-hyphenation/src/master/
  # Therefore we jailbreak it.
  hakyll-contrib-hyphenation = doJailbreak super.hakyll-contrib-hyphenation;

  # 2020-06-22: NOTE: > 0.4.0 => rm Jailbreak: https://github.com/serokell/nixfmt/issues/71
  nixfmt = doJailbreak super.nixfmt;

  # The test suite depends on an impure cabal-install installation in
  # $HOME, which we don't have in our build sandbox.
  cabal-install-parsers = dontCheck super.cabal-install-parsers;

  # version constraints break the build, so we jailbreak
  # can be removed at a new release which also fixes
  # https://github.com/jgm/gitit/issues/665
  gitit = doJailbreak super.gitit;

  # Test suite requires database
  persistent-mysql = dontCheck super.persistent-mysql;
  persistent-postgresql = dontCheck super.persistent-postgresql;

  # Fix EdisonAPI and EdisonCore for GHC 8.8:
  # https://github.com/robdockins/edison/pull/16
  EdisonAPI = appendPatch super.EdisonAPI (pkgs.fetchpatch {
    url = "https://github.com/robdockins/edison/pull/16/commits/8da6c0f7d8666766e2f0693425c347c0adb492dc.patch";
    postFetch = ''
      ${pkgs.patchutils}/bin/filterdiff --include='a/edison-api/*' --strip=1 "$out" > "$tmpfile"
      mv "$tmpfile" "$out"
    '';
    sha256 = "0yi5pz039lcm4pl9xnl6krqxyqq5rgb5b6m09w0sfy06x0n4x213";
  });

  EdisonCore = appendPatch super.EdisonCore (pkgs.fetchpatch {
    url = "https://github.com/robdockins/edison/pull/16/commits/8da6c0f7d8666766e2f0693425c347c0adb492dc.patch";
    postFetch = ''
      ${pkgs.patchutils}/bin/filterdiff --include='a/edison-core/*' --strip=1 "$out" > "$tmpfile"
      mv "$tmpfile" "$out"
    '';
    sha256 = "097wqn8hxsr50b9mhndg5pjim5jma2ym4ylpibakmmb5m98n17zp";
  });

  # polysemy-plugin 0.2.5.0 has constraint ghc-tcplugins-extra (==0.3.*)
  # This upstream issue is relevant:
  # https://github.com/polysemy-research/polysemy/issues/322
  polysemy-plugin = super.polysemy-plugin.override {
    ghc-tcplugins-extra = self.ghc-tcplugins-extra_0_3_2;
  };

  # Test suite requires running a database server. Testing is done upstream.
  hasql-notifications = dontCheck super.hasql-notifications;
  hasql-pool = dontCheck super.hasql-pool;

  # This bumps optparse-applicative to <0.16 in the cabal file, as otherwise
  # the version bounds are not satisfied.  This can be removed if the PR at
  # https://github.com/ananthakumaran/webify/pull/27 is merged and a new
  # release of webify is published.
  webify = appendPatch super.webify (pkgs.fetchpatch {
    url = "https://github.com/ananthakumaran/webify/pull/27/commits/6d653e7bdc1ffda75ead46851b5db45e87cb2aa0.patch";
    sha256 = "0xbfhzhzg94b4r5qy5dg1c40liswwpqarrc2chcwgfbfnrmwkfc2";
  });

  # hasn‘t bumped upper bounds
  # upstream: https://github.com/obsidiansystems/which/pull/6
  which = doJailbreak super.which;

  # the test suite attempts to run the binaries built in this package
  # through $PATH but they aren't in $PATH
  dhall-lsp-server = dontCheck super.dhall-lsp-server;

  # https://github.com/ocharles/weeder/issues/15
  weeder = doJailbreak super.weeder;

  # Requested version bump on upstream https://github.com/obsidiansystems/constraints-extras/issues/32
  constraints-extras = doJailbreak super.constraints-extras;

  # Necessary for stack
  # x509-validation test suite hangs: upstream https://github.com/vincenthz/hs-certificate/issues/120
  # tls test suite fails: upstream https://github.com/vincenthz/hs-tls/issues/434
  x509-validation = dontCheck super.x509-validation;
  tls = dontCheck super.tls;

  # Allow building with recent versions of hlint.
  patch = doJailbreak super.patch;

  # Tests disabled and broken override needed because of missing lib chrome-test-utils: https://github.com/reflex-frp/reflex-dom/issues/392
  reflex-dom-core = doDistribute (unmarkBroken (dontCheck (appendPatch super.reflex-dom-core (pkgs.fetchpatch {
    url = https://github.com/reflex-frp/reflex-dom/commit/6aed7b7ebb70372778f1a29a724fcb4de815ba04.patch;
    sha256 = "1g7lgwj7rpziilif2gian412iy05gqbzwx9w0m6ajq3clxs5zs7l";
    stripLen = 2;
    extraPrefix = "";
    includes = ["reflex-dom-core.cabal" ];
  }))));

  # Tests disabled and broken override needed because of missing lib chrome-test-utils: https://github.com/reflex-frp/reflex-dom/issues/392
  reflex-dom = appendPatch super.reflex-dom (pkgs.fetchpatch {
    url = https://github.com/reflex-frp/reflex-dom/commit/6aed7b7ebb70372778f1a29a724fcb4de815ba04.patch;
    sha256 = "1ndqw5r85axynmx55ld6qr8ik1i1mkh6wrnkzpxbwyil2ms8mxn0";
    stripLen = 2;
    extraPrefix = "";
    includes = ["reflex-dom.cabal" ];
  });

  # add unreleased commit fixing version constraint as a patch
  # Can be removed if https://github.com/lpeterse/haskell-utc/issues/8 is resolved
  utc = appendPatch super.utc (pkgs.fetchpatch {
    url = "https://github.com/lpeterse/haskell-utc/commit/e4502c08591e80d411129bb7c0414539f6302aaf.diff";
    sha256 = "0v6kv1d4syjzgzc2s7a76c6k4vminlcq62n7jg3nn9xd00gwmmv7";
  });

  # Tests disabled because they assume to run in the whole jsaddle repo and not the hackage tarbal of jsaddle-warp.
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
  monad-dijkstra = dontCheck (doJailbreak super.monad-dijkstra);

  # Fixed upstream but not released to Hackage yet:
  # https://github.com/k0001/hs-libsodium/issues/2
  libsodium = overrideCabal super.libsodium (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [self.c2hs];
  });

  # https://github.com/kowainik/policeman/issues/57
  policeman = doJailbreak super.policeman;

  haskell-gi-base = addBuildDepends super.haskell-gi-base [ pkgs.gobject-introspection ];

  # 2020-08-14: Needs some manual patching to be compatible with haskell-gi-base 0.24
  # Created upstream PR @ https://github.com/ghcjs/jsaddle/pull/119
  jsaddle-webkit2gtk = appendPatch super.jsaddle-webkit2gtk (pkgs.fetchpatch {
    url = "https://github.com/ghcjs/jsaddle/compare/9727365...f842748.patch";
    sha256 = "07l4l999lmlx7sqxf7v4f70rmxhx9r0cjblkgc4n0y6jin4iv1cb";
    stripLen = 2;
    extraPrefix = "";
  });

  # Missing -Iinclude parameter to doc-tests (pull has been accepted, so should be resolved when 0.5.3 released)
  # https://github.com/lehins/massiv/pull/104
  massiv = dontCheck super.massiv;

  # Upstream PR: https://github.com/jkff/splot/pull/9
  splot = appendPatch super.splot (pkgs.fetchpatch {
    url = "https://github.com/jkff/splot/commit/a6710b05470d25cb5373481cf1cfc1febd686407.patch";
    sha256 = "1c5ck2ibag2gcyag6rjivmlwdlp5k0dmr8nhk7wlkzq2vh7zgw63";
  });

  # Tests are broken because of missing files in hackage tarball.
  # https://github.com/jgm/commonmark-hs/issues/55
  commonmark-extensions = dontCheck super.commonmark-extensions;

  # Testsuite trying to run `which haskeline-examples-Test`
  haskeline_0_8_1_0 = dontCheck super.haskeline_0_8_1_0;

  # Tests for list-t, superbuffer, and stm-containers
  # depend on HTF and it is broken, 2020-08-23
  list-t = dontCheck super.list-t;
  superbuffer = dontCheck super.superbuffer;
  stm-containers = dontCheck super.stm-containers;

  # Fails with "supports custom headers"
  Spock-core = dontCheck super.Spock-core;

  # Needed by Hasura  1.3.1
  dependent-map_0_2_4_0 = super.dependent-map_0_2_4_0.override {
    dependent-sum = self.dependent-sum_0_4;
  };

  # Hasura 1.3.1
  # Because of ghc-heap-view, profiling needs to be disabled.
  graphql-engine = disableLibraryProfiling( overrideCabal (super.graphql-engine.override {
     immortal = self.immortal_0_2_2_1;
     dependent-map = self.dependent-map_0_2_4_0;
     dependent-sum = self.dependent-sum_0_4;
  }) (drv: {
     # version in cabal file is invalid
     version = "1.3.1-beta1";
     # hasura needs VERSION env exported during build
     preBuild = "export VERSION=1.3.1-beta1";
  }));

  # https://github.com/bos/statistics/issues/170
  statistics = dontCheck super.statistics;

  hcoord = overrideCabal super.hcoord (drv: {
    # Remove when https://github.com/danfran/hcoord/pull/8 is merged.
    patches = [
      (pkgs.fetchpatch {
        url = "https://github.com/danfran/hcoord/pull/8/commits/762738b9e4284139f5c21f553667a9975bad688e.patch";
        sha256 = "03r4jg9a6xh7w3jz3g4bs7ff35wa4rrmjgcggq51y0jc1sjqvhyz";
      })
    ];
    # Remove when https://github.com/danfran/hcoord/issues/9 is closed.
    doCheck = false;
  });

  # Tests rely on `Int` being 64-bit: https://github.com/hspec/hspec/issues/431.
  # Also, we need QuickCheck-2.14.x to build the test suite, which isn't easy in LTS-16.x.
  # So let's not go there and just disable the tests altogether.
  hspec-core = dontCheck super.hspec-core;

  # github.com/ucsd-progsys/liquidhaskell/issues/1729
  liquidhaskell = super.liquidhaskell.override { Diff = self.Diff_0_3_4; };
  Diff_0_3_4 = dontCheck super.Diff_0_3_4;

  # jailbreaking pandoc-citeproc because it has not bumped upper bound on pandoc
  pandoc-citeproc = doJailbreak super.pandoc-citeproc;

  # The test suite attempts to read `/etc/resolv.conf`, which doesn't work in the sandbox.
  domain-auth = dontCheck super.domain-auth;

  # Too tight version bounds, see https://github.com/haskell-hvr/microaeson/pull/4
  microaeson = doJailbreak super.microaeson;

  # - Deps are required during the build for testing and also during execution,
  #   so add them to build input and also wrap the resulting binary so they're in
  #   PATH.
  update-nix-fetchgit = let deps = [ pkgs.git pkgs.nix pkgs.nix-prefetch-git ];
  in generateOptparseApplicativeCompletion "update-nix-fetchgit" (overrideCabal
    (addTestToolDepends (super.update-nix-fetchgit.overrideScope (self: super: {
      optparse-generic = self.optparse-generic_1_4_4;
      optparse-applicative = self.optparse-applicative_0_16_1_0;
    })) deps) (drv: {
      buildTools = drv.buildTools or [ ] ++ [ pkgs.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/update-nix-fetchgit" --prefix 'PATH' ':' "${
          pkgs.lib.makeBinPath deps
        }"
      '';
    }));

  # Our quickcheck-instances is too old for the newer binary-instances, but
  # quickcheck-instances is only used in the tests of binary-instances.
  binary-instances = dontCheck super.binary-instances;

  # tons of overrides for bleeding edge versions for ghcide and hls
  # overriding aeson on all of them to prevent double compilations
  # this shouldn‘t break anything because nearly all their reverse deps are
  # in this list or marked as broken anyways
  # 2020-11-19: Checks nearly fixed, but still disabled because of flaky tests:
  # https://github.com/haskell/haskell-language-server/issues/610
  # https://github.com/haskell/haskell-language-server/issues/611
  haskell-language-server = dontCheck (super.haskell-language-server.override {
    lsp-test = dontCheck self.lsp-test_0_11_0_7;
    fourmolu = self.fourmolu_0_3_0_0;
  });

  fourmolu = dontCheck super.fourmolu;
  # 1. test requires internet
  # 2. dependency shake-bench hasn't been published yet so we also need unmarkBroken and doDistribute
  ghcide = doDistribute (unmarkBroken (dontCheck
    (super.ghcide.override { lsp-test = dontCheck self.lsp-test_0_11_0_7; })
  ));
  refinery = doDistribute super.refinery_0_3_0_0;
  data-tree-print = doJailbreak super.data-tree-print;

  # 2020-11-15: aeson 1.5.4.1 needs to new quickcheck-instances for testing
  aeson = dontCheck super.aeson;

  # 2020-11-15: nettle tests are pre MonadFail change
  # https://github.com/stbuehler/haskell-nettle/issues/10
  nettle = dontCheck super.nettle;

  # 2020-11-17: Disable tests for hackage-security because of this issue:
  # https://github.com/haskell/hackage-security/issues/247
  hackage-security = dontCheck super.hackage-security;

  # 2020-11-17: persistent-test is ahead of the persistent version in stack
  persistent-sqlite = dontCheck super.persistent-sqlite;

  # The tests for semver-range need to be updated for the MonadFail change in
  # ghc-8.8:
  # https://github.com/adnelson/semver-range/issues/15
  semver-range = dontCheck super.semver-range;

  dependent-sum-aeson-orphans = appendPatch super.dependent-sum-aeson-orphans (pkgs.fetchpatch {
    # 2020-11-18: https://github.com/obsidiansystems/dependent-sum-aeson-orphans/pull/9
    # Bump version bounds for ghc 8.10
    url = https://github.com/obsidiansystems/dependent-sum-aeson-orphans/commit/e1f5898116222a1bc557d41f3395066f83736093.patch;
    sha256 = "01fj29xdblxpz4drasaygf9875fipylpj8w164lb0cszd1vmqwnb";
  });

  # 2020-11-18: https://github.com/srid/rib/issues/169
  # aeson bound out of sync
  rib-core = doJailbreak super.rib-core;

  # 2020-11-18: https://github.com/srid/neuron/issues/474
  # base upper bound is incompatible with ghc 8.10
  neuron = doJailbreak super.neuron;

  reflex = appendPatches super.reflex [
    # https://github.com/reflex-frp/reflex/pull/444
    # Fixes for ghc 8.10
    (pkgs.fetchpatch {
      url = https://github.com/reflex-frp/reflex/commit/d230632427fc1b7031163567c97f20050610c122.patch;
      sha256 = "0gafqqi6q16m5y4mrc2f7lhahmazvcbiadn2v84y9p3zvx2v26xy";
    })
    # https://github.com/reflex-frp/reflex/pull/444
    # Bound bumps for ghc 8.10
    (pkgs.fetchpatch {
      url = https://patch-diff.githubusercontent.com/raw/reflex-frp/reflex/pull/448.patch;
      sha256 = "0a8gcq9g8dyyafkvs54mi3fnisff20r0x0qzmhxcp9md61nkf7gq";
    })
  ];

  # 2020-11-19: jailbreaking because of pretty-simple bound out of date
  # https://github.com/kowainik/stan/issues/408
  # Tests disabled because of: https://github.com/kowainik/stan/issues/409
  stan = doJailbreak (dontCheck super.stan);

  # Due to tests restricting base in 0.8.0.0 release
  http-media = doJailbreak super.http-media;

  # Use an already merged upstream patch fixing the build with primitive >= 0.7.2
  # The version bounds were correctly specified before, so we need to jailbreak as well
  streamly = appendPatch (doJailbreak super.streamly) (pkgs.fetchpatch {
    url = "https://github.com/composewell/streamly/commit/2c88cb631fdcb5c0d3a8bc936e1e63835800be9b.patch";
    sha256 = "0g2m0y46zr3xs9fswkm4h9adhsg6gzl5zwgidshsjh3k3rq4h7b1";
  });

  # 2020-11-19: Jailbreaking until: https://github.com/snapframework/heist/pull/124
  heist = doJailbreak super.heist;

  # 2020-11-19: Jailbreaking until: https://github.com/snapframework/snap/pull/219
  snap = doJailbreak super.snap;

  # 2020-11-21: cachix + chachix-api needs a patch for ghc 8.10 compat. Can be removed once released
  # https://github.com/cachix/cachix/pull/331
  cachix-api = appendPatch super.cachix-api (pkgs.fetchpatch {
    url = https://github.com/cachix/cachix/commit/bfeec151a03afad72401815fe8bbb1b0d5d63b0d.patch;
    sha256 = "0rglyd77g4j72l5g0sj9zpq2hy3v992bm6nhj58pmj4j2aj67y74";
    stripLen = 2;
    extraPrefix = "";
    includes = [ "src/Cachix/Types/Session.hs" "src/Cachix/API/Signing.hs" ];
  });
  cachix = generateOptparseApplicativeCompletion "cachix" (appendPatch super.cachix (pkgs.fetchpatch {
    url = https://github.com/cachix/cachix/commit/bfeec151a03afad72401815fe8bbb1b0d5d63b0d.patch;
    sha256 = "06jmpz8l5vh9cch5aqdbrln7bm3fghxsicwy1m93avli320kp8pp";
    stripLen = 2;
    extraPrefix = "";
    excludes = [ "stack.yaml" "sources.json" "src/Cachix/Types/Session.hs" "src/Cachix/API/Signing.hs" "cachix-api.cabal" "workflows/test.yml" ];
  }));

  # 2020-11-23: Jailbreaking until: https://github.com/michaelt/text-pipes/pull/29
  pipes-text = doJailbreak super.pipes-text;

  # 2020-11-23: https://github.com/Rufflewind/blas-hs/issues/8
  blas-hs = dontCheck super.blas-hs;

  # 2020-11-23: https://github.com/cdornan/fmt/issues/30
  fmt = dontCheck super.fmt;

  # 2020-11-27: Tests broken
  # Upstream issue: https://github.com/haskell-servant/servant-swagger/issues/129
  servant-swagger = dontCheck super.servant-swagger;

  # 2020-11-27: cxx-options is broken in Cabal 3.2.0.0
  hercules-ci-agent = addSetupDepend super.hercules-ci-agent self.Cabal_3_2_1_0;

  # 2020-12-05: http-client is fixed on too old version
  essence-of-live-coding-warp = super.essence-of-live-coding-warp.override {
    http-client = self.http-client_0_7_3;
  };

  # 2020-12-06: Restrictive upper bounds w.r.t. pandoc-types (https://github.com/owickstrom/pandoc-include-code/issues/27)
  pandoc-include-code = doJailbreak super.pandoc-include-code;

  # https://github.com/jgm/pandoc/issues/6961
  pandoc = dontCheck super.pandoc;

  # Update pandoc dependencies to fix the build.
  doctemplates = self.doctemplates_0_9;
  skylighting = self.skylighting_0_10_2;
  skylighting-core = self.skylighting-core_0_10_2;

  # https://github.com/yesodweb/yesod/issues/1714
  yesod-core = dontCheck super.yesod-core;

  # Add ApplicationServices on darwin
  # use 0.4.5 instead of 0.4.4 to fix build with glibc >= 2.32
  apecs-physics = addPkgconfigDepends super.apecs-physics_0_4_5
    (pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.darwin.apple_sdk.frameworks.ApplicationServices);

} // import ./configuration-tensorflow.nix {inherit pkgs haskellLib;} self super
