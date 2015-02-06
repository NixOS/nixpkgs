{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_18_1_6 = dontCheck super.Cabal_1_18_1_6;
  Cabal_1_20_0_3 = dontCheck super.Cabal_1_20_0_3;
  Cabal_1_22_0_0 = dontCheck super.Cabal_1_22_0_0;
  cabal-install = dontCheck (super.cabal-install.override { Cabal = self.Cabal_1_22_0_0; });

  # Break infinite recursions.
  digest = super.digest.override { inherit (pkgs) zlib; };
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec-expectations = dontCheck super.hspec-expectations;
  HTTP = dontCheck super.HTTP;
  mwc-random = dontCheck super.mwc-random;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  text = dontCheck super.text;

  # Doesn't compile with lua 5.2.
  hslua = super.hslua.override { lua = pkgs.lua5_1; };

  # Please also remove optparse-applicative special case from
  # cabal2nix/hackage2nix.hs when removing the following.
  elm-make = super.elm-make.override { optparse-applicative = self.optparse-applicative_0_10_0; };
  elm-package = super.elm-package.override { optparse-applicative = self.optparse-applicative_0_10_0; };

  # https://github.com/acid-state/safecopy/issues/17
  safecopy = dontCheck super.safecopy;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # These changes are required to support Darwin.
  git-annex = (disableSharedExecutables super.git-annex).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  # Depends on code distributed under a non-free license.
  bindings-yices = dontDistribute super.bindings-yices;
  yices = dontDistribute super.yices;
  yices-easy = dontDistribute super.yices-easy;
  yices-painless = dontDistribute super.yices-painless;

  # The test suite refers to its own library with an invalid version constraint.
  presburger = dontCheck super.presburger;

  # Won't find it's header files without help.
  sfml-audio = appendConfigureFlag super.sfml-audio "--extra-include-dirs=${pkgs.openal}/include/AL";

  hzk = overrideCabal super.hzk (drv: {
    preConfigure = "sed -i -e /include-dirs/d hzk.cabal";
    configureFlags =  "--extra-include-dirs=${pkgs.zookeeper_mt}/include/zookeeper";
    doCheck = false;
  });

  haskakafka = overrideCabal super.haskakafka (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d haskakafka.cabal";
    configureFlags =  "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka";
    doCheck = false;
   });

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

  # https://github.com/haskell/time/issues/23
  time_1_5_0_1 = dontCheck super.time_1_5_0_1;

  # Cannot compile its own test suite: https://github.com/haskell/network-uri/issues/10.
  network-uri = dontCheck super.network-uri;

  # The Haddock phase fails for one reason or another.
  Agda = dontHaddock super.Agda;
  attoparsec-conduit = dontHaddock super.attoparsec-conduit;
  blaze-builder-conduit = dontHaddock super.blaze-builder-conduit;
  bytestring-progress = dontHaddock super.bytestring-progress;
  comonads-fd = dontHaddock super.comonads-fd;
  comonad-transformers = dontHaddock super.comonad-transformers;
  deepseq-magic = dontHaddock super.deepseq-magic;
  diagrams = dontHaddock super.diagrams;
  either = dontHaddock super.either;
  gl = dontHaddock super.gl;
  groupoids = dontHaddock super.groupoids;
  hamlet = dontHaddock super.hamlet;
  haste-compiler = dontHaddock super.haste-compiler;
  HaXml = dontHaddock super.HaXml;
  HDBC-odbc = dontHaddock super.HDBC-odbc;
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;
  hspec-discover = dontHaddock super.hspec-discover;
  http-client-conduit = dontHaddock super.http-client-conduit;
  http-client-multipart = dontHaddock super.http-client-multipart;
  hxt = dontHaddock super.hxt;                                  # https://github.com/UweSchmidt/hxt/issues/38
  markdown-unlit = dontHaddock super.markdown-unlit;
  network-conduit = dontHaddock super.network-conduit;
  shakespeare-text = dontHaddock super.shakespeare-text;
  uhc-light = dontHaddock super.uhc-light;                      # https://github.com/UU-ComputerScience/uhc/issues/45

  # jailbreak doesn't get the job done because the Cabal file uses conditionals a lot.
  darcs = overrideCabal super.darcs (drv: {
    doCheck = false;            # The test suite won't even start.
    patchPhase = "sed -i -e 's|random.*==.*|random|' -e 's|text.*>=.*,|text,|' -e s'|terminfo == .*|terminfo|' darcs.cabal";
  });

  # The test suite imposes too narrow restrictions on the version of
  # Cabal that can be used to build this package.
  cabal-test-quickcheck = dontCheck super.cabal-test-quickcheck;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # These packages have broken dependencies.
  ASN1 = dontDistribute super.ASN1;                             # NewBinary
  frame-markdown = dontDistribute super.frame-markdown;         # frame
  hails-bin = dontDistribute super.hails-bin;                   # Hails
  hbro-contrib = dontDistribute super.hbro-contrib;             # hbro
  lss = markBrokenVersion "0.1.0.0" super.lss;                  # https://github.com/dbp/lss/issues/2
  snaplet-lss = markBrokenVersion "0.1.0.0" super.snaplet-lss;  # https://github.com/dbp/lss/issues/2

  # https://github.com/haskell/vector/issues/47
  vector = if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector;

  # Does not compile: <http://hydra.cryp.to/build/469842/nixlog/1/raw>.
  base_4_7_0_2 = markBroken super.base_4_7_0_2;

  # Obsolete: https://github.com/massysett/prednote/issues/1.
  prednote-test = markBrokenVersion "0.26.0.4" super.prednote-test;

  # Doesn't compile: <http://hydra.cryp.to/build/465891/nixlog/1/raw>.
  integer-gmp_0_5_1_0 = markBroken super.integer-gmp_0_5_1_0;

  lushtags = markBrokenVersion "0.0.1" super.lushtags;

  # https://github.com/haskell/bytestring/issues/41
  bytestring_0_10_4_1 = dontCheck super.bytestring_0_10_4_1;

  # https://github.com/zmthy/http-media/issues/6
  http-media = dontCheck super.http-media;

  # tests don't compile for some odd reason
  jwt = dontCheck super.jwt;

  # https://github.com/liamoc/wizards/issues/5
  wizards = doJailbreak super.wizards;

  # https://github.com/NixOS/cabal2nix/issues/136
  glib = addBuildDepends super.glib [pkgs.pkgconfig pkgs.glib];
  gtk3 = super.gtk3.override { inherit (pkgs) gtk3; };
  gtk = addBuildDepends super.gtk [pkgs.pkgconfig pkgs.gtk];

  # https://github.com/jgm/zip-archive/issues/21
  zip-archive = addBuildTool super.zip-archive pkgs.zip;

  # https://github.com/mvoidex/hsdev/issues/11
  hsdev = dontHaddock super.hsdev;

  # Upstream notified by e-mail.
  permutation = dontCheck super.permutation;

  # https://github.com/vincenthz/hs-tls/issues/102
  tls = dontCheck super.tls;

  # https://github.com/jputcu/serialport/issues/25
  serialport = dontCheck super.serialport;

  # https://github.com/kazu-yamamoto/simple-sendfile/issues/17
  simple-sendfile = dontCheck super.simple-sendfile;

  # Fails no apparent reason. Upstream has been notified by e-mail.
  assertions = dontCheck super.assertions;

  # https://github.com/vincenthz/tasty-kat/issues/1
  tasty-kat = dontCheck super.tasty-kat;

  # These packages try to execute non-existent external programs.
  cmaes = dontCheck super.cmaes;                        # http://hydra.cryp.to/build/498725/log/raw
  filestore = dontCheck super.filestore;
  graceful = dontCheck super.graceful;
  hakyll = dontCheck super.hakyll;
  Hclip = dontCheck super.Hclip;
  HList = dontCheck super.HList;
  memcached-binary = dontCheck super.memcached-binary;
  postgresql-simple = dontCheck super.postgresql-simple;
  snowball = dontCheck super.snowball;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  xmlgen = dontCheck super.xmlgen;

  # These packages try to access the network.
  amqp = dontCheck super.amqp;
  amqp-conduit = dontCheck super.amqp-conduit;
  concurrent-dns-cache = dontCheck super.concurrent-dns-cache;
  dbus = dontCheck super.dbus;                          # http://hydra.cryp.to/build/498404/log/raw
  hadoop-rpc = dontCheck super.hadoop-rpc;              # http://hydra.cryp.to/build/527461/nixlog/2/raw
  hasql = dontCheck super.hasql;                        # http://hydra.cryp.to/build/502489/nixlog/4/raw
  holy-project = dontCheck super.holy-project;          # http://hydra.cryp.to/build/502002/nixlog/1/raw
  http-client = dontCheck super.http-client;            # http://hydra.cryp.to/build/501430/nixlog/1/raw
  http-conduit = dontCheck super.http-conduit;          # http://hydra.cryp.to/build/501966/nixlog/1/raw
  js-jquery = dontCheck super.js-jquery;
  marmalade-upload = dontCheck super.marmalade-upload;  # http://hydra.cryp.to/build/501904/nixlog/1/raw
  network-transport-zeromq = dontCheck super.network-transport-zeromq; # https://github.com/tweag/network-transport-zeromq/issues/30
  network-transport-tcp = dontCheck super.network-transport-tcp;
  raven-haskell = dontCheck super.raven-haskell;        # http://hydra.cryp.to/build/502053/log/raw
  riak = dontCheck super.riak;                          # http://hydra.cryp.to/build/498763/log/raw
  slack-api = dontCheck super.slack-api;                # https://github.com/mpickering/slack-api/issues/5
  stackage = dontCheck super.stackage;                  # http://hydra.cryp.to/build/501867/nixlog/1/raw
  warp = dontCheck super.warp;                          # http://hydra.cryp.to/build/501073/nixlog/5/raw
  wreq = dontCheck super.wreq;                          # http://hydra.cryp.to/build/501895/nixlog/1/raw

  # https://github.com/NICTA/digit/issues/3
  digit = dontCheck super.digit;

  # Fails for non-obvious reasons while attempting to use doctest.
  search = dontCheck super.search;

  # https://github.com/ekmett/structures/issues/3
  structures = dontCheck super.structures;

  # Tries to mess with extended POSIX attributes, but can't in our chroot environment.
  xattr = dontCheck super.xattr;

  # Disable test suites to fix the build.
  acme-year = dontCheck super.acme-year;                # http://hydra.cryp.to/build/497858/log/raw
  aeson-lens = dontCheck super.aeson-lens;              # http://hydra.cryp.to/build/496769/log/raw
  apache-md5 = dontCheck super.apache-md5;              # http://hydra.cryp.to/build/498709/nixlog/1/raw
  app-settings = dontCheck super.app-settings;          # http://hydra.cryp.to/build/497327/log/raw
  aws = dontCheck super.aws;                            # needs aws credentials
  aws-kinesis = dontCheck super.aws-kinesis;            # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol;    # http://hydra.cryp.to/build/499749/log/raw
  bindings-GLFW = dontCheck super.bindings-GLFW;        # http://hydra.cryp.to/build/497379/log/raw
  bits = dontCheck super.bits;                          # http://hydra.cryp.to/build/500239/log/raw
  bloodhound = dontCheck super.bloodhound;
  boundingboxes = dontCheck super.boundingboxes;        # https://github.com/fumieval/boundingboxes/issues/1
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection;    # http://hydra.cryp.to/build/496948/log/raw
  cabal-bounds = dontCheck super.cabal-bounds;          # http://hydra.cryp.to/build/496935/nixlog/1/raw
  cabal-meta = dontCheck super.cabal-meta;              # http://hydra.cryp.to/build/497892/log/raw
  cautious-file = dontCheck super.cautious-file;        # http://hydra.cryp.to/build/499730/log/raw
  cjk = dontCheck super.cjk;
  command-qq = dontCheck super.command-qq;              # http://hydra.cryp.to/build/499042/log/raw
  conduit-connection = dontCheck super.conduit-connection;
  craftwerk = dontCheck super.craftwerk;
  damnpacket = dontCheck super.damnpacket;              # http://hydra.cryp.to/build/496923/log
  Deadpan-DDP = dontCheck super.Deadpan-DDP;            # http://hydra.cryp.to/build/496418/log/raw
  DigitalOcean = dontCheck super.DigitalOcean;
  directory-layout = dontCheck super.directory-layout;
  docopt = dontCheck super.docopt;                      # http://hydra.cryp.to/build/499172/log/raw
  dom-selector = dontCheck super.dom-selector;          # http://hydra.cryp.to/build/497670/log/raw
  dotfs = dontCheck super.dotfs;                        # http://hydra.cryp.to/build/498599/log/raw
  DRBG = dontCheck super.DRBG;                          # http://hydra.cryp.to/build/498245/nixlog/1/raw
  either-unwrap = dontCheck super.either-unwrap;        # http://hydra.cryp.to/build/498782/log/raw
  elm-repl = dontCheck super.elm-repl;                  # http://hydra.cryp.to/build/501878/nixlog/1/raw
  etcd = dontCheck super.etcd;
  fb = dontCheck super.fb;                              # needs credentials for Facebook
  fptest = dontCheck super.fptest;                      # http://hydra.cryp.to/build/499124/log/raw
  ghc-events = dontCheck super.ghc-events;              # http://hydra.cryp.to/build/498226/log/raw
  ghc-events-parallel = dontCheck super.ghc-events-parallel;    # http://hydra.cryp.to/build/496828/log/raw
  ghcid = dontCheck super.ghcid;
  ghc-imported-from = dontCheck super.ghc-imported-from;
  ghc-mod = dontCheck super.ghc-mod;                    # http://hydra.cryp.to/build/499674/log/raw
  ghc-parmake = dontCheck super.ghc-parmake;
  gitlib-cmdline = dontCheck super.gitlib-cmdline;
  git-vogue = dontCheck super.git-vogue;
  GLFW-b = dontCheck super.GLFW-b;
  hackport = dontCheck super.hackport;
  hadoop-formats = dontCheck super.hadoop-formats;
  haeredes = dontCheck super.haeredes;
  hashed-storage = dontCheck super.hashed-storage;
  hashring = dontCheck super.hashring;
  hath = dontCheck super.hath;
  haxl-facebook = dontCheck super.haxl-facebook;        # needs facebook credentials for testing
  hdbi-postgresql = dontCheck super.hdbi-postgresql;
  hedis = dontCheck super.hedis;
  hedis-pile = dontCheck super.hedis-pile;
  hedis-tags = dontCheck super.hedis-tags;
  hedn = dontCheck super.hedn;
  hgdbmi = dontCheck super.hgdbmi;
  hi = dontCheck super.hi;
  hmatrix-tests = dontCheck super.hmatrix-tests;
  hPDB-examples = dontCheck super.hPDB-examples;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  hsexif = dontCheck super.hsexif;
  hspec-server = dontCheck super.hspec-server;
  HTF = dontCheck super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http2 = dontCheck super.http2;
  http-client-openssl = dontCheck super.http-client-openssl;
  http-client-tls = dontCheck super.http-client-tls;
  ihaskell = dontCheck super.ihaskell;
  influxdb = dontCheck super.influxdb;
  itanium-abi = dontCheck super.itanium-abi;
  katt = dontCheck super.katt;
  language-slice = dontCheck super.language-slice;
  lensref = dontCheck super.lensref;
  liquidhaskell = dontCheck super.liquidhaskell;
  lvmrun = dontCheck super.lvmrun;
  memcache = dontCheck super.memcache;
  milena = dontCheck super.milena;
  nats-queue = dontCheck super.nats-queue;
  netpbm = dontCheck super.netpbm;
  network-dbus = dontCheck super.network-dbus;
  notcpp = dontCheck super.notcpp;
  ntp-control = dontCheck super.ntp-control;
  numerals = dontCheck super.numerals;
  opaleye = dontCheck super.opaleye;
  openpgp = dontCheck super.openpgp;
  optional = dontCheck super.optional;
  os-release = dontCheck super.os-release;
  pandoc-citeproc = dontCheck super.pandoc-citeproc;
  persistent-redis = dontCheck super.persistent-redis;
  pipes-extra = dontCheck super.pipes-extra;
  pipes-websockets = dontCheck super.pipes-websockets;
  postgresql-binary = dontCheck super.postgresql-binary;# needs a running postgresql server
  postgresql-simple-migration = dontCheck super.postgresql-simple-migration;
  process-streaming = dontCheck super.process-streaming;
  punycode = dontCheck super.punycode;
  pwstore-cli = dontCheck super.pwstore-cli;
  quantities = dontCheck super.quantities;
  redis-io = dontCheck super.redis-io;
  rethinkdb = dontCheck super.rethinkdb;
  Rlang-QQ = dontCheck super.Rlang-QQ;
  sai-shape-syb = dontCheck super.sai-shape-syb;
  scp-streams = dontCheck super.scp-streams;
  separated = dontCheck super.separated;
  shadowsocks = dontCheck super.shadowsocks;
  shake-language-c = dontCheck super.shake-language-c;
  static-resources = dontCheck super.static-resources;
  strive = dontCheck super.strive;                      # fails its own hlint test with tons of warnings
  svndump = dontCheck super.svndump;
  thumbnail-plus = dontCheck super.thumbnail-plus;
  tickle = dontCheck super.tickle;
  tpdb = dontCheck super.tpdb;
  translatable-intset = dontCheck super.translatable-intset;
  ua-parser = dontCheck super.ua-parser;
  unagi-chan = dontCheck super.unagi-chan;
  wai-app-file-cgi = dontCheck super.wai-app-file-cgi;
  wai-logger = dontCheck super.wai-logger;
  WebBits = dontCheck super.WebBits;                    # http://hydra.cryp.to/build/499604/log/raw
  webdriver-angular = dontCheck super.webdriver-angular;
  webdriver = dontCheck super.webdriver;
  xcffib = dontCheck super.xcffib;
  xsd = dontCheck super.xsd;

  # The build fails with the most recent version of c2hs.
  ncurses = super.ncurses.override { c2hs = self.c2hs_0_20_1; };

  # Needs access to locale data, but looks for it in the wrong place.
  scholdoc-citeproc = dontCheck super.scholdoc-citeproc;

  # These test suites run for ages, even on a fast machine. This is nuts.
  Random123 = dontCheck super.Random123;
  systemd = dontCheck super.systemd;

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  snappy = dontCheck super.snappy;

  # Needs llvm to compile.
  bytestring-arbitrary = addBuildTool super.bytestring-arbitrary pkgs.llvm;

  # https://github.com/chrisdone/hindent/issues/83
  hindent = dontCheck super.hindent;

  # https://github.com/begriffs/postgrest/issues/131
  postgrest = markBrokenVersion "0.2.5.2" super.postgrest;

  # Needs older versions of its dependencies.
  structured-haskell-mode = (dontJailbreak super.structured-haskell-mode).override {
    haskell-src-exts = self.haskell-src-exts_1_15_0_1;  # https://github.com/chrisdone/structured-haskell-mode/issues/90
  };

  # Expect to find sendmail(1) in $PATH.
  mime-mail = appendConfigureFlag super.mime-mail "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"";

  # Help the test suite find system timezone data.
  tz = overrideCabal super.tz (drv: { preConfigure = "export TZDIR=${pkgs.tzdata}/share/zoneinfo"; });

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  vty = dontCheck super.vty;

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/rrnewton/haskell-lockfree/issues/44
  chaselev-deque = markBrokenVersion "0.5.0.3" super.chaselev-deque;

  # https://github.com/zouppen/stratum-tool/issues/14
  stratum-tool = markBrokenVersion "0.0.4" super.stratum-tool;

  # https://github.com/Gabriel439/Haskell-Turtle-Library/issues/1
  turtle = dontCheck super.turtle;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/fumieval/call/issues/3
  call = markBrokenVersion "0.1.2" super.call;
  rhythm-game-tutorial = dontDistribute super.rhythm-game-tutorial;     # depends on call

  # The install target tries to run lots of commands as "root". WTF???
  hannahci = markBroken super.hannahci;

  # https://github.com/jkarni/th-alpha/issues/1
  th-alpha = markBrokenVersion "0.2.0.0" super.th-alpha;

  # https://github.com/haskell-hub/hub-src/issues/24
  hub = markBrokenVersion "1.4.0" super.hub;

  # https://github.com/pixbi/duplo/issues/25
  duplo = dontCheck super.duplo;

  # https://github.com/seagreen/hjsonschema/issues/4
  # https://github.com/seagreen/hjsonschema/issues/5
  hjsonschema = dontHaddock (dontCheck super.hjsonschema);

  # Nix-specific workaround
  xmonad = appendPatch super.xmonad ./xmonad-nix.patch;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary super.mikmod pkgs.libmikmod;

  # https://github.com/d12frosted/CanonicalPath/issues/3
  system-canonicalpath = dontCheck super.system-canonicalpath;

  # https://github.com/basvandijk/threads/issues/10
  threads = dontCheck super.threads;

  # https://github.com/ucsd-progsys/liquid-fixpoint/issues/44
  liquid-fixpoint = overrideCabal super.liquid-fixpoint (drv: { preConfigure = "patchShebangs ."; });

  # LLVM 3.5 breaks GHC: https://ghc.haskell.org/trac/ghc/ticket/9142.
  GlomeVec = super.GlomeVec.override { llvm = pkgs.llvm_34; };  # https://github.com/jimsnow/glome/issues/2
  gloss-raster = super.gloss-raster.override { llvm = pkgs.llvm_34; };
  repa-examples = super.repa-examples.override { llvm = pkgs.llvm_34; };

  # Upstream notified by e-mail.
  OpenGLRaw21 = markBrokenVersion "1.2.0.1" super.OpenGLRaw21;

} // {

  # Not on Hackage.
  cabal2nix = self.mkDerivation {
    pname = "cabal2nix";
    version = "2.0";
    src = pkgs.fetchgit {
      url = "http://github.com/NixOS/cabal2nix.git";
      sha256 = "5cc98f530303a82885e2f23d2c83f67f1a3767bfdd5ed3340e45858f1a0f04e1";
      rev = "6a445468030b064e4f71b43c269ba506e7e2f779";
    };
    isLibrary = false;
    isExecutable = true;
    buildDepends = with self; [
      aeson base bytestring Cabal containers deepseq deepseq-generics
      directory filepath hackage-db monad-par monad-par-extras mtl pretty
      prettyclass process QuickCheck regex-posix SHA split transformers
      utf8-string
    ];
    testDepends = with self; [
      aeson base bytestring Cabal containers deepseq deepseq-generics
      directory doctest filepath hackage-db hspec monad-par
      monad-par-extras mtl pretty prettyclass process QuickCheck
      regex-posix SHA split transformers utf8-string
    ];
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = pkgs.stdenv.lib.licenses.bsd3;
  };

}
