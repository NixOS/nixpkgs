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

  # Some Hackage packages reference this attribute, which exists only in the
  # GHCJS package set. We provide a dummy version here to fix potential
  # evaluation errors.
  ghcjs-base = null;
  ghcjs-prim = null;

  # Some packages add this (non-existent) dependency to express that they
  # cannot compile in a given configuration. Win32 does this, for example, when
  # compiled on Linux. We provide the name to avoid evaluation errors.
  unbuildable = throw "package depends on meta package 'unbuildable'";

  # The test suite depends on old versions of tasty and QuickCheck.
  hackage-security = dontCheck super.hackage-security;

  # enable using a local hoogle with extra packagages in the database
  # nix-shell -p "haskellPackages.hoogleLocal { packages = with haskellPackages; [ mtl lens ]; }"
  # $ hoogle server
  hoogleLocal = { packages ? [] }: self.callPackage ./hoogle.nix { inherit packages; };

  # Needs older QuickCheck version
  attoparsec-varword = dontCheck super.attoparsec-varword;

  # https://github.com/koalaman/shellcheck/issues/1778
  ShellCheck = overrideCabal super.ShellCheck (drv: {
    patches = [
      # cabal 3.0 support
      ( pkgs.fetchpatch {
        url = "https://github.com/koalaman/shellcheck/commit/2c026f1ec7c205c731ff2a0ccd85365f37245.patch";
        sha256 = "0z6yf350ngr6rwfkvdy670c476fgzj8a0n4ppdm1xr8r1lij7sfz";
        excludes = [ "Dockerfile" ];
      })
    ];
  });

  # Tests are failing
  # https://github.com/bos/statistics/issues/123
  statistics = dontCheck super.statistics;

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;
  mysql-haskell = dontCheck super.mysql-haskell;

  # Tests failing, fixed once 0.8.0 is in stackage
  # https://gitlab.com/twittner/zeromq-haskell/issues/63
  zeromq4-haskell = dontCheck super.zeromq4-haskell;

  # The Hackage tarball is purposefully broken, because it's not intended to be, like, useful.
  # https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  git-annex = (overrideSrc super.git-annex {
    src = pkgs.fetchgit {
      name = "git-annex-${super.git-annex.version}-src";
      url = "git://git-annex.branchable.com/";
      rev = "refs/tags/" + super.git-annex.version;
      sha256 = "0y2qcjahi705c6nnypqpa5w3bzyzk4kqvbwfnpiaxzk5vna589gg";
    };
  }).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

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

  # Switch levmar build to openblas.
  bindings-levmar = overrideCabal super.bindings-levmar (drv: {
    preConfigure = ''
      sed -i bindings-levmar.cabal \
          -e 's,extra-libraries: lapack blas,extra-libraries: openblas,'
    '';
    extraLibraries = [ pkgs.openblasCompat ];
  });

  # The Haddock phase fails for one reason or another.
  bytestring-progress = dontHaddock super.bytestring-progress;
  deepseq-magic = dontHaddock super.deepseq-magic;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;
  classy-prelude-yesod = dontHaddock super.classy-prelude-yesod; # https://github.com/haskell/haddock/issues/979

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # sse2 flag due to https://github.com/haskell/vector/issues/47.
  # dontCheck due to https://github.com/haskell/vector/issues/138
  vector = dontCheck (if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector);

  conduit-extra = if pkgs.stdenv.isDarwin
    then super.conduit-extra.overrideAttrs (drv: { __darwinAllowLocalNetworking = true; })
    else super.conduit-extra;

  # Fix Darwin build.
  halive = if pkgs.stdenv.isDarwin
    then addBuildDepend super.halive pkgs.darwin.apple_sdk.frameworks.AppKit
    else super.halive;

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

  # Test suite build depends on ancient tasty 0.11.x.
  cryptohash-sha512 = dontCheck super.cryptohash-sha512;

  # https://github.com/kazu-yamamoto/simple-sendfile/issues/17
  simple-sendfile = dontCheck super.simple-sendfile;

  # Fails no apparent reason. Upstream has been notified by e-mail.
  assertions = dontCheck super.assertions;

  # These packages try to execute non-existent external programs.
  cmaes = dontCheck super.cmaes;                        # http://hydra.cryp.to/build/498725/log/raw
  dbmigrations = dontCheck super.dbmigrations;
  euler = dontCheck super.euler;                        # https://github.com/decomputed/euler/issues/1
  filestore = dontCheck super.filestore;
  getopt-generics = dontCheck super.getopt-generics;
  graceful = dontCheck super.graceful;
  Hclip = dontCheck super.Hclip;
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

  # Needs older version of QuickCheck.
  these_0_7_6 = doJailbreak super.these_0_7_6;

  # dontCheck: Can be removed once https://github.com/haskell-nix/hnix/commit/471712f is in (5.2 probably)
  #   This is due to GenList having been removed from generic-random in 1.2.0.0
  # doJailbreak: Can be removed once https://github.com/haskell-nix/hnix/pull/329 is in (5.2 probably)
  #   This is due to hnix currently having an upper bound of <0.5 on deriving-compat, works just fine with our current version 0.5.1 though
  # Does not support recent versions of "these".
  # https://github.com/haskell-nix/hnix/issues/514
  hnix =
    generateOptparseApplicativeCompletion "hnix" (
      dontCheck (doJailbreak (super.hnix.override { these = self.these_0_7_6; }))
    );

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
  aws = dontCheck super.aws;                            # needs aws credentials
  aws-kinesis = dontCheck super.aws-kinesis;            # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol;    # http://hydra.cryp.to/build/499749/log/raw
  binary-search = dontCheck super.binary-search;
  bits = dontCheck super.bits;                          # http://hydra.cryp.to/build/500239/log/raw
  bloodhound = dontCheck super.bloodhound;
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection;    # http://hydra.cryp.to/build/496948/log/raw
  cabal-bounds = dontCheck super.cabal-bounds;          # http://hydra.cryp.to/build/496935/nixlog/1/raw
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
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-nix = if (pkgs.stdenv.hostPlatform.isAarch64 || pkgs.stdenv.hostPlatform.isi686) then dontCheck super.language-nix else super.language-nix; # aarch64: https://ghc.haskell.org/trac/ghc/ticket/15275
  language-slice = dontCheck super.language-slice;
  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lucid = dontCheck super.lucid; #https://github.com/chrisdone/lucid/issues/25
  lvmrun = disableHardening (dontCheck super.lvmrun) ["format"];
  matplotlib = dontCheck super.matplotlib;
  memcache = dontCheck super.memcache;
  metrics = dontCheck super.metrics;
  milena = dontCheck super.milena;
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
  pandoc-crossref = dontCheck super.pandoc-crossref;  # (most likely change when no longer 0.3.2.1) https://github.com/lierdakil/pandoc-crossref/issues/199
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
  redis-io = dontCheck super.redis-io;
  reflex = dontCheck super.reflex; # test suite uses hlint, which has different haskell-src-exts version
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
  tar = dontCheck super.tar; #http://hydra.nixos.org/build/25088435/nixlog/2 (fails only on 32-bit)
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

  # These test suites run for ages, even on a fast machine. This is nuts.
  Random123 = dontCheck super.Random123;
  systemd = dontCheck super.systemd;

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  snappy = dontCheck super.snappy;

  # https://github.com/kim/snappy-framing/issues/3
  snappy-framing = dontHaddock super.snappy-framing;

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  vty = dontCheck super.vty;

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/cgaebel/stm-conduit/issues/33
  stm-conduit = dontCheck super.stm-conduit;

  # https://github.com/pixbi/duplo/issues/25
  duplo = dontCheck super.duplo;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary super.mikmod pkgs.libmikmod;

  # https://github.com/basvandijk/threads/issues/10
  threads = dontCheck super.threads;

  # Missing module.
  rematch = dontCheck super.rematch;            # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text;  # https://github.com/tcrayford/rematch/issues/6

  # Should not appear in nixpkgs yet (broken anyway)
  yarn2nix = throw "yarn2nix is not yet packaged for nixpkgs. See https://github.com/Profpatsch/yarn2nix#yarn2nix";

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal super.paypal-adaptive-hoops (drv: { testTarget = "local"; });

  # https://github.com/vincenthz/hs-asn1/issues/12
  asn1-encoding = dontCheck super.asn1-encoding;

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

  # https://github.com/PaulJohnson/geodetics/issues/1
  geodetics = dontCheck super.geodetics;

  # https://github.com/junjihashimoto/test-sandbox-compose/issues/2
  test-sandbox-compose = dontCheck super.test-sandbox-compose;

  # https://github.com/tych0/xcffib/issues/37
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

  # generic-deriving bound is too tight
  # aeson 1.4.6.0 needs Diff 0.4.0 to do tests but nixpkgs is still at 0.3.4
  # https://github.com/bos/aeson/issues/740
  aeson = dontCheck (doJailbreak super.aeson);

  # containers >=0.4 && <0.6 is too tight
  # https://github.com/RaphaelJ/friday/issues/34
  friday = doJailbreak super.friday;

  # Won't compile with recent versions of QuickCheck.
  inilist = dontCheck super.inilist;

  # Doesn't accept recent versions of 'base' or QuickCheck.
  MissingH = dontCheck (doJailbreak super.MissingH);

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # https://github.com/hvr/token-bucket/issues/3
  token-bucket = dontCheck super.token-bucket;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # https://github.com/haskell-hvr/lzma/issues/14
  lzma = dontCheck super.lzma;

  # https://github.com/BNFC/bnfc/issues/140
  BNFC = dontCheck super.BNFC;

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

  # https://github.com/yesodweb/serversession/issues/1
  serversession = dontCheck super.serversession;

  # Hydra no longer allows building texlive packages.
  lhs2tex = dontDistribute super.lhs2tex;

  # https://ghc.haskell.org/trac/ghc/ticket/9825
  vimus = overrideCabal super.vimus (drv: { broken = pkgs.stdenv.isLinux && pkgs.stdenv.isi686; });

  # https://github.com/hspec/mockery/issues/6
  mockery = overrideCabal super.mockery (drv: { preCheck = "export TRAVIS=true"; });

  # https://github.com/alphaHeavy/lzma-conduit/issues/5
  lzma-conduit = dontCheck super.lzma-conduit;

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

  # https://github.com/athanclark/sets/issues/2
  sets = dontCheck super.sets;

  # Install icons, metadata and cli program.
  bustle = overrideCabal super.bustle (drv: {
    buildDepends = [ pkgs.libpcap ];
    buildTools = with pkgs.buildPackages; [ gettext perl help2man ];
    patches = [
      # fix build
      # https://gitlab.freedesktop.org/bustle/bustle/merge_requests/14
      (pkgs.fetchpatch {
        url = "https://gitlab.freedesktop.org/bustle/bustle/commit/ee4b81cbc232d47ba9940f1987777b17452e71ff.patch";
        sha256 = "0v9cvbmrma5jcqcg1narpm1549h0cg8mr6i00qxmq0x6hs04dnwa";
      })
      (pkgs.fetchpatch {
        url = "https://gitlab.freedesktop.org/bustle/bustle/commit/aae6843f51f54679d440fb3813e61355dc8406b9.patch";
        sha256 = "1a8hr38hd1gdkqhsy56hyl7njw8ci79iigr81aalkb7hn4ckvh2a";
      })
    ];
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

  # https://github.com/goldfirere/singletons/issues/122
  singletons = dontCheck super.singletons;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = appendPatch super.djinn (pkgs.fetchpatch {
    url = https://github.com/augustss/djinn/commit/6cb9433a137fb6b5194afe41d616bd8b62b95630.patch;
    sha256 = "0s021y5nzrh74gfp8xpxpxm11ivzfs3jwg6mkrlyry3iy584xqil";
  });

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # We get lots of strange compiler errors during the test suite run.
  jsaddle = dontCheck super.jsaddle;

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal super.stunclient (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  });

  # The standard libraries are compiled separately
  idris = generateOptparseApplicativeCompletion "idris" (
    doJailbreak (dontCheck super.idris)
  );

  # https://github.com/bos/math-functions/issues/25
  math-functions = dontCheck super.math-functions;

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
        nativeBuildInputs = with pkgs.buildPackages.pythonPackages; [ sphinx recommonmark sphinx_rtd_theme ];
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

  # https://github.com/roelvandijk/terminal-progress-bar/issues/13
  # Still needed because of HUnit < 1.6
  terminal-progress-bar = doJailbreak super.terminal-progress-bar;

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

  # https://github.com/basvandijk/lifted-base/issues/34
  # Still needed as HUnit < 1.5
  lifted-base = doJailbreak super.lifted-base;

  # Don't depend on chell-quickcheck, which doesn't compile due to restricting
  # QuickCheck to versions ">=2.3 && <2.9".
  system-filepath = dontCheck super.system-filepath;

  # https://github.com/basvandijk/case-insensitive/issues/24
  # Still needed as HUnit < 1.6
  case-insensitive = doJailbreak super.case-insensitive;

  # https://github.com/hvr/uuid/issues/28
  uuid-types = doJailbreak super.uuid-types;
  uuid = doJailbreak super.uuid;

  # https://github.com/ekmett/lens/issues/713
  lens = disableCabalFlag super.lens "test-doctests";

  # https://github.com/haskell/fgl/issues/60
  # Needed for QuickCheck < 2.10
  fgl = dontCheck super.fgl;
  fgl-arbitrary = doJailbreak super.fgl-arbitrary;

  # The tests spuriously fail
  libmpd = dontCheck super.libmpd;

  # https://github.com/dan-t/cabal-lenses/issues/6
  cabal-lenses = doJailbreak super.cabal-lenses;

  # https://github.com/fizruk/http-api-data/issues/49
  http-api-data = dontCheck super.http-api-data;

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

  # missing dependencies: doctest ==0.12.*
  html-entities = doJailbreak super.html-entities;

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
  # doJailbreak because of hardcoded time, seems to be fixed upstream
  restless-git = dontCheck (doJailbreak super.restless-git);

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
  blaze-markup = doJailbreak super.blaze-markup;
  blaze-html = doJailbreak super.blaze-html;
  attoparsec = dontCheck super.attoparsec;      # 1 out of 67 tests fails
  int-cast = doJailbreak super.int-cast;
  nix-derivation = doJailbreak super.nix-derivation;

  # Needs QuickCheck <2.10, HUnit <1.6 and base <4.10
  pointfree = doJailbreak super.pointfree;

  # Needs tasty-quickcheck ==0.8.*, which we don't have.
  cryptohash-sha256 = dontCheck super.cryptohash-sha256;
  cryptohash-sha1 = doJailbreak super.cryptohash-sha1;
  cryptohash-md5 = doJailbreak super.cryptohash-md5;
  text-short = doJailbreak super.text-short;
  gitHUD = dontCheck super.gitHUD;
  githud = dontCheck super.githud;

  # https://github.com/aisamanra/config-ini/issues/12
  config-ini = dontCheck super.config-ini;

  # doctest >=0.9 && <0.12
  genvalidity-property = doJailbreak super.genvalidity-property;
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
  swagger2 = if (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) then dontHaddock (dontCheck super.swagger2) else super.swagger2;

  # requires a release including https://github.com/haskell-servant/servant-swagger/commit/249530d9f85fe76dfb18b100542f75a27e6a3079
  servant-swagger = dontCheck super.servant-swagger;

  # Tries to read a file it is not allowed to in the test suite
  load-env = dontCheck super.load-env;

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

  # https://github.com/haskell-rewriting/term-rewriting/pull/15
  # remove on next hackage update
  term-rewriting = doJailbreak super.term-rewriting;

  # https://github.com/GaloisInc/pure-zlib/pull/11
  pure-zlib = doJailbreak super.pure-zlib;

  # https://github.com/strake/lenz-template.hs/pull/2
  lenz-template = doJailbreak super.lenz-template;

  # https://github.com/haskell-hvr/resolv/pull/6
  resolv = dontCheck super.resolv;
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

  # # Builds only with the latest version of indexed-list-literals.
  # vector-sized_1_0_3_0 = super.vector-sized_1_0_3_0.override {
  #   indexed-list-literals = self.indexed-list-literals_0_2_1_1;
  # };

  # https://github.com/dmwit/encoding/pull/3
  encoding = doJailbreak (appendPatch super.encoding ./patches/encoding-Cabal-2.0.patch);

  # Work around overspecified constraint on github ==0.18.
  github-backup = doJailbreak super.github-backup;

  # Test suite depends on old QuickCheck 2.10.x.
  cassava = dontCheck super.cassava;

  # Test suite depends on cabal-install
  doctest = dontCheck super.doctest;

  # https://github.com/haskell-servant/servant-auth/issues/113
  servant-auth-client = dontCheck super.servant-auth-client;

  # Test has either build errors or fails anyway, depending on the compiler.
  vector-algorithms = dontCheck super.vector-algorithms;

  # The test suite attempts to use the network.
  dhall = generateOptparseApplicativeCompletion "dhall" (dontCheck super.dhall);

  # Missing test files in source distribution, fixed once 1.4.0 is bumped
  # https://github.com/dhall-lang/dhall-haskell/pull/997
  dhall-json =
    generateOptparseApplicativeCompletions ["dhall-to-json" "dhall-to-yaml"] (
      dontCheck super.dhall-json
  );

  dhall-nix =
    generateOptparseApplicativeCompletion "dhall-to-nix" (
      super.dhall-nix
  );

  # https://github.com/haskell-hvr/netrc/pull/2#issuecomment-469526558
  netrc = doJailbreak super.netrc;

  # https://github.com/haskell-hvr/hgettext/issues/14
  hgettext = doJailbreak super.hgettext;

  # 2.23.0 supports GHC 8.x and up
  haddock = super.haddock_2_22_0;
  # haddock-api-2.22.0: Break out of “QuickCheck ==2.11.*, hspec >=2.4.4 && <2.6”
  haddock-api = dontHaddock (doJailbreak (super.haddock-api_2_22_0));

  # The test suite is broken. Break out of "base-compat >=0.9.3 && <0.10, hspec >=2.4.4 && <2.5".
  haddock-library = doJailbreak (dontCheck super.haddock-library);

  # Generate shell completion.
  cabal2nix = generateOptparseApplicativeCompletion "cabal2nix" super.cabal2nix;

  stack =
    let
      stackWithOverrides =
        super.stack.override {
          # stack-2.1.3.1 requires pantry-0.2.0.0.
          pantry = self.pantry_0_2_0_0;
        };
    in
    generateOptparseApplicativeCompletion
      "stack"
      (appendPatches stackWithOverrides [
        # This PR fixes stack up to be able to build with Cabal-3.  This patch
        # can probably be dropped when the next stack release is made after
        # 2.1.3.1.
        (pkgs.fetchpatch {
          url = "https://github.com/commercialhaskell/stack/pull/5156.diff";
          sha256 = "0knk6f9fh1b4fxkhvx5gfrwclal4vi2va4zy34gpmwnjr7knf42y";
          excludes = [
            "snapshot-lts-12.yaml"
            "snapshot-nightly.yaml"
            "snapshot.yaml"
          ];
        })
        # This patch fixes stack up to be able to build various GHC-8.8 changes.
        # This can hopefully be dropped when the next stack release is made
        # after 2.1.3.1 (assuming the next stack release uses GHC-8.8).
        ./patches/stack-ghc882-support.patch
      ]);

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

  # Tests require a browser: https://github.com/ku-fpg/blank-canvas/issues/73
  blank-canvas = dontCheck super.blank-canvas;
  blank-canvas_0_6_2 = dontCheck super.blank-canvas_0_6_2;

  # needed because of testing-feat >=0.4.0.2 && <1.1
  language-ecmascript = doJailbreak super.language-ecmascript;

  # sexpr is old, broken and has no issue-tracker. Let's fix it the best we can.
  sexpr =
    appendPatch (overrideCabal super.sexpr (drv: {
      isExecutable = false;
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [self.QuickCheck];
    })) ./patches/sexpr-0.2.1.patch;

  # https://github.com/haskell/hoopl/issues/50
  hoopl = dontCheck super.hoopl;

  # https://github.com/snapframework/xmlhtml/pull/37
  xmlhtml = doJailbreak super.xmlhtml;

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

  # https://github.com/kcsongor/generic-lens/pull/65
  generic-lens = dontCheck super.generic-lens;

  # https://github.com/danfran/cabal-macosx/issues/13
  cabal-macosx = dontCheck super.cabal-macosx;

  # https://github.com/DanielG/cabal-helper/issues/59
  cabal-helper = doJailbreak super.cabal-helper;

  # TODO(Profpatsch): factor out local nix store setup from
  # lib/tests/release.nix and use that for the tests of libnix
  # libnix = overrideCabal super.libnix (old: {
  #   testToolDepends = old.testToolDepends or [] ++ [ pkgs.nix ];
  # });
  libnix = dontCheck super.libnix;

  # The test suite tries to mess with ALSA, which doesn't work in the build sandbox.
  xmobar = dontCheck super.xmobar;

  # https://github.com/mgajda/json-autotype/issues/25
  json-autotype = dontCheck super.json-autotype;

  # Jailbreak tasty < 1.2: https://github.com/phadej/tdigest/issues/30
  tdigest = doJailbreak super.tdigest; # until tdigest > 0.2.1

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

  # Remove unecessary constraint:
  # https://github.com/agrafix/superbuffer/pull/2
  superbuffer = overrideCabal super.superbuffer (drv: {
    postPatch = ''
      sed -i 's#QuickCheck < 2.10#QuickCheck < 2.13#' superbuffer.cabal
    '';
  });

  # test suite failure: https://github.com/jgm/pandoc/issues/5582
  pandoc = dontCheck super.pandoc;

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch super.xattr ./patches/xattr-fix-build.patch;

  # Some tests depend on a postgresql instance
  # Haddock failure: https://github.com/haskell/haddock/issues/979
  esqueleto = dontHaddock (dontCheck super.esqueleto);

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

  # QuickCheck >=2.3 && <2.13, hspec >=2.1 && <2.7
  graphviz = dontCheck super.graphviz;

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

  # Version bounds for http-client are too strict:
  # https://github.com/bitnomial/prometheus/issues/34
  prometheus = doJailbreak super.prometheus;

  # Tasty-tap tests are out-of-date with TAP format
  # https://github.com/MichaelXavier/tasty-tap/issues/2
  tasty-tap = appendPatch super.tasty-tap (pkgs.fetchpatch {
    url = https://patch-diff.githubusercontent.com/raw/MichaelXavier/tasty-tap/pull/3.diff;
    sha256 = "0l8zbc56dy8ilxl3k49aiknmfhgpcg3jhs72lh3dk51d0a09d9sv";
  });

  # The doctests in universum-1.5.0 are broken.  The doctests in versions of universum after
  # 1.5.0 should be fixed, so this should be able to be removed.
  universum = dontCheck super.universum;

  # https://github.com/erikd/hjsmin/issues/32
  hjsmin = dontCheck super.hjsmin;

  # https://github.com/blamario/grampa/issues/19
  rank2classes = dontCheck super.rank2classes;

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

  # https://github.com/Happstack/web-routes-th/pull/3
  web-routes-th = doJailbreak super.web-routes-th;

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
        # upstream PR: https://github.com/james-preston/hail/pull/15
        url = "https://patch-diff.githubusercontent.com/raw/james-preston/hail/pull/15.patch";
        sha256 = "03kdvr8hxi6isb8yxp5rgcmz855n19m1yacn3d56a4i58j2mldjw";
      })
    ];
  });

  # Needs the corresponding version of haskell-src-exts.
  haskell-src-exts-simple = super.haskell-src-exts-simple.override { haskell-src-exts = self.haskell-src-exts_1_23_0; };

  # https://github.com/Daniel-Diaz/HaTeX/issues/144
  HaTeX = dontCheck super.HaTeX;

  # https://github.com/kazu-yamamoto/dns/issues/150
  dns = dontCheck super.dns;

  # Support recent versions of fast-logger.
  spacecookie = doJailbreak super.spacecookie;

  # apply patches from https://github.com/snapframework/snap-server/pull/126
  # manually until they are accepted upstream
  snap-server = overrideCabal super.snap-server (drv: {
    patches = [(pkgs.fetchpatch {
      # allow compilation with network >= 3
      url = https://github.com/snapframework/snap-server/pull/126/commits/4338fe15d68e11e3c7fd0f9862f818864adc1d45.patch;
      sha256 = "1nlw9lckm3flzkmhkzwc7zxhdh9ns33w8p8ds8nf574nqr5cr8bv";
    })
    (pkgs.fetchpatch {
      # prefer fdSocket over unsafeFdSocket
      url = https://github.com/snapframework/snap-server/pull/126/commits/410de2df123b1d56b3093720e9c6a1ad79fe9de6.patch;
      sha256 = "08psvw0xny64q4bw1nwg01pkzh01ak542lw6k1ps7cdcwaxk0n94";
    })];
  });

  # https://github.com/haskell-servant/servant-blaze/issues/17
  servant-blaze = doJailbreak super.servant-blaze;

  # https://github.com/haskell-servant/servant-ekg/issues/15
  servant-ekg = doJailbreak super.servant-ekg;

  # krank-0.1.0 does not accept PyF-0.9.0.0.
  krank = doJailbreak super.krank;

  # the test suite has an overly tight restriction on doctest
  # See https://github.com/ekmett/perhaps/pull/5
  perhaps = doJailbreak super.perhaps;

  # it wants to build a statically linked binary by default
  hledger-flow = overrideCabal super.hledger-flow ( drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace hledger-flow.cabal --replace "-static" ""
    '';
  });

  # cabal-fmt requires Cabal3
  cabal-fmt = super.cabal-fmt.override { Cabal = self.Cabal_3_0_0_0; };

  # Several gtk2hs-provided packages at v0.13.8.0 fail to build on Darwin
  # until we pick up https://github.com/gtk2hs/gtk2hs/pull/293 so apply that
  # patch here. That single patch is for the gtk2hs super-repo, out of which
  # we extract the patch for each indvidiual project (glib/gio/pango/gtk/gtk3).
  glib = appendPatch super.glib (pkgs.fetchpatch {
    url = "https://github.com/gtk2hs/gtk2hs/commit/1cf2f9bff2427d39986e32880d1383cfff49ab0e.patch";
    includes = [ "glib.cabal" ];
    stripLen = 1;
    sha256 = "1zdss1xgsbijs3kx8dp5a81qryrfc1zm1xrd20whna3dqakf8b7g";
  });
  gio = appendPatch super.gio (pkgs.fetchpatch {
    url = "https://github.com/gtk2hs/gtk2hs/commit/1cf2f9bff2427d39986e32880d1383cfff49ab0e.patch";
    includes = [ "gio.cabal" ];
    stripLen = 1;
    sha256 = "0d72k6gqvgax9jcqi3gz1gqnar7jg8p5065z3mw2fcwvdw46s2zv";
  });
  pango = appendPatch super.pango (pkgs.fetchpatch {
    url = "https://github.com/gtk2hs/gtk2hs/commit/1cf2f9bff2427d39986e32880d1383cfff49ab0e.patch";
    includes = [ "pango.cabal" ];
    stripLen = 1;
    sha256 = "0dc221wlmyhc24h6ybfhbkxmcx4i6bvkbr1zgqidbnj3yp6w0l5w";
  });
  # gtk/gtk3 have an additional complication: independent of the above
  # 0.13.8.0-specific fix, they need to be told on Darwin to use the Quartz
  # rather than X11 backend (see eg https://github.com/gtk2hs/gtk2hs/issues/249).
  gtk3 =
    let
      patchedGtk3 = appendPatch super.gtk3 (pkgs.fetchpatch {
        url = "https://github.com/gtk2hs/gtk2hs/commit/1cf2f9bff2427d39986e32880d1383cfff49ab0e.patch";
        includes = [ "gtk3.cabal" ];
        stripLen = 1;
        sha256 = "0zvj0dzfwf9bksfhi0m4v0h5aij236gd0qhyr1adpdcjrkd8zbkd";
      });
    in
      # The appendConfigureFlags should remain even after we can drop patchedGtk3.
      appendConfigureFlags patchedGtk3 (pkgs.lib.optional pkgs.stdenv.isDarwin "-f have-quartz-gtk");
  gtk =
    let
      patchedGtk = appendPatch super.gtk (pkgs.fetchpatch {
        url = "https://github.com/gtk2hs/gtk2hs/commit/1cf2f9bff2427d39986e32880d1383cfff49ab0e.patch";
        includes = [ "gtk.cabal-renamed" ];
        stripLen = 1;
        sha256 = "0wb0scvmhg8b42hxpns9m6zak3r8b25a2z7wg6vl56n17nb635l7";
        # One final complication: the gtk cabal file in the source repo (as seen
        # by the patch) is `gtk.cabal-renamed`, but this gets changed to the usual
        # `gtk.cabal` before uploading to Hackage by a script.
        postFetch = ''
          substituteInPlace $out --replace "-renamed" ""
        '';
      });
    in
      # The appendConfigureFlags should remain even after we can drop patchedGtk.
      appendConfigureFlags patchedGtk (pkgs.lib.optional pkgs.stdenv.isDarwin "-f have-quartz-gtk");

  # Chart-tests needs and compiles some modules from Chart itself
  Chart-tests = (addExtraLibrary super.Chart-tests self.QuickCheck).overrideAttrs (old: {
    preCheck = old.postPatch or "" + ''
      tar --one-top-level=../chart --strip-components=1 -xf ${self.Chart.src}
    '';
  });

  # Unnecessary upper bound on vector <0.12.1
  bitwise-enum = doJailbreak super.bitwise-enum;

  # This breaks because of version bounds, but compiles and runs fine.
  # Last commit is 5 years ago, so we likely won't get upstream fixed soon.
  # https://bitbucket.org/rvlm/hakyll-contrib-hyphenation/src/master/
  # Therefore we jailbreak it.
  hakyll-contrib-hyphenation = doJailbreak super.hakyll-contrib-hyphenation;

  # https://github.com/bergmark/feed/issues/43
  feed = dontCheck super.feed;

  pantry_0_2_0_0 = appendPatches (dontCheck super.pantry_0_2_0_0) [
    # pantry-0.2.0.0 doesn't build with ghc-8.8, but there is a PR adding support.
    # https://github.com/commercialhaskell/pantry/pull/6
    # Currently stack-2.1.3.1 requires pantry-0.2.0.0, but when a newer version of
    # stack is released, it will probably use the newer pantry version, so we
    # can completely get rid of pantry-0.2.0.0.
    (pkgs.fetchpatch {
      url = "https://github.com/commercialhaskell/pantry/pull/6.diff";
      sha256 = "0aml06jshpjh3aiscs5av7y33m3d6s6x5pzdvh7pky476izfg87k";
      excludes = [
        ".azure/azure-linux-template.yml"
        ".azure/azure-osx-template.yml"
        ".azure/azure-windows-template.yml"
        "package.yaml"
        "pantry.cabal"
        "stack-lts-11.yaml"
        "stack-lts-12.yaml"
        "stack-nightly.yaml"
        "stack-windows.yaml"
        "stack.yaml"
      ];
    })
  ];

  # https://github.com/serokell/nixfmt/pull/62
  nixfmt = doJailbreak super.nixfmt;

  # https://github.com/phadej/binary-orphans/issues/45
  binary-instances = dontCheck super.binary-instances;

  # Disabling the test suite lets the build succeed on older CPUs
  # that are unable to run the generated library because they
  # lack support for AES-NI, like some of our Hydra build slaves
  # do. See https://github.com/NixOS/nixpkgs/issues/81915 for
  # details.
  cryptonite = dontCheck super.cryptonite;

  # The test suite depends on an impure cabal-install installation
  # in $HOME, which we don't have in our build sandbox.
  cabal-install-parsers = dontCheck super.cabal-install-parsers;

  # haskell-ci-0.8 needs cabal-install-parsers ==0.1, but we have 0.2.
  haskell-ci = doJailbreak super.haskell-ci;

  persistent-mysql = dontCheck super.persistent-mysql;

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

} // import ./configuration-tensorflow.nix {inherit pkgs haskellLib;} self super
