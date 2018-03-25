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

  # hackage-security's test suite does not compile with Cabal 2.x.
  # See https://github.com/haskell/hackage-security/issues/188.
  hackage-security = dontCheck super.hackage-security;

  # Link statically to avoid runtime dependency on GHC.
  jailbreak-cabal = disableSharedExecutables super.jailbreak-cabal;

  # enable using a local hoogle with extra packagages in the database
  # nix-shell -p "haskellPackages.hoogleLocal { packages = with haskellPackages; [ mtl lens ]; }"
  # $ hoogle server
  hoogleLocal = { packages ? [] }: self.callPackage ./hoogle.nix { inherit packages; };

  # Break infinite recursions.
  clock = dontCheck super.clock;
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec = super.hspec.override { stringbuilder = dontCheck self.stringbuilder; };
  hspec-core = super.hspec-core.override { silently = dontCheck self.silently; temporary = dontCheck self.temporary; };

  hspec-expectations = dontCheck super.hspec-expectations;
  HTTP = dontCheck super.HTTP;
  http-streams = dontCheck super.http-streams;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  vector-builder = dontCheck super.vector-builder;

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # Use the default version of mysql to build this package (which is actually mariadb).
  # test phase requires networking
  mysql = dontCheck (super.mysql.override { mysql = pkgs.mysql.connector-c; });

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;
  mysql-haskell = dontCheck super.mysql-haskell;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # The Hackage tarball is purposefully broken, because it's not intended to be, like, useful.
  # https://git-annex.branchable.com/bugs/bash_completion_file_is_missing_in_the_6.20160527_tarball_on_hackage/
  git-annex = ((overrideCabal super.git-annex (drv: {
    src = pkgs.fetchgit {
      name = "git-annex-${drv.version}-src";
      url = "git://git-annex.branchable.com/";
      rev = "refs/tags/" + drv.version;
      sha256 = "0qi5wpsvw6g8xrri1pr0401370acs5sg75myr0h5mjad6pvqc667";
    };
  })).overrideScope (self: super: {
    aws = dontCheck (self.aws_0_18);
    conduit = self.conduit_1_2_13_1;
    conduit-extra = self.conduit-extra_1_2_3_2;
    cryptonite-conduit = dontCheck super.cryptonite-conduit;  # test suite does not compile with old versions used here
    html-conduit = self.html-conduit_1_2_1_2;
    http-conduit = self.http-conduit_2_2_4;
    persistent = self.persistent_2_7_3_1;
    persistent-sqlite = self.persistent-sqlite_2_6_4;
    resourcet = self.resourcet_1_1_11;
    xml-conduit = self.xml-conduit_1_7_1_2;
    yesod = self.yesod_1_4_5;
    yesod-core = self.yesod-core_1_4_37_3;
    yesod-form = self.yesod-form_1_4_16;
    yesod-persistent = self.yesod-persistent_1_4_3;
    yesod-static = self.yesod-static_1_5_3_1;
    yesod-test = self.yesod-test_1_5_9_1;
  })).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  # Fix test trying to access /home directory
  shell-conduit = (overrideCabal super.shell-conduit (drv: {
    postPatch = "sed -i s/home/tmp/ test/Spec.hs";

    # the tests for shell-conduit on Darwin illegitimatey assume non-GNU echo
    # see: https://github.com/psibi/shell-conduit/issues/12
    doCheck = !pkgs.stdenv.isDarwin;
  })).overrideScope (self: super: {
    # shell-conduit doesn't build with conduit 1.3
    # see https://github.com/psibi/shell-conduit/issues/15
    conduit = self.conduit_1_2_13_1;
    conduit-extra = self.conduit-extra_1_2_3_2;
    resourcet = self.resourcet_1_1_11;
  });

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  # Test suite doesn't terminate
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

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # sse2 flag due to https://github.com/haskell/vector/issues/47.
  # dontCheck due to https://github.com/haskell/vector/issues/138
  vector = dontCheck (if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector);

  # Fix Darwin build.
  halive = if pkgs.stdenv.isDarwin
    then addBuildDepend super.halive pkgs.darwin.apple_sdk.frameworks.AppKit
    else super.halive;

  # Hakyll's tests are broken on Darwin (3 failures); and they require util-linux
  hakyll = if pkgs.stdenv.isDarwin
    then dontCheck (overrideCabal super.hakyll (drv: {
      testToolDepends = [];
    }))
    # https://github.com/jaspervdj/hakyll/issues/491
    else dontCheck super.hakyll;

  double-conversion = if !pkgs.stdenv.isDarwin
    then super.double-conversion
    else addExtraLibrary super.double-conversion pkgs.libcxx;

  inline-c-cpp = if !pkgs.stdenv.isDarwin
    then super.inline-c-cpp
    else addExtraLibrary (overrideCabal super.inline-c-cpp (drv:
      {
        postPatch = ''
          substituteInPlace inline-c-cpp.cabal --replace stdc++ c++
        '';
      })) pkgs.libcxx;

  inline-java = addBuildDepend super.inline-java pkgs.jdk;

  # https://github.com/mvoidex/hsdev/issues/11
  hsdev = dontHaddock super.hsdev;

  # Upstream notified by e-mail.
  permutation = dontCheck super.permutation;

  # https://github.com/jputcu/serialport/issues/25
  serialport = dontCheck super.serialport;

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


  # Fails for non-obvious reasons while attempting to use doctest.
  search = dontCheck super.search;

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
  hmatrix-tests = dontCheck super.hmatrix-tests;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  hsexif = dontCheck super.hsexif;
  hspec-server = dontCheck super.hspec-server;
  HTF = dontCheck super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  ihaskell = dontCheck super.ihaskell;
  influxdb = dontCheck super.influxdb;
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-slice = dontCheck super.language-slice;
  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  lucid = dontCheck super.lucid; #https://github.com/chrisdone/lucid/issues/25
  lvmrun = disableHardening (dontCheck super.lvmrun) ["format"];
  memcache = dontCheck super.memcache;
  MemoTrie = dontHaddock (dontCheck super.MemoTrie);
  metrics = dontCheck super.metrics;
  milena = dontCheck super.milena;
  nats-queue = dontCheck super.nats-queue;
  netpbm = dontCheck super.netpbm;
  network = dontCheck super.network;
  network-dbus = dontCheck super.network-dbus;
  notcpp = dontCheck super.notcpp;
  ntp-control = dontCheck super.ntp-control;
  numerals = dontCheck super.numerals;
  opaleye = dontCheck super.opaleye;
  openpgp = dontCheck super.openpgp;
  optional = dontCheck super.optional;
  orgmode-parse = dontCheck super.orgmode-parse;
  os-release = dontCheck super.os-release;
  persistent-redis = dontCheck super.persistent-redis;
  pipes-extra = dontCheck super.pipes-extra;
  pipes-websockets = dontCheck super.pipes-websockets;
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
  scp-streams = dontCheck super.scp-streams;
  sdl2-ttf = dontCheck super.sdl2-ttf; # as of version 0.2.1, the test suite requires user intervention
  separated = dontCheck super.separated;
  shadowsocks = dontCheck super.shadowsocks;
  shake-language-c = dontCheck super.shake-language-c;
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
  snap-core = dontCheck super.snap-core;
  sourcemap = dontCheck super.sourcemap;

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
  bytestring-strict-builder = dontCheck super.bytestring-strict-builder;
  bytestring-tree-builder = dontCheck super.bytestring-tree-builder;

  # https://github.com/ndmitchell/shake/issues/206
  # https://github.com/ndmitchell/shake/issues/267
  shake = overrideCabal super.shake (drv: { doCheck = !pkgs.stdenv.isDarwin && false; });

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

  # Depends on itself for testing
  doctest-discover = addBuildTool super.doctest-discover (dontCheck super.doctest-discover);
  tasty-discover = addBuildTool super.tasty-discover (dontCheck super.tasty-discover);

  # generic-deriving bound is too tight
  aeson = doJailbreak super.aeson;

  # Won't compile with recent versions of QuickCheck.
  inilist = dontCheck super.inilist;
  MissingH = dontCheck super.MissingH;

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # https://github.com/hvr/token-bucket/issues/3
  token-bucket = dontCheck super.token-bucket;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # https://github.com/haskell-hvr/lzma/issues/8
  lzma = appendPatch super.lzma ./patches/lzma-tests.patch;

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
    buildTools = with pkgs; [ gettext perl help2man intltool ];
    doCheck = false; # https://github.com/wjt/bustle/issues/6
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
  structured-haskell-mode = (overrideCabal super.structured-haskell-mode (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "chrisdone";
      repo = "structured-haskell-mode";
      rev = "bd08a0b2297667e2ac7896e3b480033ae5721d4d";
      sha256 = "14rl739z19ns31h9fj48sx9ppca4g4mqkc7ccpacagwwf55m259c";
    };
    version = "20170523-git";
    editedCabalFile = null;
    # Statically linked Haskell libraries make the tool start-up much faster,
    # which is important for use in Emacs.
    enableSharedExecutables = false;
    # Make elisp files available at a location where people expect it. We
    # cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$data/share/${self.ghc.name}/"*"/${drv.pname}-"*"/elisp" )
      mkdir -p $data/share/emacs
      ln -s $lispdir $data/share/emacs/site-lisp
    '';
  })).override {
    haskell-src-exts = self.haskell-src-exts_1_19_1;
  };

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

  # Need newer versions of their dependencies than the ones we have in LTS-11.x.
  cabal2nix = super.cabal2nix.overrideScope (self: super: { hpack = self.hpack_0_28_2; hackage-db = self.hackage-db_2_0_1; });

  # https://github.com/bos/configurator/issues/22
  configurator = dontCheck super.configurator;

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/bos/bloomfilter/issues/7
  bloomfilter = appendPatch super.bloomfilter ./patches/bloomfilter-fix-on-32bit.patch;

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # https://github.com/goldfirere/singletons/issues/122
  singletons = dontCheck super.singletons;

  # https://github.com/fpco/stackage/issues/838
  cryptonite = dontCheck super.cryptonite;

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/deech/fltkhs/issues/16
  # linking fails because the build doesn't pull in the libGLU_combined libraries
  fltkhs = markBroken super.fltkhs;
  fltkhs-fluid-examples = dontDistribute super.fltkhs-fluid-examples;

  # We get lots of strange compiler errors during the test suite run.
  jsaddle = dontCheck super.jsaddle;

  # Tools that use gtk2hs-buildtools now depend on them in a custom-setup stanza
  cairo = addBuildTool super.cairo self.gtk2hs-buildtools;
  pango = disableHardening (addBuildTool super.pango self.gtk2hs-buildtools) ["fortify"];
  gtk =
    if pkgs.stdenv.isDarwin
    then appendConfigureFlag super.gtk "-fhave-quartz-gtk"
    else super.gtk;

  # vaultenv is not available from Hackage.
  vaultenv = self.callPackage ../tools/haskell/vaultenv { };

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal super.stunclient (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  });

  # The standard libraries are compiled separately
  idris = doJailbreak (dontCheck super.idris);

  # https://github.com/bos/math-functions/issues/25
  math-functions = dontCheck super.math-functions;

  # broken test suite
  servant-server = dontCheck super.servant-server;

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
          sha256 = "0bwd5dy3crn08dijn06dr3mdsww98kqxfp8v5mvrdws5glvcxdsg";
        }}/doc";
        buildInputs = with pkgs.pythonPackages; [ sphinx recommonmark sphinx_rtd_theme ];
        makeFlags = "html";
        installPhase = ''
          mv _build/html $out
        '';
      };
    in overrideCabal super.servant (old: {
      postInstall = old.postInstall or "" + ''
        ln -s ${docs} $doc/share/doc/servant
      '';
    });

  # Glob == 0.7.x
  servant-auth = doJailbreak super.servant-auth;

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

  # https://github.com/aslatter/parsec/issues/68
  parsec = doJailbreak super.parsec;

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
  fgl = doJailbreak super.fgl;
  fgl-arbitrary = doJailbreak super.fgl-arbitrary;

  # The tests spuriously fail
  libmpd = dontCheck super.libmpd;

  # https://github.com/dan-t/cabal-lenses/issues/6
  cabal-lenses = doJailbreak super.cabal-lenses;

  # https://github.com/fizruk/http-api-data/issues/49
  http-api-data = dontCheck super.http-api-data;

  # https://github.com/snoyberg/yaml/issues/106
  yaml = disableCabalFlag super.yaml "system-libyaml";

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

  # cryptol-2.5.0 doesn't want happy 1.19.6+.
  cryptol = super.cryptol.override { happy = self.happy_1_19_5; };

  # Tests try to invoke external process and process == 1.4
  grakn = dontCheck (doJailbreak super.grakn);

  # test suite requires git and does a bunch of git operations
  # doJailbreak because of hardcoded time, seems to be fixed upstream
  restless-git = dontCheck (doJailbreak super.restless-git);

  # Depends on broken fluid.
  fluid-idl-http-client = markBroken super.fluid-idl-http-client;
  fluid-idl-scotty = markBroken super.fluid-idl-scotty;

  # missing dependencies: Glob >=0.7.14 && <0.8, data-fix ==0.0.4
  stack2nix = doJailbreak super.stack2nix;

  # Hacks to work around https://github.com/haskell/c2hs/issues/192.
  c2hs = (overrideCabal super.c2hs {
    version = "0.26.2-28-g8b79823";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "deech";
      repo = "c2hs";
      rev = "8b79823c32e234c161baec67fdf7907952ca62b8";
      sha256 = "0hyrcyssclkdfcw2kgcark8jl869snwnbrhr9k0a9sbpk72wp7nz";
    };
  });

  # Needs pginit to function and pgrep to verify.
  tmp-postgres = overrideCabal super.tmp-postgres (drv: {
    libraryToolDepends = drv.libraryToolDepends or [] ++ [pkgs.postgresql];
    testToolDepends = drv.testToolDepends or [] ++ [pkgs.procps];
  });

  # https://github.com/fpco/stackage/issues/3126
  stack = doJailbreak super.stack;

  # These packages depend on each other, forming an infinite loop.
  scalendar = markBroken (super.scalendar.override { SCalendar = null; });
  SCalendar = markBroken (super.SCalendar.override { scalendar = null; });

  # Needs QuickCheck <2.10, which we don't have.
  edit-distance = doJailbreak super.edit-distance;
  blaze-markup = doJailbreak super.blaze-markup;
  blaze-html = doJailbreak super.blaze-html;
  attoparsec = dontCheck super.attoparsec;      # 1 out of 67 tests fails
  int-cast = doJailbreak super.int-cast;
  nix-derivation = doJailbreak super.nix-derivation;
  graphviz = doJailbreak super.graphviz;

  # Needs QuickCheck <2.10, HUnit <1.6 and base <4.10
  pointfree = doJailbreak super.pointfree;

  # Needs time<1.7
  taffybar = doJailbreak super.taffybar;

  # Needs tasty-quickcheck ==0.8.*, which we don't have.
  cryptohash-sha256 = doJailbreak super.cryptohash-sha256;
  cryptohash-sha1 = doJailbreak super.cryptohash-sha1;
  cryptohash-md5 = doJailbreak super.cryptohash-md5;
  text-short = doJailbreak super.text-short;
  gitHUD = dontCheck super.gitHUD;

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

  # Missing FlexibleContexts in testsuite
  # https://github.com/EduardSergeev/monad-memo/pull/4
  monad-memo =
    let patch = pkgs.fetchpatch
          { url = https://github.com/EduardSergeev/monad-memo/pull/4.patch;
            sha256 = "14mf9940arilg6v54w9bc4z567rfbmm7gknsklv965fr7jpinxxj";
          };
    in appendPatch super.monad-memo patch;

  # https://github.com/alphaHeavy/protobuf/issues/34
  protobuf = dontCheck super.protobuf;

  # https://github.com/bos/text-icu/issues/32
  text-icu = dontCheck super.text-icu;

  # https://github.com/strake/lenz.hs/issues/2
  lenz =
    let patch = pkgs.fetchpatch
          { url = https://github.com/strake/lenz.hs/commit/4b9b79104759b9c6b24484455e1eb0d962eb3cff.patch;
            sha256 = "02i0w9i55a4r251wgjzl5vbk6m2qhilwl7bfp5jwmf22z66sglyn";
          };
    in overrideCabal super.lenz (drv:
      { patches = (drv.patches or []) ++ [ patch ];
        editedCabalFile = null;
      });

  # https://github.com/haskell/cabal/issues/4969
  haddock-library_1_4_4 = dontHaddock super.haddock-library_1_4_4;
  haddock-api = super.haddock-api.override { haddock-library = self.haddock-library_1_4_4; };

  # Jailbreak "unix-compat >=0.1.2 && <0.5".
  darcs = overrideCabal super.darcs (drv: { preConfigure = "sed -i -e 's/unix-compat .*,/unix-compat,/' -e 's/fgl .*,/fgl,/' darcs.cabal"; });

  # https://github.com/Twinside/Juicy.Pixels/issues/149
  JuicyPixels = dontHaddock super.JuicyPixels;

  # aarch64 and armv7l fixes.
  happy = if (pkgs.stdenv.hostPlatform.isArm || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.happy else super.happy; # Similar to https://ghc.haskell.org/trac/ghc/ticket/13062
  hashable = if (pkgs.stdenv.hostPlatform.isArm || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.hashable else super.hashable; # https://github.com/tibbe/hashable/issues/95
  servant-docs = if (pkgs.stdenv.hostPlatform.isArm || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.servant-docs else super.servant-docs;
  servant-swagger = if (pkgs.stdenv.hostPlatform.isArm || pkgs.stdenv.hostPlatform.isAarch64) then dontCheck super.servant-swagger else super.servant-swagger;
  swagger2 = if (pkgs.stdenv.hostPlatform.isArm || pkgs.stdenv.hostPlatform.isAarch64) then dontHaddock (dontCheck super.swagger2) else super.swagger2;

  # Tries to read a file it is not allowed to in the test suite
  load-env = dontCheck super.load-env;

  # Add support for https://github.com/haskell-hvr/multi-ghc-travis.
  multi-ghc-travis = self.callPackage ../tools/haskell/multi-ghc-travis {};

  # https://github.com/yesodweb/Shelly.hs/issues/162
  shelly = dontCheck super.shelly;

  # Support ansi-terminal 0.7.x.
  cabal-plan = appendPatch super.cabal-plan (pkgs.fetchpatch {
    url = "https://github.com/haskell-hvr/cabal-plan/pull/16.patch";
    sha256 = "0i889zs46wn09d7iqdy99201zaqxb175cfs8jz2zi3mv4ywx3a0l";
  });

  # Copy hledger man pages from data directory into the proper place. This code
  # should be moved into the cabal2nix generator.
  hledger = overrideCabal super.hledger (drv: {
    postInstall = ''
      for i in $(seq 1 9); do
        for j in $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.$i $data/share/${self.ghc.name}/*-${self.ghc.name}/*/.otherdocs/*.$i; do
          mkdir -p $out/share/man/man$i
          cp $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.info $out/share/info/
    '';
  });
  hledger-ui = overrideCabal super.hledger-ui (drv: {
    postInstall = ''
      for i in $(seq 1 9); do
        for j in $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.$i $data/share/${self.ghc.name}/*-${self.ghc.name}/*/.otherdocs/*.$i; do
          mkdir -p $out/share/man/man$i
          cp $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.info $out/share/info/
    '';
  });
  hledger-web = overrideCabal super.hledger-web (drv: {
    postInstall = ''
      for i in $(seq 1 9); do
        for j in $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.$i $data/share/${self.ghc.name}/*-${self.ghc.name}/*/.otherdocs/*.$i; do
          mkdir -p $out/share/man/man$i
          cp $j $out/share/man/man$i/
        done
      done
      mkdir -p $out/share/info
      cp $data/share/${self.ghc.name}/*-${self.ghc.name}/*/*.info $out/share/info/
    '';
  });

  # https://github.com/nick8325/twee/pull/1
  twee-lib = dontHaddock super.twee-lib;

  # Needs older hlint
  hpio = dontCheck super.hpio;

  # https://github.com/fpco/inline-c/issues/72
  inline-c = dontCheck super.inline-c;

  # https://github.com/GaloisInc/pure-zlib/issues/6
  pure-zlib = doJailbreak super.pure-zlib;

}
