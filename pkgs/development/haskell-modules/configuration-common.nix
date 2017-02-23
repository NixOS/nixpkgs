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
{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some Hackage packages reference this attribute, which exists only in the
  # GHCJS package set. We provide a dummy version here to fix potential
  # evaluation errors.
  ghcjs-base = null;

  # Some packages need a non-core version of Cabal.
  cabal-install = super.cabal-install.overrideScope (self: super: { Cabal = self.Cabal_1_24_2_0; });

  # Link statically to avoid runtime dependency on GHC.
  jailbreak-cabal = (disableSharedExecutables super.jailbreak-cabal).override { Cabal = self.Cabal_1_20_0_4; };

  # enable using a local hoogle with extra packagages in the database
  # nix-shell -p "haskellPackages.hoogleLocal (with haskellPackages; [ mtl lens ])"
  # $ hoogle server
  hoogleLocal = { packages ? [] }: self.callPackage ./hoogle.nix { inherit packages; };

  # Break infinite recursions.
  clock = dontCheck super.clock;
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec-expectations = dontCheck super.hspec-expectations;
  hspec = super.hspec.override { stringbuilder = dontCheck super.stringbuilder; };
  HTTP = dontCheck super.HTTP;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  http-streams = dontCheck super.http-streams;

  # segfault due to missing return: https://github.com/haskell/c2hs/pull/184
  c2hs = dontCheck super.c2hs;

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # Use the default version of mysql to build this package (which is actually mariadb).
  # test phase requires networking
  mysql = dontCheck (super.mysql.override { mysql = pkgs.mysql.lib; });

  # check requires mysql server
  mysql-simple = dontCheck super.mysql-simple;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # The Hackage tarball is purposefully broken. Mr. Hess wants people to build
  # his package from the Git repo because that is, like, better!
  git-annex = ((overrideCabal super.git-annex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "joeyh";
      repo = "git-annex";
      sha256 = "0f79i2i1cr8j02vc4ganw92prbkv9ca1yl9jgkny0rxf28wdlc6v";
      rev = drv.version;
    };
  }))).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

  hzk = dontCheck super.hzk;
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
  acme-one = dontHaddock super.acme-one;
  attoparsec-conduit = dontHaddock super.attoparsec-conduit;
  base-noprelude = dontHaddock super.base-noprelude;
  blaze-builder-conduit = dontHaddock super.blaze-builder-conduit;
  BNFC-meta = dontHaddock super.BNFC-meta;
  bytestring-progress = dontHaddock super.bytestring-progress;
  comonads-fd = dontHaddock super.comonads-fd;
  comonad-transformers = dontHaddock super.comonad-transformers;
  deepseq-magic = dontHaddock super.deepseq-magic;
  diagrams = dontHaddock super.diagrams;
  either = dontHaddock super.either;
  feldspar-signal = dontHaddock super.feldspar-signal; # https://github.com/markus-git/feldspar-signal/issues/1
  gl = dontHaddock super.gl;
  groupoids = dontHaddock super.groupoids;
  hamlet = dontHaddock super.hamlet;
  HaXml = dontHaddock super.HaXml;
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;
  http-client-conduit = dontHaddock super.http-client-conduit;
  http-client-multipart = dontHaddock super.http-client-multipart;
  markdown-unlit = dontHaddock super.markdown-unlit;
  network-conduit = dontHaddock super.network-conduit;
  shakespeare-js = dontHaddock super.shakespeare-js;
  shakespeare-text = dontHaddock super.shakespeare-text;
  swagger = dontHaddock super.swagger;  # http://hydra.cryp.to/build/2035868/nixlog/1/raw
  swagger2 = dontHaddock super.swagger2;
  wai-test = dontHaddock super.wai-test;
  zlib-conduit = dontHaddock super.zlib-conduit;

  # https://github.com/massysett/rainbox/issues/1
  rainbox = dontCheck super.rainbox;

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

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is really required
  # on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = if pkgs.stdenv.isDarwin then self.hfsevents else super.hinotify;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = if pkgs.stdenv.isDarwin
    then addBuildDepend (dontCheck super.fsnotify) pkgs.darwin.apple_sdk.frameworks.Cocoa
    else dontCheck super.fsnotify;

  double-conversion = if !pkgs.stdenv.isDarwin
    then addExtraLibrary super.double-conversion pkgs.stdenv.cc.cc.lib
    else addExtraLibrary (overrideCabal super.double-conversion (drv:
      {
        postPatch = ''
          substituteInPlace double-conversion.cabal --replace stdc++ c++
        '';
      })) pkgs.libcxx;

  inline-c-cpp = if !pkgs.stdenv.isDarwin
    then super.inline-c-cpp
    else addExtraLibrary (overrideCabal super.inline-c-cpp (drv:
      {
        postPatch = ''
          substituteInPlace inline-c-cpp.cabal --replace stdc++ c++
        '';
      })) pkgs.libcxx;

  # tests don't compile for some odd reason
  jwt = dontCheck super.jwt;

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

  # https://github.com/NICTA/digit/issues/3
  digit = dontCheck super.digit;

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
  cautious-file = dontCheck super.cautious-file;        # http://hydra.cryp.to/build/499730/log/raw
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
  hastache = dontCheck super.hastache;
  hath = dontCheck super.hath;
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
  liquidhaskell = dontCheck super.liquidhaskell;
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
  symengine = dontCheck super.symengine;
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

  # Depends on QuickCheck 1.x.
  HaVSA = super.HaVSA.override { QuickCheck = self.QuickCheck_1_2_0_1; };
  test-framework-quickcheck = super.test-framework-quickcheck.override { QuickCheck = self.QuickCheck_1_2_0_1; };

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

  # HsColour: Language/Unlambda.hs: hGetContents: invalid argument (invalid byte sequence)
  unlambda = dontHyperlinkSource super.unlambda;

  # https://github.com/PaulJohnson/geodetics/issues/1
  geodetics = dontCheck super.geodetics;

  # https://github.com/AndrewRademacher/aeson-casing/issues/1
  aeson-casing = dontCheck super.aeson-casing;

  # https://github.com/junjihashimoto/test-sandbox-compose/issues/2
  test-sandbox-compose = dontCheck super.test-sandbox-compose;

  # Relax overspecified constraints. Unfortunately, jailbreak won't work.
  pandoc = overrideCabal super.pandoc (drv: {
    preConfigure = "sed -i -e 's,time .* < 1.6,time >= 1.5,' -e 's,haddock-library >= 1.1 && < 1.3,haddock-library >= 1.1,' pandoc.cabal";
  });

  # https://github.com/tych0/xcffib/issues/37
  xcffib = dontCheck super.xcffib;

  # https://github.com/afcowie/locators/issues/1
  locators = dontCheck super.locators;

  # https://github.com/haskell/haddock/issues/378
  haddock-library = dontCheck super.haddock-library;

  # https://github.com/haskell/haddock/issues/571
  haddock-api = appendPatch (doJailbreak super.haddock-api) (pkgs.fetchpatch {
    url = "https://github.com/basvandijk/haddock/commit/f4c5e46ded05a4b8884f5ad6f3102f79ff3bb127.patch";
    sha256 = "01dawvikzw6y43557sbp9q7z9vw2g3wnzvv5ny0f0ks6ccc0vj0m";
    stripLen = 2;
    addPrefixes = true;
  });

  # https://github.com/anton-k/csound-expression-dynamic/issues/1
  csound-expression-dynamic = dontHaddock super.csound-expression-dynamic;

  # Test suite won't compile against tasty-hunit 0.9.x.
  zlib = dontCheck super.zlib;

  # https://github.com/ndmitchell/shake/issues/206
  # https://github.com/ndmitchell/shake/issues/267
  shake = overrideCabal super.shake (drv: { doCheck = !pkgs.stdenv.isDarwin && false; });

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

  # Depends on itself for testing
  doctest-discover = addBuildTool super.doctest-discover (dontCheck super.doctest-discover);

  # https://github.com/bos/aeson/issues/253
  aeson = dontCheck super.aeson;

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

  # https://github.com/BNFC/bnfc/issues/140
  BNFC = dontCheck super.BNFC;

  # FPCO's fork of Cabal won't succeed its test suite.
  Cabal-ide-backend = dontCheck super.Cabal-ide-backend;

  # https://github.com/jaspervdj/websockets/issues/104
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

  # https://github.com/qnikst/imagemagick/issues/34
  imagemagick = dontCheck super.imagemagick;

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

  # https://github.com/lens/lens-aeson/issues/18
  lens-aeson = dontCheck super.lens-aeson;

  # Byte-compile elisp code for Emacs.
  ghc-mod = overrideCabal super.ghc-mod (drv: {
    preCheck = "export HOME=$TMPDIR";
    testToolDepends = drv.testToolDepends or [] ++ [self.cabal-install];
    doCheck = false;            # https://github.com/kazu-yamamoto/ghc-mod/issues/335
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.emacs];
    postInstall = ''
      local lispdir=( "$out/share/"*"-${self.ghc.name}/${drv.pname}-${drv.version}/elisp" )
      make -C $lispdir
      mkdir -p $out/share/emacs/site-lisp
      ln -s "$lispdir/"*.el{,c} $out/share/emacs/site-lisp/
    '';
  });

  # Fine-tune the build.
  structured-haskell-mode = (overrideCabal super.structured-haskell-mode (drv: {
    # Statically linked Haskell libraries make the tool start-up much faster,
    # which is important for use in Emacs.
    enableSharedExecutables = false;
    # Make elisp files available at a location where people expect it. We
    # cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$out/share/"*"-${self.ghc.name}/${drv.pname}-"*"/elisp" )
      mkdir -p $out/share/emacs
      ln -s $lispdir $out/share/emacs/site-lisp
    '';
  })).override {
    haskell-src-exts = self.haskell-src-exts_1_19_1;
  };

  # # Make elisp files available at a location where people expect it.
  hindent = (overrideCabal super.hindent (drv: {
    # We cannot easily byte-compile these files, unfortunately, because they
    # depend on a new version of haskell-mode that we don't have yet.
    postInstall = ''
      local lispdir=( "$out/share/"*"-${self.ghc.name}/${drv.pname}-${drv.version}/elisp" )
      mkdir -p $out/share/emacs
      ln -s $lispdir $out/share/emacs/site-lisp
    '';
    doCheck = false; # https://github.com/chrisdone/hindent/issues/299
  })).override {
    haskell-src-exts = self.haskell-src-exts_1_19_1;
  };

  # https://github.com/yesodweb/Shelly.hs/issues/106
  # https://github.com/yesodweb/Shelly.hs/issues/108
  # https://github.com/yesodweb/Shelly.hs/issues/130
  shelly =
    let drv = appendPatch (dontCheck (doJailbreak super.shelly)) (pkgs.fetchpatch {
                url = "https://github.com/k0001/Shelly.hs/commit/32a1e290961755e7b2379f59faa49b13d03dfef6.patch";
                sha256 = "0ccq0qly8bxxv64dk97a44ng6hb01j6ajs0sp3f2nn0hf5j3xv69";
              });
    in overrideCabal drv (drv : {
         # doJailbreak doesn't seem to work for build-depends inside an
         # if-then-else block so we have to do it manually.
         postPatch = "sed -i 's/base >=4\.6 \&\& <4\.9\.1/base -any/' shelly.cabal";
       });

  # https://github.com/bos/configurator/issues/22
  configurator = dontCheck super.configurator;

  # https://github.com/basvandijk/concurrent-extra/issues/12
  concurrent-extra = dontCheck super.concurrent-extra;

  # https://github.com/bos/bloomfilter/issues/7
  bloomfilter = appendPatch super.bloomfilter ./patches/bloomfilter-fix-on-32bit.patch;

  # https://github.com/pxqr/base32-bytestring/issues/4
  base32-bytestring = dontCheck super.base32-bytestring;

  # https://github.com/JohnLato/listlike/pull/6#issuecomment-137986095
  ListLike = dontCheck super.ListLike;

  # https://github.com/goldfirere/singletons/issues/122
  singletons = dontCheck super.singletons;

  # https://github.com/guillaume-nargeot/hpc-coveralls/issues/52
  hpc-coveralls = disableSharedExecutables super.hpc-coveralls;

  # https://github.com/fpco/stackage/issues/838
  cryptonite = dontCheck super.cryptonite;

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/sol/hpack/issues/53
  hpack = dontCheck super.hpack;

  # https://github.com/deech/fltkhs/issues/16
  fltkhs = overrideCabal super.fltkhs (drv: {
    broken = true;      # linking fails because the build doesn't pull in the mesa libraries
  });
  fltkhs-fluid-examples = dontDistribute super.fltkhs-fluid-examples;

  # We get lots of strange compiler errors during the test suite run.
  jsaddle = dontCheck super.jsaddle;

  # Haste stuff
  haste-Cabal         = markBroken (self.callPackage ../tools/haskell/haste/haste-Cabal.nix {});
  haste-cabal-install = markBroken (self.callPackage ../tools/haskell/haste/haste-cabal-install.nix { Cabal = self.haste-Cabal; });
  haste-compiler      = markBroken (self.callPackage ../tools/haskell/haste/haste-compiler.nix { inherit overrideCabal; super-haste-compiler = super.haste-compiler; });

  # tinc is a new build driver a la Stack that's not yet available from Hackage.
  tinc = self.callPackage ../tools/haskell/tinc {};

  # Tools that use gtk2hs-buildtools now depend on them in a custom-setup stanza
  cairo = addBuildTool super.cairo self.gtk2hs-buildtools;
  pango = disableHardening (addBuildTool super.pango self.gtk2hs-buildtools) ["fortify"];

  # https://github.com/commercialhaskell/stack/issues/3001
  stack = doJailbreak super.stack;

  # The latest Hoogle needs versions not yet in LTS Haskell 7.x.
  hoogle = super.hoogle.override { haskell-src-exts = self.haskell-src-exts_1_19_1; };

  # To be in sync with Hoogle.
  lambdabot-haskell-plugins = (overrideCabal super.lambdabot-haskell-plugins (drv: {
    patches = [
      (pkgs.fetchpatch {
        url = "https://github.com/lambdabot/lambdabot/commit/78a2361024724acb70bc1c12c42f3a16015bb373.patch";
        sha256 = "0aw0jpw07idkrg8pdn3y3qzhjfrxsvmx3plg51m1aqgbzs000yxf";
        stripLen = 2;
        addPrefixes = true;
      })
    ];

    jailbreak = true;
  })).override {
    haskell-src-exts = self.haskell-src-exts-simple;
  };

  # Needs new version.
  haskell-src-exts-simple = super.haskell-src-exts-simple.override { haskell-src-exts = self.haskell-src-exts_1_19_1; };

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal super.stunclient (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  });

  # test suite cannot find its own "idris" binary
  idris = doJailbreak (dontCheck super.idris);

  # https://github.com/bos/math-functions/issues/25
  math-functions = dontCheck super.math-functions;

  # broken test suite
  servant-server = dontCheck super.servant-server;

  # Fix build for latest versions of servant and servant-client.
  servant-client_0_10 = super.servant-client_0_10.overrideScope (self: super: {
    servant-server = self.servant-server_0_10;
    servant = self.servant_0_10;
  });

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
          sha256 = "09kjinnarf9q9l8irs46gcrai8bprq39n8pj43bmdv47hl38csa0";
        }}/doc";
        buildInputs = with pkgs.pythonPackages; [ sphinx recommonmark sphinx_rtd_theme ];
        makeFlags = "html";
        installPhase = ''
          mv _build/html $out
        '';
      };
    in overrideCabal super.servant (old: {
      postInstall = old.postInstall or "" + ''
        ln -s ${docs} $out/share/doc/servant
      '';
    });


  # https://github.com/plow-technologies/servant-auth/issues/20
  servant-auth = dontCheck super.servant-auth;

  # https://github.com/pontarius/pontarius-xmpp/issues/105
  pontarius-xmpp = dontCheck super.pontarius-xmpp;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = doJailbreak super.applicative-quoters;

  # https://github.com/roelvandijk/terminal-progress-bar/issues/13
  terminal-progress-bar = doJailbreak super.terminal-progress-bar;

  # https://github.com/NixOS/nixpkgs/issues/19612
  wai-app-file-cgi = (dontCheck super.wai-app-file-cgi).overrideScope (self: super: {
    http-client = self.http-client_0_5_5;
    http-client-tls = self.http-client-tls_0_3_3_1;
    http-conduit = self.http-conduit_2_2_3;
  });

  # https://hydra.nixos.org/build/42769611/nixlog/1/raw
  # note: the library is unmaintained, no upstream issue
  dataenc = doJailbreak super.dataenc;

  # https://github.com/divipp/ActiveHs-misc/issues/10
  data-pprint = doJailbreak super.data-pprint;

  # horribly outdated (X11 interface changed a lot)
  sindre = markBroken super.sindre;

  # https://github.com/jmillikin/haskell-dbus/pull/7
  # http://hydra.cryp.to/build/498404/log/raw
  dbus = dontCheck (appendPatch super.dbus ./patches/hdbus-semicolons.patch);

  # Test suite occasionally runs for 1+ days on Hydra.
  distributed-process-tests = dontCheck super.distributed-process-tests;

  # https://github.com/mulby/diff-parse/issues/9
  diff-parse = doJailbreak super.diff-parse;

  # https://github.com/josefs/STMonadTrans/issues/4
  STMonadTrans = dontCheck super.STMonadTrans;

  # No upstream issue tracker
  hspec-expectations-pretty-diff = dontCheck super.hspec-expectations-pretty-diff;

  # https://github.com/basvandijk/lifted-base/issues/34
  lifted-base = doJailbreak super.lifted-base;

  # https://github.com/aslatter/parsec/issues/68
  parsec = doJailbreak super.parsec;

  # Don't depend on chell-quickcheck, which doesn't compile due to restricting
  # QuickCheck to versions ">=2.3 && <2.9".
  system-filepath = dontCheck super.system-filepath;

  # https://github.com/basvandijk/case-insensitive/issues/24
  case-insensitive = doJailbreak super.case-insensitive;

  # https://github.com/hvr/uuid/issues/28
  uuid-types = doJailbreak super.uuid-types;
  uuid = doJailbreak super.uuid;

  # https://github.com/hspec/hspec/issues/307
  hspec-contrib = dontCheck super.hspec-contrib;

  # https://github.com/ekmett/lens/issues/713
  lens = disableCabalFlag super.lens "test-doctests";

  # https://github.com/haskell/fgl/issues/60
  fgl = doJailbreak super.fgl;
  fgl-arbitrary = doJailbreak super.fgl-arbitrary;

  # https://github.com/Gabriel439/Haskell-DirStream-Library/issues/8
  dirstream = doJailbreak super.dirstream;

  # https://github.com/xmonad/xmonad-extras/issues/3
  xmonad-extras = doJailbreak super.xmonad-extras;

  # https://github.com/bmillwood/pointfree/issues/21
  pointfree = appendPatch super.pointfree (pkgs.fetchpatch {
    url = "https://github.com/bmillwood/pointfree/pull/22.patch";
    sha256 = "04q0b5d78ill2yrpflkphvk2y38qc50si2qff4bllp47wj42aqmp";
  });

  # https://github.com/int-e/QuickCheck-safe/issues/2
  QuickCheck-safe = doJailbreak super.QuickCheck-safe;

  # https://github.com/mokus0/dependent-sum-template/issues/7
  dependent-sum-template = doJailbreak super.dependent-sum-template;

  # https://github.com/jcristovao/newtype-generics/issues/13
  newtype-generics = doJailbreak super.newtype-generics;

  # https://github.com/lambdabot/lambdabot/issues/158
  lambdabot-core = doJailbreak super.lambdabot-core;

  # https://github.com/lambdabot/lambdabot/issues/159
  lambdabot = doJailbreak super.lambdabot;

  # https://github.com/jswebtools/language-ecmascript/pull/81
  language-ecmascript = doJailbreak super.language-ecmascript;
}
