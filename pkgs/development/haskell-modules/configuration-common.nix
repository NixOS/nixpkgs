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

  # There are numerical tests on random data, that may fail occasionally
  lapack = dontCheck super.lapack;

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
  c2hsc = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/jwiegley/c2hsc/commit/490ecab202e0de7fc995eedf744ad3cb408b53cc.patch";
    sha256 = "1c7knpvxr7p8c159jkyk6w29653z5yzgjjqj11130bbb8mk9qhq7";
  }) super.c2hsc;

  # Some Hackage packages reference this attribute, which exists only in the
  # GHCJS package set. We provide a dummy version here to fix potential
  # evaluation errors.
  ghcjs-base = null;
  ghcjs-prim = null;

  # Needs older QuickCheck version
  attoparsec-varword = dontCheck super.attoparsec-varword;

  # These packages (and their reverse deps) cannot be built with profiling enabled.
  ghc-heap-view = disableLibraryProfiling super.ghc-heap-view;
  ghc-datasize = disableLibraryProfiling super.ghc-datasize;
  ghc-vis = disableLibraryProfiling super.ghc-vis;

  # `pinch`s test suite uses a function called `openSocket` that's available
  # in `network` versions 3.1.2.0 and bigger.
  # There's an open PR updating the lower bound for `network`:
  # > https://github.com/abhinav/pinch/pull/46
  # With that said version tracked for `network` right now is 3.1.1.1 so we're
  # replacing the network pinch uses with `network_3_1_2_7` for now.
  pinch = super.pinch.overrideScope (self : super: {
    network = self.network_3_1_2_7;
  });

  # We can remove this once fakedata version gets to 1.0.1 as the test suite
  # works fine there.
  fakedata = dontCheck super.fakedata;

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
      sha256 = "11idvicisp4wnw15lk7f9fs0kqpssngs1j8f98050f3jrqsccj0j";
      # delete android and Android directories which cause issues on
      # darwin (case insensitive directory). Since we don't need them
      # during the build process, we can delete it to prevent a hash
      # mismatch on darwin.
      postFetch = ''
        rm -r $out/doc/?ndroid*
      '';
    };
  }) super.git-annex;

  # Fix test trying to access /home directory
  shell-conduit = overrideCabal (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";
  }) super.shell-conduit;

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # https://github.com/haskell-game/dear-imgui.hs/issues/116
  dear-imgui = doJailbreak super.dear-imgui;

  # Tests require older versions of tasty.
  hzk = dontCheck super.hzk;
  resolv = doJailbreak super.resolv;
  tdigest = doJailbreak super.tdigest;
  text-short = doJailbreak super.text-short;
  tree-diff = doJailbreak super.tree-diff;
  zinza = doJailbreak super.zinza;

  # Tests require a Kafka broker running locally
  haskakafka = dontCheck super.haskakafka;

  bindings-levmar = overrideCabal (drv: {
    extraLibraries = [ pkgs.blas ];
  }) super.bindings-levmar;

  # Requires wrapQtAppsHook
  qtah-cpp-qt5 = overrideCabal (drv: {
    buildDepends = [ pkgs.qt5.wrapQtAppsHook ];
  }) super.qtah-cpp-qt5;

  # The Haddock phase fails for one reason or another.
  deepseq-magic = dontHaddock super.deepseq-magic;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # sse2 flag due to https://github.com/haskell/vector/issues/47.
  # Jailbreak is necessary for QuickCheck dependency.
  vector = doJailbreak (if pkgs.stdenv.isi686 then appendConfigureFlag "--ghc-options=-msse2" super.vector else super.vector);

  inline-c-cpp = overrideCabal (drv: {
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

  # hnix.patch needed until the next release is bumped
  hnix = generateOptparseApplicativeCompletion "hnix"
    (overrideCabal (drv: {
      # 2020-06-05: HACK: does not pass own build suite - `dontCheck`
      doCheck = false;
    }) (super.hnix.override {
      # needs newer version of relude and semialign than stackage has
      relude = self.relude_1_0_0_1;
      semialign = self.semialign_1_2_0_1;
    }));

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
  aws = doJailbreak (dontCheck super.aws);              # needs aws credentials, jailbreak for base16-bytestring
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
  }) super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http-link-header = dontCheck super.http-link-header; # non deterministic failure https://hydra.nixos.org/build/75041105
  influxdb = dontCheck super.influxdb;
  integer-roots = dontCheck super.integer-roots; # requires an old version of smallcheck, will be fixed in > 1.0
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-slice = dontCheck super.language-slice;
  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lvmrun = disableHardening ["format"] (dontCheck super.lvmrun);
  matplotlib = dontCheck super.matplotlib;
  # https://github.com/matterhorn-chat/matterhorn/issues/679 they do not want to be on stackage
  matterhorn = doJailbreak (super.matterhorn.overrideScope (self: super: {
    brick = self.brick_0_64_2;
  }));
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
  numerals = dontCheck super.numerals;
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
  mikmod = addExtraLibrary pkgs.libmikmod super.mikmod;

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

  # Waiting on language-python 0.5.8 https://github.com/bjpop/language-python/issues/60
  xcffib = dontCheck super.xcffib;

  # https://github.com/afcowie/locators/issues/1
  locators = dontCheck super.locators;

  # Test suite won't compile against tasty-hunit 0.10.x.
  binary-parser = dontCheck super.binary-parser;
  binary-parsers = dontCheck super.binary-parsers;
  bytestring-strict-builder = dontCheck super.bytestring-strict-builder;
  bytestring-tree-builder = dontCheck super.bytestring-tree-builder;

  # https://github.com/byteverse/bytebuild/issues/19
  bytebuild = dontCheck super.bytebuild;

  # https://github.com/andrewthad/haskell-ip/issues/67
  ip = dontCheck super.ip;

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
  #   (if pkgs.buildPlatform != pkgs.hostPlatform
  #    then self.buildHaskellPackages.doctest-discover
  #    else dontCheck super.doctest-discover);
  doctest-discover = dontCheck super.doctest-discover;

  # Depends on itself for testing
  tasty-discover = overrideCabal (drv: {
    preBuild = ''
      export PATH="$PWD/dist/build/tasty-discover:$PATH"
    '' + (drv.preBuild or "");
  }) super.tasty-discover;

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
  Win32 = overrideCabal (drv: { broken = !pkgs.stdenv.isCygwin; }) super.Win32;
  inline-c-win32 = dontDistribute super.inline-c-win32;
  Southpaw = dontDistribute super.Southpaw;

  # Hydra no longer allows building texlive packages.
  lhs2tex = dontDistribute super.lhs2tex;

  # https://ghc.haskell.org/trac/ghc/ticket/9825
  vimus = overrideCabal (drv: { broken = pkgs.stdenv.isLinux && pkgs.stdenv.isi686; }) super.vimus;

  # https://github.com/kazu-yamamoto/logger/issues/42
  logger = dontCheck super.logger;

  # vector dependency < 0.12
  imagemagick = doJailbreak super.imagemagick;

  # https://github.com/liyang/thyme/issues/36
  thyme = dontCheck super.thyme;

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
  bustle = overrideCabal (drv: {
    buildDepends = [ pkgs.libpcap ];
    buildTools = with pkgs.buildPackages; [ gettext perl help2man ];
    postInstall = ''
      make install PREFIX=$out
    '';
  }) super.bustle;

  # Byte-compile elisp code for Emacs.
  ghc-mod = overrideCabal (drv: {
    preCheck = "export HOME=$TMPDIR";
    testToolDepends = drv.testToolDepends or [] ++ [self.cabal-install];
    doCheck = false;            # https://github.com/kazu-yamamoto/ghc-mod/issues/335
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.buildPackages.emacs];
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.name}/*/${drv.pname}-${drv.version}/elisp" )
      make -C $lispdir
      mkdir -p $data/share/emacs/site-lisp
      ln -s "$lispdir/"*.el{,c} $data/share/emacs/site-lisp/
    '';
  }) super.ghc-mod;

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
      local lispdir=( "$data/share/${self.ghc.name}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
  }) super.structured-haskell-mode;

  # Make elisp files available at a location where people expect it.
  hindent = (overrideCabal (drv: {
    # We cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.name}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
    doCheck = false; # https://github.com/chrisdone/hindent/issues/299
  }) super.hindent);

  # https://github.com/bos/configurator/issues/22
  configurator = dontCheck super.configurator;

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/bos/bloomfilter/issues/7
  bloomfilter = appendPatch ./patches/bloomfilter-fix-on-32bit.patch super.bloomfilter;

  # https://github.com/ashutoshrishi/hunspell-hs/pull/3
  hunspell-hs = addPkgconfigDepend pkgs.hunspell (dontCheck (appendPatch ./patches/hunspell.patch super.hunspell-hs));

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # Djinn's last release was 2014, incompatible with Semigroup-Monoid Proposal
  # https://github.com/augustss/djinn/pull/8
  djinn = appendPatch (pkgs.fetchpatch {
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
  in appendPatch (pkgs.fetchpatch {
    url = "https://github.com/Philonous/d-bus/commit/e5f37900a3a301c41d98bdaa134754894c705681.patch";
    sha256 = "6rQ7H9t483sJe1x95yLPAZ0BKTaRjgqQvvrQv7HkJRE=";
  }) newer;

  # * The standard libraries are compiled separately.
  # * We need multiple patches from master to fix compilation with
  #   updated dependencies (haskeline and megaparsec) which can be
  #   removed when the next idris release (1.3.4 probably) comes
  #   around.
  idris = generateOptparseApplicativeCompletion "idris"
    (doJailbreak (dontCheck super.idris));

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

  # Too strict bounds on template-haskell (doesn't allow 2.16)
  # For 2.17 support: https://github.com/JonasDuregard/sized-functors/pull/10
  size-based = doJailbreak super.size-based;

  # https://github.com/diagrams/diagrams-braille/issues/1
  diagrams-braille = doJailbreak super.diagrams-braille;

  # https://github.com/timbod7/haskell-chart/pull/231#issuecomment-953745932
  Chart-diagrams = doJailbreak super.Chart-diagrams;

  # https://github.com/xu-hao/namespace/issues/1
  namespace = doJailbreak super.namespace;

  # https://github.com/diagrams/diagrams-solve/issues/4
  diagrams-solve = dontCheck super.diagrams-solve;

  # https://github.com/danidiaz/streaming-eversion/issues/1
  streaming-eversion = dontCheck super.streaming-eversion;

  # https://github.com/danidiaz/tailfile-hinotify/issues/2
  tailfile-hinotify = dontCheck super.tailfile-hinotify;

  # Test suite fails: https://github.com/lymar/hastache/issues/46.
  # Don't install internal mkReadme tool.
  hastache = overrideCabal (drv: {
    doCheck = false;
    postInstall = "rm $out/bin/mkReadme && rmdir $out/bin";
  }) super.hastache;

  # Has a dependency on outdated versions of directory.
  cautious-file = doJailbreak (dontCheck super.cautious-file);

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
  cryptol = overrideCabal (drv: {
    buildTools = drv.buildTools or [] ++ [ pkgs.buildPackages.makeWrapper ];
    postInstall = drv.postInstall or "" + ''
      for b in $out/bin/cryptol $out/bin/cryptol-html; do
        wrapProgram $b --prefix 'PATH' ':' "${pkgs.lib.getBin pkgs.z3}/bin"
      done
    '';
  }) super.cryptol;

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
  blaze-html = doJailbreak super.blaze-html;
  int-cast = doJailbreak super.int-cast;

  # Needs QuickCheck <2.10, HUnit <1.6 and base <4.10
  pointfree = doJailbreak super.pointfree;

  # The project is stale
  #
  # Archiving request: https://github.com/haskell-hvr/cryptohash-sha512/issues/6
  #
  # doJailbreak since base <4.12 && bytestring <0.11
  # Request to support:
  # https://github.com/haskell-hvr/cryptohash-sha512/issues/4
  # PRs to support base <4.12:
  # https://github.com/haskell-hvr/cryptohash-sha512/pull/3
  # https://github.com/haskell-hvr/cryptohash-sha512/pull/5
  #
  # dontCheck since test suite does not support new `base16-bytestring` >= 1 format
  # https://github.com/haskell-hvr/cryptohash-sha512/pull/5#issuecomment-752796913
  cryptohash-sha512 = dontCheck (doJailbreak super.cryptohash-sha512);

  # https://github.com/haskell-hvr/cryptohash-sha256/issues/11
  # Jailbreak is necessary to break out of tasty < 1.x dependency.
  # hackage2nix generates this as a broken package due to the (fake) dependency
  # missing from hackage, so we need to fix the meta attribute set.
  cryptohash-sha256 = overrideCabal (drv: {
    jailbreak = true;
    broken = false;
    hydraPlatforms = pkgs.lib.platforms.all;
  }) super.cryptohash-sha256;

  # The test suite has all kinds of out-dated dependencies, so it feels easier
  # to just disable it.
  cryptohash-sha1 = dontCheck super.cryptohash-sha1;
  cryptohash-md5 = dontCheck super.cryptohash-md5;

  # Needs tasty-quickcheck ==0.8.*, which we don't have.
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

  # https://github.com/alphaHeavy/protobuf/issues/34
  protobuf = dontCheck super.protobuf;

  # Is this package still maintained? https://github.com/haskell/text-icu/issues/30
  text-icu = overrideCabal (drv: {
    doCheck = false;                                               # https://github.com/bos/text-icu/issues/32
    configureFlags = ["--ghc-option=-DU_DEFINE_FALSE_AND_TRUE=1"]; # https://github.com/haskell/text-icu/issues/49
  }) super.text-icu;

  # jailbreak tasty < 1.2 until servant-docs > 0.11.3 is on hackage.
  servant-docs = doJailbreak super.servant-docs;
  snap-templates = doJailbreak super.snap-templates; # https://github.com/snapframework/snap-templates/issues/22

  # hledger-lib requires the latest version of pretty-simple
  hledger-lib = appendPatch
    # This patch has been merged but not released yet:
    # https://github.com/simonmichael/hledger/pull/1512. It is
    # important for ledger-autosync test suite:
    # https://github.com/egh/ledger-autosync/issues/123
    (pkgs.fetchpatch {
      name   = "hledger-properly-escape-quotes-csv.patch";
      url    = "https://github.com/simonmichael/hledger/commit/c9a72e1615e2ddc2824f2e248456e1042eb31e1d.patch";
      sha256 = "10knvrd5bl9nrmi27i0pm82sfr64jy04xgbjp228qywyijpr3pqv";
      includes = [ "Hledger/Read/CsvReader.hs" ];
      stripLen = 1;
    })
    super.hledger-lib;

  # hledger-lib 1.24 depends on doctest >= 0.18
  hledger-lib_1_24_1 = super.hledger-lib_1_24_1.override {
    doctest = self.doctest_0_18_2;
  };

  # Copy hledger man pages from data directory into the proper place. This code
  # should be moved into the cabal2nix generator.
  hledger = overrideCabal (drv: {
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
  }) super.hledger;
  hledger-ui = overrideCabal (drv: {
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
  }) super.hledger-ui;
  hledger-web = overrideCabal (drv: {
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
  }) super.hledger-web;


  # https://github.com/haskell-hvr/resolv/pull/6
  resolv_0_1_1_2 = dontCheck super.resolv_0_1_1_2;

  # spdx 0.2.2.0 needs older tasty
  # was fixed in spdx master (4288df6e4b7840eb94d825dcd446b42fef25ef56)
  spdx = dontCheck super.spdx;

  # The test suite does not know how to find the 'alex' binary.
  alex = overrideCabal (drv: {
    testSystemDepends = (drv.testSystemDepends or []) ++ [pkgs.which];
    preCheck = ''export PATH="$PWD/dist/build/alex:$PATH"'';
  }) super.alex;

  # This package refers to the wrong library (itself in fact!)
  vulkan = super.vulkan.override { vulkan = pkgs.vulkan-loader; };

  # Compiles some C or C++ source which requires these headers
  VulkanMemoryAllocator = addExtraLibrary pkgs.vulkan-headers super.VulkanMemoryAllocator;
  vulkan-utils = addExtraLibrary pkgs.vulkan-headers super.vulkan-utils;

  # https://github.com/dmwit/encoding/pull/3
  encoding = doJailbreak (appendPatch ./patches/encoding-Cabal-2.0.patch super.encoding);

  # Work around overspecified constraint on github ==0.18.
  github-backup = doJailbreak super.github-backup;

  # https://github.com/andrewthad/chronos/issues/62
  # doctests are failing on newer GHC versions
  chronos = dontCheck super.chronos;

  # Test suite depends on cabal-install
  doctest = dontCheck super.doctest;

  # dontCheck: https://github.com/haskell-servant/servant-auth/issues/113
  # doJailbreak: waiting on revision 1 to hit hackage
  servant-auth-client = doJailbreak (dontCheck super.servant-auth-client);

  # Generate cli completions for dhall.
  dhall = generateOptparseApplicativeCompletion "dhall" super.dhall;
  # For reasons that are not quire clear 'dhall-json' won't compile without 'tasty 1.4' due to its tests
  # https://github.com/commercialhaskell/stackage/issues/5795
  # This issue can be mitigated with 'dontCheck' which skips the tests and their compilation.
  dhall-json = generateOptparseApplicativeCompletions ["dhall-to-json" "dhall-to-yaml"] (dontCheck super.dhall-json);
  dhall-nix = generateOptparseApplicativeCompletion "dhall-to-nix" super.dhall-nix;
  dhall-yaml = generateOptparseApplicativeCompletions ["dhall-to-yaml-ng" "yaml-to-dhall"] super.dhall-yaml;
  dhall-nixpkgs = generateOptparseApplicativeCompletion "dhall-to-nixpkgs" super.dhall-nixpkgs;

  # https://github.com/haskell-hvr/netrc/pull/2#issuecomment-469526558
  netrc = doJailbreak super.netrc;

  # https://github.com/haskell-hvr/hgettext/issues/14
  hgettext = doJailbreak super.hgettext;

  # Generate shell completion.
  cabal2nix = generateOptparseApplicativeCompletion "cabal2nix" super.cabal2nix;
  niv = generateOptparseApplicativeCompletion "niv" (super.niv.overrideScope (self: super: {
   # Needs override because of: https://github.com/nmattia/niv/issues/312
   optparse-applicative = self.optparse-applicative_0_15_1_0;
  }));
  ormolu = generateOptparseApplicativeCompletion "ormolu" super.ormolu;
  stack = generateOptparseApplicativeCompletion "stack" super.stack;

  # musl fixes
  # dontCheck: use of non-standard strptime "%s" which musl doesn't support; only used in test
  unix-time = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.unix-time else super.unix-time;

  # hslua has tests that appear to break when using musl.
  # https://github.com/hslua/hslua/issues/106
  # Note that hslua is currently version 1.3.  However, in the latest version
  # (>= 2.0), hslua has been split into multiple packages and this override
  # will likely need to be moved to the hslua-core package.
  hslua = if pkgs.stdenv.hostPlatform.isMusl then dontCheck super.hslua else super.hslua;

  # The test suite runs for 20+ minutes on a very fast machine, which feels kinda disproportionate.
  prettyprinter = dontCheck super.prettyprinter;
  brittany = doJailbreak (dontCheck super.brittany);  # Outdated upperbound on ghc-exactprint: https://github.com/lspitzner/brittany/issues/342

  # Fix with Cabal 2.2, https://github.com/guillaume-nargeot/hpc-coveralls/pull/73
  hpc-coveralls = appendPatch (pkgs.fetchpatch {
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

  # The most recent version of purescript-cst (0.4.0.0) has version
  # bounds for LTS-17, so we need to jailbreak it for LTS-18.
  # doJailbreak can likely be removed when the next version of
  # purescript-cst is released, since the version bounds have
  # been updated for LTS-18.
  purescript-cst = doJailbreak super.purescript-cst;

  purescript =
    pkgs.lib.pipe
      (super.purescript.override {
        # The latest version of language-javascript is 0.7.1.0,
        # but it seems to have a bug with async support:
        # https://github.com/erikd/language-javascript/issues/131
        language-javascript = self.language-javascript_0_7_0_0;
      })
      [ # This PR upgrades purescript from building with LTS-17 to building
        # with LTS-18.  Aside from bumping dependency bounds, there is one
        # minor change that needs to be made in app/Main.hs.
        #
        # This patch can likely be removed when purescript-0.14.6 is released.
        (appendPatch
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/purescript/purescript/pull/4199.patch";
            sha256 = "sha256-OeG30EfCHs7gttLME909WfKxkEZr7Ch3leYiw4lElGg=";
            includes = [
              "app/Main.hs"
            ];
          })
        )
        # PureScript uses nodejs to run tests, so the tests have been disabled
        # for now.  If someone is interested in figuring out how to get this
        # working, it seems like it might be possible.
        dontCheck
        # The current version of purescript (0.14.5) has version bounds for LTS-17,
        # but it compiles cleanly using deps in LTS-18 as well.  This jailbreak can
        # likely be removed when purescript-0.14.6 is released.
        doJailbreak
        # Generate shell completions
        (generateOptparseApplicativeCompletion "purs")
      ];

  # purenix-1.0 has a strict version bound requiring purescript-0.14.4, but it
  # works with later versions of purescript as well.
  purenix = doJailbreak super.purenix;

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
  # libnix = overrideCabal (old: {
  #   testToolDepends = old.testToolDepends or [] ++ [ pkgs.nix ];
  # }) super.libnix;
  libnix = dontCheck super.libnix;

  # dontCheck: The test suite tries to mess with ALSA, which doesn't work in the build sandbox.
  xmobar = dontCheck super.xmobar;

  # https://github.com/mgajda/json-autotype/issues/25
  json-autotype = dontCheck super.json-autotype;

  # Requires dlist <0.9 but it works fine with dlist-1.0
  # https://github.com/haskell-beam/beam/issues/581
  beam-core = doJailbreak super.beam-core;

  # Requires pg_ctl command during tests
  beam-postgres = overrideCabal (drv: {
    testToolDepends = (drv.testToolDepends or []) ++ [pkgs.postgresql];
  }) super.beam-postgres;

  # Fix for base >= 4.11
  scat = overrideCabal (drv: {
    patches = [(pkgs.fetchpatch {
      url    = "https://github.com/redelmann/scat/pull/6.diff";
      sha256 = "07nj2p0kg05livhgp1hkkdph0j0a6lb216f8x348qjasy0lzbfhl";
    })];
  }) super.scat;

  # Fix build with attr-2.4.48 (see #53716)
  xattr = appendPatch ./patches/xattr-fix-build.patch super.xattr;

  # Some tests depend on a postgresql instance
  esqueleto = dontCheck super.esqueleto;

  # Requires API keys to run tests
  algolia = dontCheck super.algolia;

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

  # Version constraints on test dependency tasty-golden need to be relaxed:
  # https://github.com/nomeata/arbtt/pull/146
  arbtt = doJailbreak (overrideCabal (drv: {
    # The test suite needs the packages's executables in $PATH to succeed.
    preCheck = ''
      for i in $PWD/dist/build/*; do
        export PATH="$i:$PATH"
      done
    '';
  }) super.arbtt);

  # https://github.com/erikd/hjsmin/issues/32
  hjsmin = dontCheck super.hjsmin;

  # upstream issue: https://github.com/vmchale/atspkg/issues/12
  language-ats = dontCheck super.language-ats;

  # Remove for hail > 0.2.0.0
  hail = overrideCabal (drv: {
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
  }) super.hail;

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

  # 2020-06-22: NOTE: > 0.4.0 => rm Jailbreak: https://github.com/serokell/nixfmt/issues/71
  nixfmt = doJailbreak super.nixfmt;

  # The test suite depends on an impure cabal-install installation in
  # $HOME, which we don't have in our build sandbox.
  cabal-install-parsers = dontCheck super.cabal-install-parsers;

  # 2021-08-18: Erroneously  claims that it needs a newer HStringTemplate (>= 0.8.8) than stackage.
  gitit = doJailbreak super.gitit;

  # Test suite requires database
  persistent-mysql = dontCheck super.persistent-mysql;
  persistent-postgresql = dontCheck super.persistent-postgresql;

  # Fix EdisonAPI and EdisonCore for GHC 8.8:
  # https://github.com/robdockins/edison/pull/16
  EdisonAPI = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/robdockins/edison/pull/16/commits/8da6c0f7d8666766e2f0693425c347c0adb492dc.patch";
    postFetch = ''
      ${pkgs.buildPackages.patchutils}/bin/filterdiff --include='a/edison-api/*' --strip=1 "$out" > "$tmpfile"
      mv "$tmpfile" "$out"
    '';
    sha256 = "0yi5pz039lcm4pl9xnl6krqxyqq5rgb5b6m09w0sfy06x0n4x213";
  }) super.EdisonAPI;

  EdisonCore = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/robdockins/edison/pull/16/commits/8da6c0f7d8666766e2f0693425c347c0adb492dc.patch";
    postFetch = ''
      ${pkgs.buildPackages.patchutils}/bin/filterdiff --include='a/edison-core/*' --strip=1 "$out" > "$tmpfile"
      mv "$tmpfile" "$out"
    '';
    sha256 = "097wqn8hxsr50b9mhndg5pjim5jma2ym4ylpibakmmb5m98n17zp";
  }) super.EdisonCore;

  # Pick patch from 1.6.0 which allows compilation with doctest 0.18
  polysemy = appendPatches [
    (pkgs.fetchpatch {
      name = "allow-doctest-0.18.patch";
      url = "https://github.com/polysemy-research/polysemy/commit/dbcf851eb69395ce3143ecf2dd616dcad953a339.patch";
      sha256 = "1qf5pghc8p1glwaadkr95x12d74vhb98mg8dqwilyxbc6gq763w2";
    })
  ] super.polysemy;

  # 2021-12-26: Too strict bounds on doctest
  polysemy-plugin = doJailbreak super.polysemy-plugin;

  # Test suite requires running a database server. Testing is done upstream.
  hasql-notifications = dontCheck super.hasql-notifications;
  hasql-pool = dontCheck super.hasql-pool;

  # We jailbreak webify, as optparse-applicative evolved past the version bound
  # and the corresponding (and outdated) PR was not merged for a year.
  # https://github.com/ananthakumaran/webify/pull/27
  webify = doJailbreak super.webify;

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
  reflex-dom-core = doDistribute (unmarkBroken (dontCheck (doJailbreak super.reflex-dom-core)));

  # add unreleased commit fixing version constraint as a patch
  # Can be removed if https://github.com/lpeterse/haskell-utc/issues/8 is resolved
  utc = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/lpeterse/haskell-utc/commit/e4502c08591e80d411129bb7c0414539f6302aaf.diff";
    sha256 = "0v6kv1d4syjzgzc2s7a76c6k4vminlcq62n7jg3nn9xd00gwmmv7";
  }) super.utc;

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
  libsodium = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [self.buildHaskellPackages.c2hs];
  }) super.libsodium;

  # https://github.com/kowainik/policeman/issues/57
  policeman = doJailbreak super.policeman;

  # Too strict version bounds on haskell-gi
  gi-cairo-render = doJailbreak super.gi-cairo-render;
  gi-cairo-connector = doJailbreak super.gi-cairo-connector;

  svgcairo = appendPatches [
    # Remove when https://github.com/gtk2hs/svgcairo/pull/12 goes in.
    (pkgs.fetchpatch {
      url = "https://github.com/gtk2hs/svgcairo/commit/348c60b99c284557a522baaf47db69322a0a8b67.patch";
      sha256 = "0akhq6klmykvqd5wsbdfnnl309f80ds19zgq06sh1mmggi54dnf3";
    })
    # Remove when https://github.com/gtk2hs/svgcairo/pull/13 goes in.
    (pkgs.fetchpatch {
      url = "https://github.com/dalpd/svgcairo/commit/d1e0d7ae04c1edca83d5b782e464524cdda6ae85.patch";
      sha256 = "1pq9ld9z67zsxj8vqjf82qwckcp69lvvnrjb7wsyb5jc6jaj3q0a";
    })
  ] super.svgcairo;

  # Missing -Iinclude parameter to doc-tests (pull has been accepted, so should be resolved when 0.5.3 released)
  # https://github.com/lehins/massiv/pull/104
  massiv = dontCheck super.massiv;

  # Upstream PR: https://github.com/jkff/splot/pull/9
  splot = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/jkff/splot/commit/a6710b05470d25cb5373481cf1cfc1febd686407.patch";
    sha256 = "1c5ck2ibag2gcyag6rjivmlwdlp5k0dmr8nhk7wlkzq2vh7zgw63";
  }) super.splot;

  # Tests are broken because of missing files in hackage tarball.
  # https://github.com/jgm/commonmark-hs/issues/55
  commonmark-extensions = dontCheck super.commonmark-extensions;

  # Fails with encoding problems, likely needs locale data.
  # Test can be executed by adding which to testToolDepends and
  # $PWD/dist/build/haskeline-examples-Test to $PATH.
  haskeline_0_8_2 = dontCheck super.haskeline_0_8_2;

  # Tests for list-t, superbuffer, and stm-containers
  # depend on HTF and it is broken, 2020-08-23
  list-t = dontCheck super.list-t;
  superbuffer = dontCheck super.superbuffer;
  stm-containers = dontCheck super.stm-containers;

  # Fails with "supports custom headers"
  Spock-core = dontCheck super.Spock-core;

  # hasura packages need some extra care
  graphql-engine = overrideCabal (drv: {
    patches = [ ./patches/graphql-engine-mapkeys.patch ];
    doHaddock = false;
    version = "2.0.10";
  }) (super.graphql-engine.overrideScope (self: super: {
    immortal = self.immortal_0_2_2_1;
    resource-pool = self.hasura-resource-pool;
    ekg-core = self.hasura-ekg-core;
    ekg-json = self.hasura-ekg-json;
    hspec = dontCheck self.hspec_2_9_4;
    hspec-core = dontCheck self.hspec-core_2_9_4;
    hspec-discover = dontCheck super.hspec-discover_2_9_4;
    tasty-hspec = self.tasty-hspec_1_2;
  }));
  hasura-ekg-core = doJailbreak (super.hasura-ekg-core.overrideScope (self: super: {
    hspec = dontCheck self.hspec_2_9_4;
    hspec-core = dontCheck self.hspec-core_2_9_4;
    hspec-discover = dontCheck super.hspec-discover_2_9_4;
  }));
  hasura-ekg-json = super.hasura-ekg-json.overrideScope (self: super: {
    ekg-core = self.hasura-ekg-core;
    hspec = dontCheck self.hspec_2_9_4;
    hspec-core = dontCheck self.hspec-core_2_9_4;
    hspec-discover = dontCheck super.hspec-discover_2_9_4;
  });
  pg-client = overrideCabal (drv: {
    librarySystemDepends = with pkgs; [ postgresql krb5.dev openssl.dev ];
    # wants a running DB to check against
    doCheck = false;
  }) (super.pg-client.override {
    resource-pool = self.hasura-resource-pool;
  });

  # https://github.com/bos/statistics/issues/170
  statistics = dontCheck super.statistics;

  hcoord = overrideCabal (drv: {
    # Remove when https://github.com/danfran/hcoord/pull/8 is merged.
    patches = [
      (pkgs.fetchpatch {
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
    (drv: {
      buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/update-nix-fetchgit" --prefix 'PATH' ':' "${
          pkgs.lib.makeBinPath deps
        }"
      '';
    }) (addTestToolDepends deps super.update-nix-fetchgit));

  # Our quickcheck-instances is too old for the newer binary-instances, but
  # quickcheck-instances is only used in the tests of binary-instances.
  binary-instances = dontCheck super.binary-instances;

  # 2020-11-19: Checks nearly fixed, but still disabled because of flaky tests:
  # https://github.com/haskell/haskell-language-server/issues/610
  # https://github.com/haskell/haskell-language-server/issues/611
  haskell-language-server = dontCheck super.haskell-language-server;

  # 2021-05-08: Tests fail: https://github.com/haskell/haskell-language-server/issues/1809
  hls-eval-plugin = dontCheck super.hls-eval-plugin;

  # 2021-06-20: Tests fail: https://github.com/haskell/haskell-language-server/issues/1949
  hls-refine-imports-plugin = dontCheck super.hls-refine-imports-plugin;

  # 2021-09-14: Tests are broken because of undeterministic variable names
  hls-tactics-plugin = dontCheck super.hls-tactics-plugin;

  # 2021-11-20: https://github.com/haskell/haskell-language-server/pull/2373
  hls-explicit-imports-plugin = dontCheck super.hls-explicit-imports-plugin;

  # 2021-11-20: https://github.com/haskell/haskell-language-server/pull/2374
  hls-module-name-plugin = dontCheck super.hls-module-name-plugin;

  # 2021-11-20: Testsuite hangs.
  # https://github.com/haskell/haskell-language-server/issues/2375
  hls-pragmas-plugin = dontCheck super.hls-pragmas-plugin;

  # 2021-11-23: Too strict bounds on ghcide, pending new release
  hls-rename-plugin = assert super.hls-rename-plugin.version == "1.0.0.0";
    doJailbreak super.hls-rename-plugin;

  # 2021-03-21: Test hangs
  # https://github.com/haskell/haskell-language-server/issues/1562
  # 2021-11-13: Too strict upper bound on implicit-hie-cradle
  ghcide = doJailbreak (dontCheck super.ghcide);

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

  # https://github.com/obsidiansystems/dependent-sum/issues/55
  dependent-sum = doJailbreak super.dependent-sum;

  # 2020-11-18: https://github.com/srid/rib/issues/169
  # aeson bound out of sync
  rib-core = doJailbreak super.rib-core;

  # 2020-11-18: https://github.com/srid/neuron/issues/474
  # base upper bound is incompatible with ghc 8.10
  neuron = doJailbreak super.neuron;

  # 2020-04-16: https://github.com/reflex-frp/reflex/issues/449
  reflex = dontCheck (doJailbreak super.reflex);

  # 2020-11-19: jailbreaking because of pretty-simple bound out of date
  # https://github.com/kowainik/stan/issues/408
  # Tests disabled because of: https://github.com/kowainik/stan/issues/409
  stan = doJailbreak (dontCheck super.stan);

  # Due to tests restricting base in 0.8.0.0 release
  http-media = doJailbreak super.http-media;

  hinit = generateOptparseApplicativeCompletion "hi" (super.hinit.override { haskeline = self.haskeline_0_8_2; });

  # 2020-11-19: Jailbreaking until: https://github.com/snapframework/snap/pull/219
  snap = doJailbreak super.snap;

  # 2020-11-23: Jailbreaking until: https://github.com/michaelt/text-pipes/pull/29
  pipes-text = doJailbreak super.pipes-text;

  # 2020-11-23: https://github.com/Rufflewind/blas-hs/issues/8
  blas-hs = dontCheck super.blas-hs;

  # 2020-11-23: https://github.com/cdornan/fmt/issues/30
  fmt = dontCheck super.fmt;

  # 2020-11-27: Tests broken
  # Upstream issue: https://github.com/haskell-servant/servant-swagger/issues/129
  servant-swagger = dontCheck super.servant-swagger;

  hercules-ci-agent = generateOptparseApplicativeCompletion "hercules-ci-agent" super.hercules-ci-agent;

  hercules-ci-cli = pkgs.lib.pipe super.hercules-ci-cli [
    unmarkBroken
    (overrideCabal (drv: { hydraPlatforms = super.hercules-ci-cli.meta.platforms; }))
    # See hercules-ci-optparse-applicative in non-hackage-packages.nix.
    (addBuildDepend super.hercules-ci-optparse-applicative)
    (generateOptparseApplicativeCompletion "hci")
  ];

  # Readline uses Distribution.Simple from Cabal 2, in a way that is not
  # compatible with Cabal 3. No upstream repository found so far
  readline = appendPatch ./patches/readline-fix-for-cabal-3.patch super.readline;

  # 2020-12-05: this package requires a newer version of http-client,
  # but it still compiles with older version:
  # https://github.com/turion/essence-of-live-coding/pull/86
  essence-of-live-coding-warp = doJailbreak super.essence-of-live-coding-warp;

  # 2020-12-06: Restrictive upper bounds w.r.t. pandoc-types (https://github.com/owickstrom/pandoc-include-code/issues/27)
  pandoc-include-code = doJailbreak super.pandoc-include-code;

  # https://github.com/yesodweb/yesod/issues/1714
  yesod-core = dontCheck super.yesod-core;

  # Break out of overspecified constraint on QuickCheck.
  algebraic-graphs = dontCheck super.algebraic-graphs;
  attoparsec = doJailbreak super.attoparsec;      # https://github.com/haskell/attoparsec/pull/168
  cassava = doJailbreak super.cassava;
  filepath-bytestring = doJailbreak super.filepath-bytestring;
  ghc-source-gen = doJailbreak super.ghc-source-gen;
  haddock-library = doJailbreak super.haddock-library;
  HsYAML = doJailbreak super.HsYAML;
  http-api-data = doJailbreak super.http-api-data;
  lzma = doJailbreak super.lzma;
  psqueues = doJailbreak super.psqueues;

  # Break out of overspecified constraint on QuickCheck.
  # https://github.com/Gabriel439/Haskell-Nix-Derivation-Library/pull/10
  nix-derivation = doJailbreak super.nix-derivation;

  # Break out of overspecified constraint on QuickCheck.
  # Fixed by https://github.com/haskell-servant/servant/commit/08579ca0039410e04d6c36c975ddc20165819db6
  servant-client      = doJailbreak super.servant-client;
  servant-client-core = doJailbreak super.servant-client-core;

  # overly strict dependency on aeson
  # https://github.com/jaspervdj/profiteur/issues/33
  profiteur = doJailbreak super.profiteur;

  # Test suite has overly strict bounds on tasty.
  # https://github.com/input-output-hk/nothunks/issues/9
  nothunks = doJailbreak super.nothunks;

  # Allow building with recent versions of tasty.
  lukko = doJailbreak super.lukko;

  # Allow building with older versions of http-client.
  http-client-restricted = doJailbreak super.http-client-restricted;

  # 2020-02-11: https://github.com/ekmett/lens/issues/969
  # A change in vector 0.2.12 broke the lens doctests.
  # This is fixed on lens master. Remove this override on assert fail.
  lens = assert super.lens.version == "4.19.2"; doJailbreak (dontCheck super.lens);

  # Test suite fails, upstream not reachable for simple fix (not responsive on github)
  vivid-osc = dontCheck super.vivid-osc;
  vivid-supercollider = dontCheck super.vivid-supercollider;

  # Dependency to regex-tdfa-text can be removed for later regex-tdfa versions.
  # Fix protolude compilation error by applying patch from pull-request.
  # Override can be removed for the next release > 0.8.0.
  yarn2nix = overrideCabal (attrs: {
    jailbreak = true;
    # remove dependency on regex-tdfa-text
    # which has been merged into regex-tdfa
    postPatch = ''
      sed -i '/regex-tdfa-text/d' yarn2nix.cabal
    '';
    patches = (attrs.patches or []) ++ [
      # fix a compilation error related to protolude 0.3
      (pkgs.fetchpatch {
        url = "https://github.com/Profpatsch/yarn2nix/commit/ca78cf06226819b2e78cb6cdbc157d27afb41532.patch";
        sha256 = "1vkczwzhxilnp87apyb18nycn834y5nbw4yr1kpwlwhrhalvzw61";
        includes = [ "*/ResolveLockfile.hs" ];
      })
    ];
  }) (super.yarn2nix.override {
    regex-tdfa-text = null;
  });

  # cabal-install switched to build type simple in 3.2.0.0
  # as a result, the cabal(1) man page is no longer installed
  # automatically. Instead we need to use the `cabal man`
  # command which generates the man page on the fly and
  # install it to $out/share/man/man1 ourselves in this
  # override.
  # The commit that introduced this change:
  # https://github.com/haskell/cabal/commit/91ac075930c87712eeada4305727a4fa651726e7
  cabal-install = overrideCabal (old: {
    postInstall = old.postInstall + ''
      mkdir -p "$out/share/man/man1"
      "$out/bin/cabal" man --raw > "$out/share/man/man1/cabal.1"
    '';
  }) super.cabal-install;

  # while waiting for a new release: https://github.com/brendanhay/amazonka/pull/572
  amazonka = appendPatches [
    (pkgs.fetchpatch {
      stripLen = 1;
      url = "https://github.com/brendanhay/amazonka/commit/43ddd87b1ebd6af755b166e16336259ec025b337.patch";
      sha256 = "1x9l5xgvrh908di6whpavyp08cys11v3yn6rc21zw87xiyigdbi3";
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
    (pkgs.fetchpatch {
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
  language-ecmascript = doJailbreak super.language-ecmascript;

  # Too strict bounds on containers
  # https://github.com/jswebtools/language-ecmascript-analysis/issues/1
  language-ecmascript-analysis = doJailbreak super.language-ecmascript-analysis;

  # Too strict bounds on optparse-applicative
  # https://github.com/faylang/fay/pull/474
  fay = doJailbreak super.fay;

  # Too strict version bounds on cryptonite.
  # Issue reported upstream, no bug tracker url yet.
  darcs = doJailbreak super.darcs;

  # Too strict verion bounds on cryptonite and github.
  # PRs are merged, will be fixed next release or Hackage revision.
  nix-thunk = appendPatches [
    (pkgs.fetchpatch {
      url = "https://github.com/obsidiansystems/nix-thunk/commit/49d27a85dd39cd9413c99958c67e596756a502b5.patch";
      sha256 = "1p1n0123yrbdqyfk4kx3gq6bdv65l1bxgbsg51ckcwclg54xp2p5";
    })
    (pkgs.fetchpatch {
      url = "https://github.com/obsidiansystems/nix-thunk/commit/512867c651977265d5d8f456b538f7a364ec8a8b.patch";
      sha256 = "121yg26y4g28k8xv7y1j6c3pxm17vsjn3vi62kkc8g928c47yd02";
    })
  ] super.nix-thunk;

  # list `modbus` in librarySystemDepends, correct to `libmodbus`
  libmodbus = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.libmodbus ];
  }) super.libmodbus;

  # 2021-04-02: Outdated optparse-applicative bound is fixed but not realeased on upstream.
  trial-optparse-applicative = assert super.trial-optparse-applicative.version == "0.0.0.0"; doJailbreak super.trial-optparse-applicative;

  # 2021-04-02: Outdated optparse-applicative bound is fixed but not realeased on upstream.
  extensions = assert super.extensions.version == "0.0.0.1"; doJailbreak super.extensions;

  # 2021-04-02: iCalendar is basically unmaintained.
  # There are PRs for bumping the bounds: https://github.com/chrra/iCalendar/pull/46
  iCalendar = overrideCabal {
      # Overriding bounds behind a cabal flag
      preConfigure = ''substituteInPlace iCalendar.cabal --replace "network >=2.6 && <2.7" "network -any"'';
  } (doJailbreak super.iCalendar);

  # Apply patch from master relaxing the version bounds on tasty.
  # Can be removed at next release (current is 0.10.1.0).
  ginger = appendPatch
    (pkgs.fetchpatch {
      url = "https://github.com/tdammers/ginger/commit/bd8cb39c1853d4fb4f663c4c201884575906acea.patch";
      sha256 = "1rdy53k0384g52bnc59j1f0i13hr4lbnbksfsabr4av6zmw9wmzf";
    }) super.ginger;

  # Too strict version bounds on cryptonite
  # https://github.com/obsidiansystems/haveibeenpwned/issues/7
  haveibeenpwned = doJailbreak super.haveibeenpwned;

  # Too strict version bounds on ghc-events
  # https://github.com/haskell/ThreadScope/issues/118
  threadscope = doJailbreak super.threadscope;
  # https://github.com/mpickering/hs-speedscope/issues/16
  hs-speedscope = doJailbreak super.hs-speedscope;

  # Too strict version bounds on tasty
  # Can likely be removed next week (2021-04-09) when 1.1.1.1 is released.
  fused-effects = doJailbreak super.fused-effects;

  # Test suite doesn't support base16-bytestring >= 1.0
  # https://github.com/centromere/blake2/issues/6
  blake2 = dontCheck super.blake2;

  # Test suite doesn't support base16-bytestring >= 1.0
  # https://github.com/serokell/haskell-crypto/issues/25
  crypto-sodium = dontCheck super.crypto-sodium;

  # Too strict version bounds on a bunch of libraries:
  # https://github.com/smallhadroncollider/taskell/issues/100
  # May be possible to remove at the next release (1.11.0)
  taskell = doJailbreak super.taskell;

  # ghc-bignum is not buildable if none of the three backends
  # is explicitly enabled. We enable Native for now as it doesn't
  # depend on anything else as oppossed to GMP and FFI.
  # Apply patch which fixes a compilation failure we encountered.
  # Can be removed if the following issue is resolved / the patch
  # is merged and released:
  # * https://gitlab.haskell.org/ghc/ghc/-/issues/19638
  # * https://gitlab.haskell.org/ghc/ghc/-/merge_requests/5454
  ghc-bignum = overrideCabal (old: {
    configureFlags = (old.configureFlags or []) ++ [ "-f" "Native" ];
    patches = (old.patches or []) ++ [
      (pkgs.fetchpatch {
        url = "https://gitlab.haskell.org/ghc/ghc/-/commit/08d1588bf38d83140a86817a7a615db486357d4f.patch";
        sha256 = "1qx4r031y72px291vz38bng9sb23r8zb35s03v5hhawlmgzfzcb5";
        stripLen = 2;
      })
    ];
  }) super.ghc-bignum;

  # 2021-04-09: outdated base and alex-tools
  # PR pending https://github.com/glguy/language-lua/pull/6
  language-lua = doJailbreak super.language-lua;

  # 2021-04-09: too strict time bound
  # PR pending https://github.com/zohl/cereal-time/pull/2
  cereal-time = doJailbreak super.cereal-time;

  # 2021-04-16: too strict bounds on QuickCheck and tasty
  # https://github.com/hasufell/lzma-static/issues/1
  lzma-static = doJailbreak super.lzma-static;

  # Fix haddock errors: https://github.com/koalaman/shellcheck/issues/2216
  ShellCheck = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/koalaman/shellcheck/commit/9e60b3ea841bcaf48780bfcfc2e44aa6563a62de.patch";
    sha256 = "1vmg8mmmnph34x7y0mhkcd5nzky8f1rh10pird750xbkp9zlk099";
    excludes = ["test/buildtest"];
  }) super.ShellCheck;

  # Too strict version bounds on base:
  # https://github.com/obsidiansystems/database-id/issues/1
  database-id-class = doJailbreak super.database-id-class;

  cabal2nix-unstable = overrideCabal {
    passthru.updateScript = ../../../maintainers/scripts/haskell/update-cabal2nix-unstable.sh;
  } super.cabal2nix-unstable;

  # Too strict version bounds on base
  # https://github.com/gibiansky/IHaskell/issues/1217
  ihaskell-display = doJailbreak super.ihaskell-display;
  ihaskell-basic = doJailbreak super.ihaskell-basic;

  # Fixes too strict version bounds on regex libraries
  # Presumably to be removed at the next release
  yi-language = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/yi-editor/yi/commit/0d3bcb5ba4c237d57ce33a3dc39b63c56d890765.patch";
    sha256 = "0r4mzngs0x1akqpajzx7ssa9rax977fvj5ra8d3grfbpx6z0nm01";
    includes = [ "yi-language.cabal" ];
    stripLen = 2;
    extraPrefix = "";
  }) super.yi-language;

  # https://github.com/ghcjs/jsaddle/issues/123
  jsaddle = overrideCabal (drv: {
    # lift conditional version constraint on ref-tf
    postPatch = ''
      sed -i 's/ref-tf.*,/ref-tf,/' jsaddle.cabal
    '' + (drv.postPatch or "");
  }) super.jsaddle;

  # Tests need to lookup target triple x86_64-unknown-linux
  # https://github.com/llvm-hs/llvm-hs/issues/334
  llvm-hs = overrideCabal {
    doCheck = pkgs.stdenv.targetPlatform.system == "x86_64-linux";
  } super.llvm-hs;

  # * Fix build failure by picking patch from 8.5, we need
  #   this version of sbv for petrinizer
  # * Pin version of crackNum that still exposes its library
  sbv_7_13 = appendPatch (pkgs.fetchpatch {
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

  # 2021-05-09: Restrictive bound on hspec-golden. Dep removed in newer versions.
  tomland = assert super.tomland.version == "1.3.2.0"; doJailbreak super.tomland;

  # 2022-01-16 haskell-ci needs Cabal 3.6,
  haskell-ci = super.haskell-ci.overrideScope (self: super: {
    attoparsec = self.attoparsec_0_14_4;
    Cabal = self.Cabal_3_6_2_0;
  });

  # Build haskell-ci from git repository
  haskell-ci-unstable = overrideSrc rec {
    version = "0.14.1-${builtins.substring 0 7 src.rev}";
    src = pkgs.fetchFromGitHub {
      owner = "haskell-CI";
      repo = "haskell-ci";
      rev = "8311a999b8e8be3aa31f65f314def256aa2d5535";
      sha256 = "169jaqm4xs2almmvqsk567wayxs0g6kn0l5877c03hzr3d9ykrav";
    };
  } self.haskell-ci;

  Frames-streamly = super.Frames-streamly.override {
    relude = super.relude_1_0_0_1;
  };

  # 2021-05-09: compilation requires patches from master,
  # remove at next release (current is 0.1.0.4).
  large-hashable = overrideCabal (drv: {
    # fix line endings which are an issue all of a sudden for an unknown reason
    prePatch = ''
      find . -type f -print0 | xargs -0 ${pkgs.buildPackages.dos2unix}/bin/dos2unix
    '' + (drv.prePatch or "");
    # allow newer template haskell
    jailbreak = true;
    patches = [
      # Fix compilation of TH code for GHC >= 8.8
      (pkgs.fetchpatch {
        url = "https://github.com/factisresearch/large-hashable/commit/ee7afe4bd181cf15a324c7f4823f7a348e4a0e6b.patch";
        sha256 = "1ha77v0bc6prxacxhpdfgcsgw8348gvhl9y81smigifgjbinphxv";
        excludes = [
          ".travis.yml"
          "stack**"
        ];
      })
      # Fix cpp invocation
      (pkgs.fetchpatch {
        url = "https://github.com/factisresearch/large-hashable/commit/7b7c2ed6ac6e096478e8ee00160fa9d220df853a.patch";
        sha256 = "1sf9h3k8jbbgfshzrclaawlwx7k2frb09z2a64f93jhvk6ci6vgx";
      })
    ];
  }) super.large-hashable;

  # BSON defaults to requiring network instead of network-bsd which is
  # required nowadays: https://github.com/mongodb-haskell/bson/issues/26
  bson = appendConfigureFlag "-f-_old_network" (super.bson.override {
    network = self.network-bsd;
  });

  # 2021-05-14: Testsuite is failing.
  # https://github.com/kcsongor/generic-lens/issues/133
  generic-optics = dontCheck super.generic-optics;

  # 2021-05-19: Allow random 1.2.0
  # Remove at (presumably next release) which is > 1.3.1.0
  hashable = overrideCabal (drv: {
    patches = [
      (pkgs.fetchpatch {
        url = "https://github.com/haskell-unordered-containers/hashable/commit/78fa8fdb4f8bec5d221f34110d6afa0d0a00b5f9.patch";
        sha256 = "0bzgp9qf53zk4rzk73x5cf2kfqncvlmihcallpplaibpslzalyi4";
      })
    ] ++ (drv.patches or []);
    # fix line endings preventing patch from applying
    prePatch = ''
      ${pkgs.buildPackages.dos2unix}/bin/dos2unix hashable.cabal
    '' + (drv.prePatch or "");
  }) super.hashable;

  # Too strict bound on random
  # https://github.com/haskell-hvr/missingh/issues/56
  MissingH = doJailbreak super.MissingH;

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

  # unrestrict bounds for hashable and semigroups
  # https://github.com/HeinrichApfelmus/reactive-banana/issues/215
  reactive-banana = doJailbreak super.reactive-banana;

  # Too strict bounds on QuickCheck
  # https://github.com/muesli4/table-layout/issues/16
  table-layout = doJailbreak super.table-layout;

  # Bounds on profunctors are too strict
  # https://github.com/ConferOpenSource/composite/issues/50
  # Remove overrides when assert fails.
  composite-base = assert super.composite-base.version == "0.7.5.0";
    doJailbreak super.composite-base;
  composite-aeson = assert super.composite-aeson.version == "0.7.5.0";
    doJailbreak super.composite-aeson;

  # 2021-06-20: Outdated upper bounds
  # https://github.com/Porges/email-validate-hs/issues/58
  email-validate = doJailbreak super.email-validate;

  # 2021-10-02: Make optics 0.4 packages work together
  optics-th_0_4 = super.optics-th_0_4.override {
    optics-core = self.optics-core_0_4;
  };
  optics-extra_0_4 = super.optics-extra_0_4.override {
    optics-core = self.optics-core_0_4;
  };
  optics_0_4 = super.optics_0_4.override {
    optics-core = self.optics-core_0_4;
    optics-extra = self.optics-extra_0_4;
    optics-th = self.optics-th_0_4;
  };

  # https://github.com/plow-technologies/hspec-golden-aeson/issues/17
  hspec-golden-aeson_0_9_0_0 = dontCheck super.hspec-golden-aeson_0_9_0_0;

  # 2021-10-02: Doesn't compile with optics < 0.4
  # 2021-11-05: streamly-0.8.0 is required for libyaml-streamly and
  #             yaml-streamly, as these aren't leaf packages it's not really
  #             appropriate to override them themselves (although ghcup is
  #             currently the only consumer)
  # 2021-11-05: jailBreak the too tight upper bound on haskus-utils-variant
  ghcup = doJailbreak (super.ghcup.overrideScope (self: super: {
    hspec-golden-aeson = self.hspec-golden-aeson_0_9_0_0;
    optics = self.optics_0_4;
    streamly = doJailbreak self.streamly_0_8_1_1;
    Cabal = self.Cabal_3_6_2_0;
    libyaml-streamly = markUnbroken super.libyaml-streamly;
  }));

  # Break out of "Cabal < 3.2" constraint.
  stylish-haskell = doJailbreak super.stylish-haskell;

  # To strict bound on hspec
  # https://github.com/dagit/zenc/issues/5
  zenc = doJailbreak super.zenc;

  # Indeterministic tests
  # Fixed on upstream: https://github.com/softwarefactory-project/matrix-client-haskell/commit/4ca4963cfd06379d9bdce49742af854aed6a0d37
  matrix-client = dontCheck super.matrix-client;

  # Release 1.0.0.0 added version bounds (was unrestricted before),
  # but with too strict lower bounds for our lts-18.
  graphql = assert pkgs.lib.versionOlder self.parser-combinators.version "1.3.0";
    assert pkgs.lib.versionOlder self.hspec.version "2.8.2";
    doJailbreak super.graphql;

  # https://github.com/ajscholl/basic-cpuid/pull/1
  basic-cpuid = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/ajscholl/basic-cpuid/commit/2f2bd7a7b53103fb0cf26883f094db9d7659887c.patch";
    sha256 = "0l15ccfdys100jf50s9rr4p0d0ikn53bkh7a9qlk9i0y0z5jc6x1";
  }) super.basic-cpuid;

  # Needs Cabal >= 3.4
  chs-cabal = super.chs-cabal.override {
    Cabal = self.Cabal_3_6_2_0;
  };

  # 2021-08-18: streamly-posix was released with hspec 2.8.2, but it works with older versions too.
  streamly-posix = doJailbreak super.streamly-posix;

  # 2021-09-13: hls 1.6 needs a newer lsp than stackage-lts. (lsp >= 1.2.0.1)
  # (hls is nearly the only consumer, but consists of 18 packages, so we bump lsp globally.)
  lsp = doDistribute self.lsp_1_4_0_0;
  lsp-types = doDistribute self.lsp-types_1_4_0_1;
  # Not running the "example" test because it requires a binary from lsps test
  # suite which is not part of the output of lsp.
  lsp-test = doDistribute (overrideCabal (old: { testTarget = "tests func-test"; }) self.lsp-test_0_14_0_2);

  # 2021-09-14: Tests are flaky.
  hls-splice-plugin = dontCheck super.hls-splice-plugin;

  # 2021-09-18: https://github.com/haskell/haskell-language-server/issues/2205
  hls-stylish-haskell-plugin = doJailbreak super.hls-stylish-haskell-plugin;

  # 2021-09-29: unnecessary lower bound on generic-lens
  hw-ip = assert pkgs.lib.versionOlder self.generic-lens.version "2.2.0.0";
    doJailbreak super.hw-ip;
  hw-eliasfano = assert pkgs.lib.versionOlder self.generic-lens.version "2.2.0.0";
    doJailbreak super.hw-eliasfano;
  hw-xml = assert pkgs.lib.versionOlder self.generic-lens.version "2.2.0.0";
    doJailbreak super.hw-xml;

  # Needs network >= 3.1.2
  quic = super.quic.overrideScope (self: super: {
    network = self.network_3_1_2_7;
  });

  http3 = super.http3.overrideScope (self: super: {
    network = self.network_3_1_2_7;
  });

  # Fixes https://github.com/NixOS/nixpkgs/issues/140613
  # https://github.com/recursion-schemes/recursion-schemes/issues/128
  recursion-schemes = appendPatch ./patches/recursion-schemes-128.patch super.recursion-schemes;

  # Fix from https://github.com/brendanhay/gogol/pull/144 which has seen no release
  # Can't use fetchpatch as it required tweaking the line endings as the .cabal
  # file revision on hackage was gifted CRLF line endings
  gogol-core = appendPatch ./patches/gogol-core-144.patch super.gogol-core;

  # Jailbreak isn't sufficient, but this is ok as it's a leaf package.
  hadolint = overrideCabal (drv: {
    # Test suite depends on ordering of unordered-containers returned values
    # which was upgraded in LTS 18.19
    # https://github.com/hadolint/hadolint/issues/753
    testFlags = [
      "--skip" "/Hadolint.Formatter.Sarif/Formatter: Sarif/print empty results/"
    ] ++ drv.testFlags or [];
  }) (super.hadolint.overrideScope (self: super: {
    language-docker = self.language-docker_10_4_0;
    hspec = dontCheck self.hspec_2_9_4;
    hspec-core = dontCheck self.hspec-core_2_9_4;
    hspec-discover = dontCheck self.hspec-discover_2_9_4;
    colourista = doJailbreak super.colourista;
  }));

  # These should be updated in lockstep
  hledger_1_24_1 = super.hledger_1_24_1.override {
    hledger-lib = self.hledger-lib_1_24_1;
  };

  # Needs brick > 0.64
  nix-tree = super.nix-tree.override {
    brick = self.brick_0_67;
  };

  # build newer version for `pkgs.shellcheck`
  ShellCheck_0_8_0 = doDistribute super.ShellCheck_0_8_0;

  # test suite requires stack to run, https://github.com/dino-/photoname/issues/24
  photoname = dontCheck super.photoname;

  # Upgrade of unordered-containers in Stackage causes ordering-sensitive test to fail
  # https://github.com/chrisdone/lucid/issues/123
  # https://github.com/commercialhaskell/stackage/issues/6366
  lucid = assert super.lucid.version == "2.9.12.1"; overrideCabal (drv: {
    testFlags = [
      "--skip" "/attributes-with/mixed/"
    ] ++ drv.testFlags or [];
  }) super.lucid;
  # Basically the entire doctest suite of swagger2 fails for the same reason
  swagger2 = assert super.swagger2.version == "2.6"; overrideCabal (drv: {
    testTarget = "spec";
  }) super.swagger2;
  # https://github.com/kapralVV/Unique/issues/9
  Unique = assert super.Unique.version == "0.4.7.9"; overrideCabal (drv: {
    testFlags = [
      "--skip" "/Data.List.UniqueUnsorted.removeDuplicates/removeDuplicates: simple test/"
      "--skip" "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/unique: simple test/"
      "--skip" "/Data.List.UniqueUnsorted.repeatedBy,repeated,unique/repeatedBy: simple test/"
    ] ++ drv.testFlags or [];
  }) super.Unique;
  # https://github.com/AndrewRademacher/aeson-casing/issues/8
  aeson-casing = assert super.aeson-casing.version == "0.2.0.0"; overrideCabal (drv: {
    testFlags = [
      "-p" "! /encode train/"
    ] ++ drv.testFlags or [];
  }) super.aeson-casing;
  # https://github.com/Soostone/katip/issues/134
  katip = assert super.katip.version == "0.8.7.0"; overrideCabal (drv: {
    testFlags = [
      "-p" "!/Text-golden/&&!/respects payloadKeys for each constituent payload/"
    ] ++ drv.testFlags or [];
  }) super.katip;
  # 2020-11-19: Jailbreaking until: https://github.com/snapframework/heist/pull/124
  # 2021-12-22: https://github.com/snapframework/heist/issues/131
  heist = assert super.heist.version == "1.1.0.1"; overrideCabal (drv: {
    testFlags = [
      "-t" "!*/compiled/ns*"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.heist);
  # https://github.com/hercules-ci/hercules-ci-agent/issues/352
  hercules-ci-api-agent = assert super.hercules-ci-api-agent.version == "0.4.1.0"; overrideCabal (drv: {
    testFlags = [
      "--skip" "/hercules-ci-api/Hercules.API.Agent.Evaluate.EvaluateEvent.DerivationInfo/DerivationInfo/ToJSON/encodes v2 correctly/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.hercules-ci-api-agent);
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
  # https://gitlab.com/k0001/xmlbf/-/issues/32
  xmlbf = overrideCabal (drv: {
    testFlags = [
      "-p" "!/xml: <x b=\"\" a=\"y\"><\\/x>/&&!/xml: <x b=\"z\" a=\"y\"><\\/x>/"
    ] ++ drv.testFlags or [];
  }) super.xmlbf;
  # https://github.com/ssadler/aeson-quick/issues/3
  aeson-quick = overrideCabal (drv: {
    testFlags = [
      "-p" "!/asLens.set/&&!/complex.set/&&!/multipleKeys.set/"
    ] ++ drv.testFlags or [];
  }) super.aeson-quick;
  # https://github.com/minio/minio-hs/issues/165
  minio-hs = overrideCabal (drv: {
    testFlags = [
      "-p" "!/Test mkSelectRequest/"
    ] ++ drv.testFlags or [];
  }) super.minio-hs;

  # golden files expect an old version of hpack, so tests fail intermittently
  # TODO: maybe disable golden test suite altogether? this will happen again as
  #       hpack emits its version into the generated files…
  hpack-dhall = assert super.hpack-dhall.version == "0.5.3"; dontCheck super.hpack-dhall;

  # Invalid CPP in test suite: https://github.com/cdornan/memory-cd/issues/1
  memory-cd = dontCheck super.memory-cd;

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

  # Test suite fails to compile
  # https://github.com/kuribas/mfsolve/issues/8
  mfsolve = dontCheck super.mfsolve;

  hie-bios = appendPatches [
    # Accounts for a breaking change in GHC 9.0.2 via CPP
    (pkgs.fetchpatch {
      name = "hie-bios-ghc-9.0.2-compat.patch";
      url = "https://github.com/haskell/hie-bios/commit/da0cb23384cc6e9b393792f8f25a3c174a4edafa.patch";
      sha256 = "1qj67s93h6pxvdapw1sxy6izwp5y8vjaw67gw3lsnj8gs14fqq4h";
    })
  ] super.hie-bios;

} // import ./configuration-tensorflow.nix {inherit pkgs haskellLib;} self super
