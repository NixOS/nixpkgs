{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_18_1_6 = dontCheck super.Cabal_1_18_1_6;
  Cabal_1_20_0_3 = dontCheck super.Cabal_1_20_0_3;
  Cabal_1_22_4_0 = dontCheck super.Cabal_1_22_4_0;
  cabal-install = (dontCheck super.cabal-install).overrideScope (self: super: { Cabal = self.Cabal_1_22_4_0; zlib = self.zlib_0_5_4_2; });
  cabal-install_1_18_1_0 = (dontCheck super.cabal-install_1_18_1_0).overrideScope (self: super: { Cabal = self.Cabal_1_18_1_6; zlib = self.zlib_0_5_4_2; });

  # Link statically to avoid runtime dependency on GHC.
  jailbreak-cabal = disableSharedExecutables super.jailbreak-cabal;

  # Apply NixOS-specific patches.
  ghc-paths = appendPatch super.ghc-paths ./patches/ghc-paths-nix.patch;

  # Break infinite recursions.
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec = super.hspec.override { stringbuilder = dontCheck super.stringbuilder; };
  HTTP = dontCheck super.HTTP;
  mwc-random = dontCheck super.mwc-random;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  text = dontCheck super.text;

  # The package doesn't compile with ruby 1.9, which is our default at the moment.
  hruby = super.hruby.override { ruby = pkgs.ruby_2_1; };

  # Doesn't compile with lua 5.2.
  hslua = super.hslua.override { lua = pkgs.lua5_1; };

  # Use the default version of mysql to build this package (which is actually mariadb).
  mysql = super.mysql.override { mysql = pkgs.mysql.lib; };

  # Please also remove optparse-applicative special case from
  # cabal2nix/hackage2nix.hs when removing the following.
  elm-make = super.elm-make.override { optparse-applicative = self.optparse-applicative_0_10_0; };
  elm-package = super.elm-package.override { optparse-applicative = self.optparse-applicative_0_10_0; };

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # These changes are required to support Darwin.
  git-annex = (disableSharedExecutables super.git-annex).override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };

  # CUDA needs help finding the SDK headers and libraries.
  cuda = overrideCabal super.cuda (drv: {
    extraLibraries = (drv.extraLibraries or []) ++ [pkgs.linuxPackages.nvidia_x11];
    configureFlags = (drv.configureFlags or []) ++
      pkgs.lib.optional pkgs.stdenv.is64bit "--extra-lib-dirs=${pkgs.cudatoolkit}/lib64" ++ [
      "--extra-lib-dirs=${pkgs.cudatoolkit}/lib"
      "--extra-include-dirs=${pkgs.cudatoolkit}/usr_include"
    ];
    preConfigure = ''
      unset CC          # unconfuse the haskell-cuda configure script
      sed -i -e 's|/usr/local/cuda|${pkgs.cudatoolkit}|g' configure
    '';
  });

  # The package doesn't know about the AL include hierarchy.
  # https://github.com/phaazon/al/issues/1
  al = appendConfigureFlag super.al "--extra-include-dirs=${pkgs.openal}/include/AL";

  # Depends on code distributed under a non-free license.
  accelerate-cublas = dontDistribute super.accelerate-cublas;
  accelerate-cuda = dontDistribute super.accelerate-cuda;
  accelerate-cufft  = dontDistribute super.accelerate-cufft;
  accelerate-examples = dontDistribute super.accelerate-examples;
  accelerate-fft = dontDistribute super.accelerate-fft;
  accelerate-fourier-benchmark = dontDistribute super.accelerate-fourier-benchmark;
  AttoJson = markBroken super.AttoJson;
  bindings-yices = dontDistribute super.bindings-yices;
  cublas = dontDistribute super.cublas;
  cufft = dontDistribute super.cufft;
  gloss-accelerate = dontDistribute super.gloss-accelerate;
  gloss-raster-accelerate = dontDistribute super.gloss-raster-accelerate;
  GoogleTranslate = dontDistribute super.GoogleTranslate;
  GoogleDirections = dontDistribute super.GoogleDirections;
  libnvvm = dontDistribute super.libnvvm;
  manatee-all = dontDistribute super.manatee-all;
  manatee-ircclient = dontDistribute super.manatee-ircclient;
  Obsidian = dontDistribute super.Obsidian;
  patch-image = dontDistribute super.patch-image;
  yices = dontDistribute super.yices;
  yices-easy = dontDistribute super.yices-easy;
  yices-painless = dontDistribute super.yices-painless;

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

  # Help libconfig find it's C language counterpart.
  libconfig = (dontCheck super.libconfig).override { config = pkgs.libconfig; };

  hmatrix = overrideCabal super.hmatrix (drv: {
    configureFlags = (drv.configureFlags or []) ++ [ "-fopenblas" ];
    extraLibraries = [ pkgs.openblasCompat ];
    preConfigure = ''
      sed -i hmatrix.cabal -e 's@/usr/lib/openblas/lib@${pkgs.openblasCompat}/lib@'
    '';
  });

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
  shakespeare-js = dontHaddock super.shakespeare-js;
  shakespeare-text = dontHaddock super.shakespeare-text;
  types-compat = dontHaddock super.types-compat;                # https://github.com/philopon/apiary/issues/15
  wai-test = dontHaddock super.wai-test;
  zlib-conduit = dontHaddock super.zlib-conduit;
  record = dontHaddock super.record;                            # https://github.com/nikita-volkov/record/issues/22

  # Jailbreak doesn't get the job done because the Cabal file uses conditionals a lot.
  darcs = (overrideCabal super.darcs (drv: {
    doCheck = false;            # The test suite won't even start.
    patchPhase = "sed -i -e 's|attoparsec .*,|attoparsec,|' darcs.cabal";
  })).overrideScope (self: super: { zlib = self.zlib_0_5_4_2; });

  # https://github.com/massysett/rainbox/issues/1
  rainbox = dontCheck super.rainbox;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # These packages have broken dependencies.
  ASN1 = dontDistribute super.ASN1;                             # NewBinary
  frame-markdown = dontDistribute super.frame-markdown;         # frame
  hails-bin = dontDistribute super.hails-bin;                   # Hails
  lss = markBrokenVersion "0.1.0.0" super.lss;                  # https://github.com/dbp/lss/issues/2
  snaplet-lss = markBrokenVersion "0.1.0.0" super.snaplet-lss;  # https://github.com/dbp/lss/issues/2

  # https://github.com/haskell/vector/issues/47
  vector = if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector;

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is really required
  # on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = if pkgs.stdenv.isDarwin then self.hfsevents else super.hinotify;

  # hfsevents needs CoreServices in scope
  hfsevents = if pkgs.stdenv.isDarwin
    then addBuildTool super.hfsevents pkgs.darwin.apple_sdk.frameworks.CoreServices
    else super.hfsevents;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues
  fsnotify = if pkgs.stdenv.isDarwin then dontCheck super.fsnotify else super.fsnotify;

  # the system-fileio tests use canonicalizePath, which fails in the sandbox
  system-fileio = if pkgs.stdenv.isDarwin then dontCheck super.system-fileio else super.system-fileio;

  # Prevents needing to add security_tool as a build tool to all of x509-system's
  # dependencies.
  x509-system = if pkgs.stdenv.isDarwin && !pkgs.stdenv.cc.nativeLibc
    then let inherit (pkgs.darwin) security_tool;
      in pkgs.lib.overrideDerivation (addBuildDepend super.x509-system security_tool) (drv: {
        patchPhase = (drv.patchPhase or "") + ''
          substituteInPlace System/X509/MacOS.hs --replace security ${security_tool}/bin/security
        '';
      })
    else super.x509-system;

  double-conversion = if !pkgs.stdenv.isDarwin
    then super.double-conversion
    else overrideCabal super.double-conversion (drv:
      {
        patchPhase = ''
          substituteInPlace double-conversion.cabal --replace stdc++ c++
        '';
      });

  # Does not compile: "fatal error: ieee-flpt.h: No such file or directory"
  base_4_8_1_0 = markBroken super.base_4_8_1_0;

  # Obsolete: https://github.com/massysett/prednote/issues/1.
  prednote-test = markBrokenVersion "0.26.0.4" super.prednote-test;

  # Doesn't compile: "Setup: can't find include file ghc-gmp.h"
  integer-gmp_1_0_0_0 = markBroken super.integer-gmp_1_0_0_0;

  # Obsolete.
  lushtags = markBrokenVersion "0.0.1" super.lushtags;

  # https://github.com/haskell/bytestring/issues/41
  bytestring_0_10_6_0 = dontCheck super.bytestring_0_10_6_0;

  # tests don't compile for some odd reason
  jwt = dontCheck super.jwt;

  # https://github.com/liamoc/wizards/issues/5
  wizards = doJailbreak super.wizards;

  # https://github.com/tibbe/ekg-core/commit/c986d9750d026a0c049cf6e6610d69fc1f23121f, not yet in hackage
  ekg-core = doJailbreak super.ekg-core;

  # https://github.com/tibbe/ekg/commit/95018646f48f60d9ccf6209cc86747e0f132e737, not yet in hackage
  ekg = doJailbreak super.ekg;

  # https://github.com/NixOS/cabal2nix/issues/136
  glib = addBuildDepends super.glib [pkgs.pkgconfig pkgs.glib];
  gtk3 = super.gtk3.override { inherit (pkgs) gtk3; };
  gtk = addBuildDepends super.gtk [pkgs.pkgconfig pkgs.gtk];
  gtksourceview3 = super.gtksourceview3.override { inherit (pkgs.gnome3) gtksourceview; };

  # Need WebkitGTK, not just webkit.
  webkit = super.webkit.override { webkit = pkgs.webkitgtk2; };
  webkitgtk3 = super.webkitgtk3.override { webkit = pkgs.webkitgtk24x; };
  webkitgtk3-javascriptcore = super.webkitgtk3-javascriptcore.override { webkit = pkgs.webkitgtk24x; };
  websnap = super.websnap.override { webkit = pkgs.webkitgtk24x; };

  # While waiting for https://github.com/jwiegley/gitlib/pull/53 to be merged
  hlibgit2 = addBuildTool super.hlibgit2 pkgs.git;

  # https://github.com/mvoidex/hsdev/issues/11
  hsdev = dontHaddock super.hsdev;

  hs-mesos = overrideCabal super.hs-mesos (drv: {
    # Pass _only_ mesos; the correct protobuf is propagated.
    extraLibraries = [ pkgs.mesos ];
    preConfigure = "sed -i -e /extra-lib-dirs/d -e 's|, /usr/include, /usr/local/include/mesos||' hs-mesos.cabal";
  });

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
  dbmigrations = dontCheck super.dbmigrations;
  euler = dontCheck super.euler;                        # https://github.com/decomputed/euler/issues/1
  filestore = dontCheck super.filestore;
  getopt-generics = dontCheck super.getopt-generics;
  graceful = dontCheck super.graceful;
  hakyll = dontCheck super.hakyll;
  Hclip = dontCheck super.Hclip;
  HList = dontCheck super.HList;
  marquise = dontCheck super.marquise;                  # https://github.com/anchor/marquise/issues/69
  memcached-binary = dontCheck super.memcached-binary;
  persistent-zookeeper = dontCheck super.persistent-zookeeper;
  pocket-dns = dontCheck super.pocket-dns;
  postgresql-simple = dontCheck super.postgresql-simple;
  postgrest = dontCheck super.postgrest;
  snowball = dontCheck super.snowball;
  test-sandbox = dontCheck super.test-sandbox;
  users-postgresql-simple = dontCheck super.users-postgresql-simple;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  wai-middleware-throttle = dontCheck super.wai-middleware-throttle; # https://github.com/creichert/wai-middleware-throttle/issues/1
  xkbcommon = dontCheck super.xkbcommon;
  xmlgen = dontCheck super.xmlgen;
  ide-backend = dontCheck super.ide-backend;

  # These packages try to access the network.
  amqp = dontCheck super.amqp;
  amqp-conduit = dontCheck super.amqp-conduit;
  bitcoin-api = dontCheck super.bitcoin-api;
  bitcoin-api-extra = dontCheck super.bitcoin-api-extra;
  bitx-bitcoin = dontCheck super.bitx-bitcoin;          # http://hydra.cryp.to/build/926187/log/raw
  concurrent-dns-cache = dontCheck super.concurrent-dns-cache;
  dbus = dontCheck super.dbus;                          # http://hydra.cryp.to/build/498404/log/raw
  digitalocean-kzs = dontCheck super.digitalocean-kzs;  # https://github.com/KazumaSATO/digitalocean-kzs/issues/1
  hadoop-rpc = dontCheck super.hadoop-rpc;              # http://hydra.cryp.to/build/527461/nixlog/2/raw
  hasql = dontCheck super.hasql;                        # http://hydra.cryp.to/build/502489/nixlog/4/raw
  hjsonschema = overrideCabal super.hjsonschema (drv: { testTarget = "local"; });
  holy-project = dontCheck super.holy-project;          # http://hydra.cryp.to/build/502002/nixlog/1/raw
  hoogle = overrideCabal super.hoogle (drv: { testTarget = "--test-option=--no-net"; });
  http-client = dontCheck super.http-client;            # http://hydra.cryp.to/build/501430/nixlog/1/raw
  http-conduit = dontCheck super.http-conduit;          # http://hydra.cryp.to/build/501966/nixlog/1/raw
  js-jquery = dontCheck super.js-jquery;
  marmalade-upload = dontCheck super.marmalade-upload;  # http://hydra.cryp.to/build/501904/nixlog/1/raw
  network-transport-tcp = dontCheck super.network-transport-tcp;
  network-transport-zeromq = dontCheck super.network-transport-zeromq; # https://github.com/tweag/network-transport-zeromq/issues/30
  pipes-mongodb = dontCheck super.pipes-mongodb;        # http://hydra.cryp.to/build/926195/log/raw
  raven-haskell = dontCheck super.raven-haskell;        # http://hydra.cryp.to/build/502053/log/raw
  riak = dontCheck super.riak;                          # http://hydra.cryp.to/build/498763/log/raw
  scotty-binding-play = dontCheck super.scotty-binding-play;
  serversession-backend-redis = dontCheck super.serversession-backend-redis;
  slack-api = dontCheck super.slack-api;                # https://github.com/mpickering/slack-api/issues/5
  socket = dontCheck super.socket;
  stackage = dontCheck super.stackage;                  # http://hydra.cryp.to/build/501867/nixlog/1/raw
  textocat-api = dontCheck super.textocat-api;          # http://hydra.cryp.to/build/887011/log/raw
  warp = dontCheck super.warp;                          # http://hydra.cryp.to/build/501073/nixlog/5/raw
  wreq = dontCheck super.wreq;                          # http://hydra.cryp.to/build/501895/nixlog/1/raw
  wreq-sb = dontCheck super.wreq-sb;                    # http://hydra.cryp.to/build/783948/log/raw
  wuss = dontCheck super.wuss;                          # http://hydra.cryp.to/build/875964/nixlog/2/raw

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
  aeson-schema = dontCheck super.aeson-schema;          # https://github.com/timjb/aeson-schema/issues/9
  apache-md5 = dontCheck super.apache-md5;              # http://hydra.cryp.to/build/498709/nixlog/1/raw
  app-settings = dontCheck super.app-settings;          # http://hydra.cryp.to/build/497327/log/raw
  aws = dontCheck super.aws;                            # needs aws credentials
  aws-kinesis = dontCheck super.aws-kinesis;            # needs aws credentials for testing
  binary-protocol = dontCheck super.binary-protocol;    # http://hydra.cryp.to/build/499749/log/raw
  bindings-GLFW = dontCheck super.bindings-GLFW;        # requires an active X11 display
  bits = dontCheck super.bits;                          # http://hydra.cryp.to/build/500239/log/raw
  bloodhound = dontCheck super.bloodhound;
  buildwrapper = dontCheck super.buildwrapper;
  burst-detection = dontCheck super.burst-detection;    # http://hydra.cryp.to/build/496948/log/raw
  cabal-bounds = dontCheck super.cabal-bounds;          # http://hydra.cryp.to/build/496935/nixlog/1/raw
  cabal-meta = dontCheck super.cabal-meta;              # http://hydra.cryp.to/build/497892/log/raw
  cautious-file = dontCheck super.cautious-file;        # http://hydra.cryp.to/build/499730/log/raw
  CLI = dontCheck super.CLI;                            # Upstream has no issue tracker.
  cjk = dontCheck super.cjk;
  command-qq = dontCheck super.command-qq;              # http://hydra.cryp.to/build/499042/log/raw
  conduit-connection = dontCheck super.conduit-connection;
  craftwerk = dontCheck super.craftwerk;
  damnpacket = dontCheck super.damnpacket;              # http://hydra.cryp.to/build/496923/log
  data-hash = dontCheck super.data-hash;
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
  GLFW-b = dontCheck super.GLFW-b;                      # https://github.com/bsl/GLFW-b/issues/50
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
  hierarchical-clustering = dontCheck super.hierarchical-clustering;
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
  postgresql-binary = dontCheck super.postgresql-binary; # needs a running postgresql server
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
  sdl2-ttf = dontCheck super.sdl2-ttf; # as of version 0.2.1, the test suite requires user intervention
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
  xsd = dontCheck super.xsd;

  # https://bitbucket.org/wuzzeb/webdriver-utils/issue/1/hspec-webdriver-101-cant-compile-its-test
  hspec-webdriver = markBroken super.hspec-webdriver;

  # Needs access to locale data, but looks for it in the wrong place.
  scholdoc-citeproc = dontCheck super.scholdoc-citeproc;

  # These test suites run for ages, even on a fast machine. This is nuts.
  Random123 = dontCheck super.Random123;
  systemd = dontCheck super.systemd;

  # https://github.com/eli-frey/cmdtheline/issues/28
  cmdtheline = dontCheck super.cmdtheline;

  # https://github.com/bos/snappy/issues/1
  snappy = dontCheck super.snappy;

  # Expect to find sendmail(1) in $PATH.
  mime-mail = appendConfigureFlag super.mime-mail "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"";

  # Help the test suite find system timezone data.
  tz = overrideCabal super.tz (drv: { preConfigure = "export TZDIR=${pkgs.tzdata}/share/zoneinfo"; });

  # Deprecated upstream and doesn't compile.
  BASIC = dontDistribute super.BASIC;
  bytestring-arbitrary = dontDistribute (addBuildTool super.bytestring-arbitrary self.llvm);
  llvm = dontDistribute super.llvm;
  llvm-base = markBroken super.llvm-base;
  llvm-base-util = dontDistribute super.llvm-base-util;
  llvm-extra = dontDistribute super.llvm-extra;
  llvm-tf = dontDistribute super.llvm-tf;
  objectid = dontDistribute super.objectid;
  saltine-quickcheck = dontDistribute super.saltine-quickcheck;
  stable-tree = dontDistribute super.stable-tree;
  synthesizer-llvm = dontDistribute super.synthesizer-llvm;
  optimal-blocks = dontDistribute super.optimal-blocks;
  hs-blake2 = dontDistribute super.hs-blake2;

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  vty = dontCheck super.vty;

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/zouppen/stratum-tool/issues/14
  stratum-tool = markBrokenVersion "0.0.4" super.stratum-tool;

  # https://github.com/Gabriel439/Haskell-Turtle-Library/issues/1
  turtle = dontCheck super.turtle;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/cgaebel/stm-conduit/issues/33
  stm-conduit = dontCheck super.stm-conduit;

  # The install target tries to run lots of commands as "root". WTF???
  hannahci = markBroken super.hannahci;

  # https://github.com/jkarni/th-alpha/issues/1
  th-alpha = markBrokenVersion "0.2.0.0" super.th-alpha;

  # https://github.com/haskell-hub/hub-src/issues/24
  hub = markBrokenVersion "1.4.0" super.hub;

  # https://github.com/pixbi/duplo/issues/25
  duplo = dontCheck super.duplo;

  # Nix-specific workaround
  xmonad = appendPatch super.xmonad ./patches/xmonad-nix.patch;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary super.mikmod pkgs.libmikmod;

  # https://github.com/basvandijk/threads/issues/10
  threads = dontCheck super.threads;

  # https://github.com/ucsd-progsys/liquid-fixpoint/issues/44
  liquid-fixpoint = overrideCabal super.liquid-fixpoint (drv: { preConfigure = "patchShebangs ."; });

  # Missing module.
  rematch = dontCheck super.rematch;            # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text;  # https://github.com/tcrayford/rematch/issues/6

  # Upstream notified by e-mail.
  MonadCompose = markBrokenVersion "0.2.0.0" super.MonadCompose;

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/bos/bloomfilter/issues/7
  bloomfilter = overrideCabal super.bloomfilter (drv: { broken = !pkgs.stdenv.is64bit; });

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal super.paypal-adaptive-hoops (drv: { testTarget = "local"; });

  # https://github.com/jwiegley/simple-conduit/issues/2
  simple-conduit = markBroken super.simple-conduit;

  # https://code.google.com/p/linux-music-player/issues/detail?id=1
  mp = markBroken super.mp;

  # https://github.com/afcowie/http-streams/issues/80
  http-streams = dontCheck super.http-streams;

  # https://github.com/vincenthz/hs-asn1/issues/12
  asn1-encoding = dontCheck super.asn1-encoding;

  # wxc supports wxGTX >= 2.9, but our current default version points to 2.8.
  wxc = super.wxc.override { wxGTK = pkgs.wxGTK29; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK29; };

  # Depends on QuickCheck 1.x.
  HaVSA = super.HaVSA.override { QuickCheck = self.QuickCheck_1_2_0_1; };
  test-framework-quickcheck = super.test-framework-quickcheck.override { QuickCheck = self.QuickCheck_1_2_0_1; };

  # Doesn't support "this system". Linux? Needs investigation.
  lhc = markBroken (super.lhc.override { QuickCheck = self.QuickCheck_1_2_0_1; });

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

  # https://github.com/mikeizbicki/hmm/issues/12
  hmm = markBroken super.hmm;

  # https://github.com/alephcloud/hs-configuration-tools/issues/40
  configuration-tools = dontCheck super.configuration-tools;

  # https://github.com/fumieval/karakuri/issues/1
  karakuri = markBroken super.karakuri;

  # Upstream notified by e-mail.
  gearbox = markBroken super.gearbox;

  # https://github.com/deech/fltkhs/issues/7
  fltkhs = markBroken super.fltkhs;

  # Build fails, but there seems to be no issue tracker available. :-(
  hmidi = markBrokenVersion "0.2.1.0" super.hmidi;
  padKONTROL = markBroken super.padKONTROL;
  Bang = dontDistribute super.Bang;
  launchpad-control = dontDistribute super.launchpad-control;

  # Upstream provides no issue tracker and no contact details.
  vivid = markBroken super.vivid;

  # Test suite wants to connect to $DISPLAY.
  hsqml = dontCheck (super.hsqml.override { qt5 = pkgs.qt53; });

  # https://github.com/lookunder/RedmineHs/issues/4
  Redmine = markBroken super.Redmine;

  # HsColour: Language/Unlambda.hs: hGetContents: invalid argument (invalid byte sequence)
  unlambda = dontHyperlinkSource super.unlambda;

  # https://github.com/megantti/rtorrent-rpc/issues/2
  rtorrent-rpc = markBroken super.rtorrent-rpc;

  # https://github.com/PaulJohnson/geodetics/issues/1
  geodetics = dontCheck super.geodetics;

  # https://github.com/AndrewRademacher/aeson-casing/issues/1
  aeson-casing = dontCheck super.aeson-casing;

  # https://github.com/junjihashimoto/test-sandbox-compose/issues/2
  test-sandbox-compose = dontCheck super.test-sandbox-compose;

  # https://github.com/jgm/pandoc/issues/2190
  pandoc = overrideCabal super.pandoc (drv: {
    enableSharedExecutables = false;
    postInstall = ''            # install man pages
      mv man $out/
      find $out/man -type f ! -name "*.[0-9]" -exec rm {} +
    '';
  });

  # Broken by GLUT update.
  Monadius = markBroken super.Monadius;

  # We don't have the groonga package these libraries bind to.
  haroonga = markBroken super.haroonga;
  haroonga-httpd = markBroken super.haroonga-httpd;

  # Build is broken and no contact info available.
  hopenpgp-tools = markBroken super.hopenpgp-tools;

  # https://github.com/hunt-framework/hunt/issues/99
  hunt-server = markBrokenVersion "0.3.0.2" super.hunt-server;

  # https://github.com/bjpop/blip/issues/16
  blip = markBroken super.blip;

  # https://github.com/tych0/xcffib/issues/37
  xcffib = dontCheck super.xcffib;

  # https://github.com/afcowie/locators/issues/1
  locators = dontCheck super.locators;

  # https://github.com/scravy/hydrogen-syntax/issues/1
  hydrogen-syntax = markBroken super.hydrogen-syntax;
  hydrogen-cli = dontDistribute super.hydrogen-cli;

  # https://github.com/meteficha/Hipmunk/issues/8
  Hipmunk = markBroken super.Hipmunk;
  HipmunkPlayground = dontDistribute super.HipmunkPlayground;
  click-clack = dontDistribute super.click-clack;

  # https://github.com/fumieval/audiovisual/issues/1
  audiovisual = markBroken super.audiovisual;
  call = dontDistribute super.call;
  rhythm-game-tutorial = dontDistribute super.rhythm-game-tutorial;

  # https://github.com/haskell/haddock/issues/378
  haddock-library = dontCheck super.haddock-library;

  # Already fixed in upstream darcs repo.
  xmonad-contrib = overrideCabal super.xmonad-contrib (drv: {
    patchPhase = ''
      sed -i -e '24iimport Control.Applicative' XMonad/Util/Invisible.hs
      sed -i -e '22iimport Control.Applicative' XMonad/Hooks/DebugEvents.hs
    '';
  });

  # https://github.com/anton-k/csound-expression-dynamic/issues/1
  csound-expression-dynamic = dontHaddock super.csound-expression-dynamic;

  # Hardcoded include path
  poppler = overrideCabal super.poppler (drv: {
    patchPhase = ''
      sed -i -e 's,glib/poppler.h,poppler.h,' poppler.cabal
      sed -i -e 's,glib/poppler.h,poppler.h,' Graphics/UI/Gtk/Poppler/Structs.hsc
    '';
  });

  # Uses OpenGL in testing
  caramia = dontCheck super.caramia;

  # Needs help finding LLVM.
  llvm-general = super.llvm-general.override { llvm-config = self.llvmPackages.llvm; };
  spaceprobe = addBuildTool super.spaceprobe self.llvmPackages.llvm;

  # Tries to run GUI in tests
  leksah = dontCheck super.leksah;

  # Patch to consider NIX_GHC just like xmonad does
  dyre = appendPatch super.dyre ./patches/dyre-nix.patch;

  # Test suite won't compile against tasty-hunit 0.9.x.
  zlib = dontCheck super.zlib;

  # Override the obsolete version from Hackage with our more up-to-date copy.
  cabal2nix = self.callPackage ../tools/haskell/cabal2nix {};

  # https://github.com/urs-of-the-backwoods/HGamer3D/issues/7
  HGamer3D-Bullet-Binding = dontDistribute super.HGamer3D-Bullet-Binding;
  HGamer3D-Common = dontDistribute super.HGamer3D-Common;
  HGamer3D-Data = markBroken super.HGamer3D-Data;

  # https://github.com/ndmitchell/shake/issues/206
  # https://github.com/ndmitchell/shake/issues/267
  shake = overrideCabal super.shake (drv: { doCheck = !pkgs.stdenv.isDarwin && false; });

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

  # https://github.com/goldfirere/singletons/issues/116
  # https://github.com/goldfirere/singletons/issues/117
  # https://github.com/goldfirere/singletons/issues/118
  clash-lib = dontDistribute super.clash-lib;
  clash-verilog = dontDistribute super.clash-verilog;
  Frames = dontDistribute super.Frames;
  hgeometry = dontDistribute super.hgeometry;
  hipe = dontDistribute super.hipe;
  hsqml-datamodel-vinyl = dontDistribute super.hsqml-datamodel-vinyl;
  singleton-nats = dontDistribute super.singleton-nats;
  singletons = markBroken super.singletons;
  units-attoparsec = dontDistribute super.units-attoparsec;
  ihaskell-widgets = dontDistribute super.ihaskell-widgets;
  exinst-bytes = dontDistribute super.exinst-bytes;
  exinst-deepseq = dontDistribute super.exinst-deepseq;
  exinst-aeson = dontDistribute super.exinst-aeson;
  exinst = dontDistribute super.exinst;
  exinst-hashable = dontDistribute super.exinst-hashable;

  # https://github.com/anton-k/temporal-music-notation/issues/1
  temporal-music-notation = markBroken super.temporal-music-notation;
  temporal-music-notation-demo = dontDistribute super.temporal-music-notation-demo;
  temporal-music-notation-western = dontDistribute super.temporal-music-notation-western;

  # https://github.com/adamwalker/sdr/issues/1
  sdr = dontCheck super.sdr;

  # https://github.com/bos/aeson/issues/253
  aeson = dontCheck super.aeson;

  # Won't compile with recent versions of QuickCheck.
  testpack = markBroken super.testpack;
  inilist = dontCheck super.inilist;
  MissingH = dontCheck super.MissingH;

  # Obsolete for GHC versions after GHC 6.10.x.
  utf8-prelude = markBroken super.utf8-prelude;

  # https://github.com/yaccz/saturnin/issues/3
  Saturnin = dontCheck super.Saturnin;

  # https://github.com/kkardzis/curlhs/issues/6
  curlhs = dontCheck super.curlhs;

  # This needs the latest version of errors to compile.
  pipes-errors = super.pipes-errors.override { errors = self.errors_2_0_0; };

  # https://github.com/hvr/token-bucket/issues/3
  token-bucket = dontCheck super.token-bucket;

  # https://github.com/alphaHeavy/lzma-enumerator/issues/3
  lzma-enumerator = dontCheck super.lzma-enumerator;

  # https://github.com/BNFC/bnfc/issues/140
  BNFC = dontCheck super.BNFC;

  # FPCO's fork of Cabal won't succeed its test suite.
  Cabal-ide-backend = dontCheck super.Cabal-ide-backend;

  # https://github.com/DanielG/cabal-helper/issues/2
  cabal-helper = overrideCabal super.cabal-helper (drv: { preCheck = "export HOME=$TMPDIR"; });

  # https://github.com/ekmett/comonad/issues/25
  comonad = dontCheck super.comonad;

  # https://github.com/ekmett/semigroupoids/issues/35
  semigroupoids = disableCabalFlag super.semigroupoids "doctests";

  # https://github.com/jaspervdj/websockets/issues/104
  websockets = dontCheck super.websockets;

  # Avoid spurious test suite failures.
  fft = dontCheck super.fft;

  # This package can't be built on non-Windows systems.
  Win32 = overrideCabal super.Win32 (drv: { broken = !pkgs.stdenv.isCygwin; });
  inline-c-win32 = dontDistribute super.inline-c-win32;
  Southpaw = dontDistribute super.Southpaw;

  # Doesn't work with recent versions of mtl.
  cron-compat = markBroken super.cron-compat;

  # https://github.com/yesodweb/serversession/issues/1
  serversession = dontCheck super.serversession;

  yesod-bin = if pkgs.stdenv.isDarwin
    then addBuildDepend super.yesod-bin pkgs.darwin.apple_sdk.frameworks.Cocoa
    else super.yesod-bin;

  # https://github.com/commercialhaskell/stack/issues/408
  # https://github.com/commercialhaskell/stack/issues/409
  stack = overrideCabal super.stack (drv: { preCheck = "export HOME=$TMPDIR"; doCheck = false; });

  # Missing dependency on some hid-usb library.
  hid = markBroken super.hid;
  msi-kb-backlit = dontDistribute super.msi-kb-backlit;

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

  # https://github.com/edwinb/EpiVM/issues/13
  # https://github.com/edwinb/EpiVM/issues/14
  epic = addExtraLibraries (addBuildTool super.epic self.happy) [pkgs.boehmgc pkgs.gmp];

  # Upstream has no issue tracker.
  dpkg = markBroken super.dpkg;

  # https://github.com/ekmett/wl-pprint-terminfo/issues/7
  wl-pprint-terminfo = addExtraLibrary super.wl-pprint-terminfo pkgs.ncurses;

  # https://github.com/bos/pcap/issues/5
  pcap = addExtraLibrary super.pcap pkgs.libpcap;

  # https://github.com/skogsbaer/hscurses/issues/24
  hscurses = markBroken super.hscurses;

  # https://github.com/qnikst/imagemagick/issues/34
  imagemagick = dontCheck super.imagemagick;

  # https://github.com/liyang/thyme/issues/36
  thyme = dontCheck super.thyme;

  # https://github.com/k0ral/hbro/issues/15
  hbro = markBroken super.hbro;
  hbro-contrib = dontDistribute super.hbro-contrib;

  # https://github.com/aka-bash0r/multi-cabal/issues/4
  multi-cabal = markBroken super.multi-cabal;

}
