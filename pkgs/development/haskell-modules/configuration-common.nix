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

  # Apply NixOS-specific patches.
  ghc-paths = appendPatch super.ghc-paths ./patches/ghc-paths-nix.patch;

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
  c2hs = dontCheck super.c2hs;

  # fix errors caused by hardening flags
  epanet-haskell = disableHardening super.epanet-haskell ["format"];

  # This test keeps being aborted because it runs too quietly for too long
  Lazy-Pbkdf2 = if pkgs.stdenv.isi686 then dontCheck super.Lazy-Pbkdf2 else super.Lazy-Pbkdf2;

  # Use the default version of mysql to build this package (which is actually mariadb).
  # test phase requires networking
  mysql = dontCheck (super.mysql.override { mysql = pkgs.mysql.lib; });

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # The Hackage tarball is purposefully broken. Mr. Hess wants people to build
  # his package from the Git repo because that is, like, better!
  git-annex = ((overrideCabal super.git-annex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "joeyh";
      repo = "git-annex";
      sha256 = "1vy6bj7f8zyj4n1r0gpi0r7mxapsrjvhwmsi5sbnradfng5j3jya";
      rev = drv.version;
    };
  })).overrideScope (self: super: {
    # https://github.com/bitemyapp/esqueleto/issues/8
    esqueleto = self.esqueleto_2_4_3;
    # https://github.com/prowdsponsor/esqueleto/issues/137
    persistent = self.persistent_2_2_4_1;
    persistent-template = self.persistent-template_2_1_8_1;
    persistent-sqlite = self.persistent-sqlite_2_2_1;
  })).override {
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
      "--extra-include-dirs=${pkgs.cudatoolkit}/include"
    ];
    preConfigure = ''
      unset CC          # unconfuse the haskell-cuda configure script
      sed -i -e 's|/usr/local/cuda|${pkgs.cudatoolkit}|g' configure
    '';
  });

  # jni needs help finding libjvm.so because it's in a weird location.
  jni = overrideCabal super.jni (drv: {
    preConfigure = ''
      local libdir=( "${pkgs.jdk}/lib/openjdk/jre/lib/"*"/server" )
      configureFlags+=" --extra-lib-dir=''${libdir[0]}"
    '';
  });

  # The package doesn't know about the AL include hierarchy.
  # https://github.com/phaazon/al/issues/1
  al = appendConfigureFlag super.al "--extra-include-dirs=${pkgs.openal}/include/AL";

  # https://github.com/froozen/kademlia/issues/2
  kademlia = dontCheck super.kademlia;

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

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

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
  wai-test = dontHaddock super.wai-test;
  zlib-conduit = dontHaddock super.zlib-conduit;

  # https://github.com/massysett/rainbox/issues/1
  rainbox = dontCheck super.rainbox;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # https://github.com/haskell/vector/issues/47
  # https://github.com/haskell/vector/issues/138
  vector = doJailbreak (if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector);

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

  # Heist's test suite requires system pandoc
  heist = overrideCabal super.heist (drv: {
    testToolDepends = [pkgs.pandoc];
  });

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is really required
  # on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = if pkgs.stdenv.isDarwin then self.hfsevents else super.hinotify;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = if pkgs.stdenv.isDarwin
    then addBuildDepend (dontCheck super.fsnotify) pkgs.darwin.apple_sdk.frameworks.Cocoa
    else dontCheck super.fsnotify;

  # the system-fileio tests use canonicalizePath, which fails in the sandbox
  system-fileio = if pkgs.stdenv.isDarwin then dontCheck super.system-fileio else super.system-fileio;

  # Prevents needing to add security_tool as a build tool to all of x509-system's
  # dependencies.
  x509-system = if pkgs.stdenv.isDarwin && !pkgs.stdenv.cc.nativeLibc
    then let inherit (pkgs.darwin) security_tool;
      in pkgs.lib.overrideDerivation (addBuildDepend super.x509-system security_tool) (drv: {
        postPatch = (drv.postPatch or "") + ''
          substituteInPlace System/X509/MacOS.hs --replace security ${security_tool}/bin/security
        '';
      })
    else super.x509-system;

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

  # https://github.com/NixOS/cabal2nix/issues/136 and https://github.com/NixOS/cabal2nix/issues/216
  gio = disableHardening (addPkgconfigDepend (addBuildTool super.gio self.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  glib = disableHardening (addPkgconfigDepend (addBuildTool super.glib self.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  gtk3 = disableHardening (super.gtk3.override { inherit (pkgs) gtk3; }) ["fortify"];
  gtk = disableHardening (addPkgconfigDepend (addBuildTool super.gtk self.gtk2hs-buildtools) pkgs.gtk2) ["fortify"];
  gtksourceview2 = (addPkgconfigDepend super.gtksourceview2 pkgs.gtk2).override { inherit (pkgs.gnome2) gtksourceview; };
  gtksourceview3 = super.gtksourceview3.override { inherit (pkgs.gnome3) gtksourceview; };

  # Need WebkitGTK, not just webkit.
  webkit = super.webkit.override { webkit = pkgs.webkitgtk2; };
  webkitgtk3 = super.webkitgtk3.override { webkit = pkgs.webkitgtk24x; };
  webkitgtk3-javascriptcore = super.webkitgtk3-javascriptcore.override { webkit = pkgs.webkitgtk24x; };
  websnap = super.websnap.override { webkit = pkgs.webkitgtk24x; };

  # https://github.com/mvoidex/hsdev/issues/11
  hsdev = dontHaddock super.hsdev;

  hs-mesos = overrideCabal super.hs-mesos (drv: {
    # Pass _only_ mesos; the correct protobuf is propagated.
    extraLibraries = [ pkgs.mesos ];
    preConfigure = "sed -i -e /extra-lib-dirs/d -e 's|, /usr/include, /usr/local/include/mesos||' hs-mesos.cabal";
  });

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
  hapistrano = dontCheck super.hapistrano;
  HerbiePlugin = dontCheck super.HerbiePlugin;
  wai-cors = dontCheck super.wai-cors;

  # These packages try to access the network.
  amqp = dontCheck super.amqp;
  amqp-conduit = dontCheck super.amqp-conduit;
  bitcoin-api = dontCheck super.bitcoin-api;
  bitcoin-api-extra = dontCheck super.bitcoin-api-extra;
  bitx-bitcoin = dontCheck super.bitx-bitcoin;          # http://hydra.cryp.to/build/926187/log/raw
  concurrent-dns-cache = dontCheck super.concurrent-dns-cache;
  digitalocean-kzs = dontCheck super.digitalocean-kzs;  # https://github.com/KazumaSATO/digitalocean-kzs/issues/1
  github-types = dontCheck super.github-types;          # http://hydra.cryp.to/build/1114046/nixlog/1/raw
  hadoop-rpc = dontCheck super.hadoop-rpc;              # http://hydra.cryp.to/build/527461/nixlog/2/raw
  hasql = dontCheck super.hasql;                        # http://hydra.cryp.to/build/502489/nixlog/4/raw
  hasql-transaction = dontCheck super.hasql-transaction; # wants to connect to postgresql
  hjsonschema = overrideCabal super.hjsonschema (drv: { testTarget = "local"; });
  marmalade-upload = dontCheck super.marmalade-upload;  # http://hydra.cryp.to/build/501904/nixlog/1/raw
  mongoDB = dontCheck super.mongoDB;
  network-transport-tcp = dontCheck super.network-transport-tcp;
  network-transport-zeromq = dontCheck super.network-transport-zeromq; # https://github.com/tweag/network-transport-zeromq/issues/30
  pipes-mongodb = dontCheck super.pipes-mongodb;        # http://hydra.cryp.to/build/926195/log/raw
  raven-haskell = dontCheck super.raven-haskell;        # http://hydra.cryp.to/build/502053/log/raw
  riak = dontCheck super.riak;                          # http://hydra.cryp.to/build/498763/log/raw
  scotty-binding-play = dontCheck super.scotty-binding-play;
  servant-router = dontCheck super.servant-router;
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
  either-unwrap = dontCheck super.either-unwrap;        # http://hydra.cryp.to/build/498782/log/raw
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
  hPDB-examples = dontCheck super.hPDB-examples;
  hquery = dontCheck super.hquery;
  hs2048 = dontCheck super.hs2048;
  hsbencher = dontCheck super.hsbencher;
  hsexif = dontCheck super.hsexif;
  hspec-server = dontCheck super.hspec-server;
  HTF = dontCheck super.HTF;
  htsn = dontCheck super.htsn;
  htsn-import = dontCheck super.htsn-import;
  http-client-openssl = dontCheck super.http-client-openssl;
  http-client-tls = dontCheck super.http-client-tls;
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

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  vty = dontCheck super.vty;
  vty_5_14 = dontCheck super.vty_5_14;

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

  # Nix-specific workaround
  xmonad = appendPatch (dontCheck super.xmonad) ./patches/xmonad-nix.patch;

  # https://github.com/evanrinehart/mikmod/issues/1
  mikmod = addExtraLibrary super.mikmod pkgs.libmikmod;

  # https://github.com/basvandijk/threads/issues/10
  threads = dontCheck super.threads;

  # https://github.com/ucsd-progsys/liquid-fixpoint/issues/44
  liquid-fixpoint = overrideCabal super.liquid-fixpoint (drv: { preConfigure = "patchShebangs ."; });

  # Missing module.
  rematch = dontCheck super.rematch;            # https://github.com/tcrayford/rematch/issues/5
  rematch-text = dontCheck super.rematch-text;  # https://github.com/tcrayford/rematch/issues/6

  # no haddock since this is an umbrella package.
  cloud-haskell = dontHaddock super.cloud-haskell;

  # This packages compiles 4+ hours on a fast machine. That's just unreasonable.
  CHXHtml = dontDistribute super.CHXHtml;

  # https://github.com/NixOS/nixpkgs/issues/6350
  paypal-adaptive-hoops = overrideCabal super.paypal-adaptive-hoops (drv: { testTarget = "local"; });

  # https://github.com/afcowie/http-streams/issues/80
  http-streams = dontCheck super.http-streams;

  # https://github.com/vincenthz/hs-asn1/issues/12
  asn1-encoding = dontCheck super.asn1-encoding;

  # wxc supports wxGTX >= 3.0, but our current default version points to 2.8.
  # http://hydra.cryp.to/build/1331287/log/raw
  wxc = (addBuildDepend super.wxc self.split).override { wxGTK = pkgs.wxGTK30; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK30; };

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

  # https://github.com/alephcloud/hs-configuration-tools/issues/40
  configuration-tools = dontCheck super.configuration-tools;

  # Test suite wants to connect to $DISPLAY.
  hsqml = dontCheck (addExtraLibrary (super.hsqml.override { qt5 = pkgs.qt5Full; }) pkgs.mesa);

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

  # Tests attempt to use NPM to install from the network into
  # /homeless-shelter. Disabled.
  purescript = dontCheck super.purescript;

  # Requires bower-json >= 1.0.0.1 && < 1.1
  purescript_0_10_5 = super.purescript_0_10_5.overrideScope (self: super: {
    bower-json = self.bower-json_1_0_0_1;
  });

  # https://github.com/tych0/xcffib/issues/37
  xcffib = dontCheck super.xcffib;

  # https://github.com/afcowie/locators/issues/1
  locators = dontCheck super.locators;

  # https://github.com/haskell/haddock/issues/378
  haddock-library = dontCheck super.haddock-library;

  # https://github.com/anton-k/csound-expression-dynamic/issues/1
  csound-expression-dynamic = dontHaddock super.csound-expression-dynamic;

  # Hardcoded include path
  poppler = overrideCabal super.poppler (drv: {
    postPatch = ''
      sed -i -e 's,glib/poppler.h,poppler.h,' poppler.cabal
      sed -i -e 's,glib/poppler.h,poppler.h,' Graphics/UI/Gtk/Poppler/Structs.hsc
    '';
  });

  # Uses OpenGL in testing
  caramia = dontCheck super.caramia;

  llvm-general-darwin = overrideCabal (super.llvm-general.override { llvm-config = pkgs.llvm_35; }) (drv: {
      preConfigure = ''
        sed -i llvm-general.cabal \
            -e 's,extra-libraries: stdc++,extra-libraries: c++,'
      '';
      configureFlags = (drv.configureFlags or []) ++ ["--extra-include-dirs=${pkgs.libcxx}/include/c++/v1"];
      librarySystemDepends = [ pkgs.libcxx ] ++ drv.librarySystemDepends or [];
    });

  # Supports only 3.5 for now, https://github.com/bscarlet/llvm-general/issues/142
  llvm-general =
    if pkgs.stdenv.isDarwin
    then self.llvm-general-darwin
    else super.llvm-general.override { llvm-config = pkgs.llvm_35; };

  # Needs help finding LLVM.
  spaceprobe = addBuildTool super.spaceprobe self.llvmPackages.llvm;

  # Tries to run GUI in tests
  leksah = dontCheck (overrideCabal super.leksah (drv: {
    executableSystemDepends = (drv.executableSystemDepends or []) ++ (with pkgs; [
      gnome3.defaultIconTheme # Fix error: Icon 'window-close' not present in theme ...
      wrapGAppsHook           # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
      gtk3                    # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ]);
    postPatch = (drv.postPatch or "") + ''
      for f in src/IDE/Leksah.hs src/IDE/Utils/ServerConnection.hs
      do
        substituteInPlace "$f" --replace "\"leksah-server\"" "\"${self.leksah-server}/bin/leksah-server\""
      done
    '';
  }));

  # Requires optparse-applicative 0.13.0.0
  diagrams-pgf = super.diagrams-pgf.overrideScope (self: super: {
    optparse-applicative = self.optparse-applicative_0_13_0_0;
  });

  # Patch to consider NIX_GHC just like xmonad does
  dyre = appendPatch super.dyre ./patches/dyre-nix.patch;

  # Test suite won't compile against tasty-hunit 0.9.x.
  zlib = dontCheck super.zlib;

  # https://github.com/ndmitchell/shake/issues/206
  # https://github.com/ndmitchell/shake/issues/267
  shake = overrideCabal super.shake (drv: { doCheck = !pkgs.stdenv.isDarwin && false; });

  # https://github.com/nushio3/doctest-prop/issues/1
  doctest-prop = dontCheck super.doctest-prop;

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

  yesod-bin = if pkgs.stdenv.isDarwin
    then addBuildDepend super.yesod-bin pkgs.darwin.apple_sdk.frameworks.Cocoa
    else super.yesod-bin;

  hmatrix = if pkgs.stdenv.isDarwin
    then addBuildDepend super.hmatrix pkgs.darwin.apple_sdk.frameworks.Accelerate
    else super.hmatrix;

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

  # https://github.com/ekmett/wl-pprint-terminfo/issues/7
  wl-pprint-terminfo = addExtraLibrary super.wl-pprint-terminfo pkgs.ncurses;

  # https://github.com/bos/pcap/issues/5
  pcap = addExtraLibrary super.pcap pkgs.libpcap;

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
    # Bump version to latest git-version to get support for Emacs 25.x.
    version = "1.0.20-28-g1ffb4db";
    src = pkgs.fetchFromGitHub {
      owner = "chrisdone";
      repo = "structured-haskell-mode";
      rev = "dde5104ee28e1c63ca9fbc37c969f8e319b4b903";
      sha256 = "0g5qpnxzr9qmgzvsld5mg94rb28xb8kd1a02q045r6zlmv1zx7lp";
    };
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
  shelly = dontCheck super.shelly;

  # https://github.com/bos/configurator/issues/22
  configurator = dontCheck super.configurator;

  # The cabal files for these libraries do not list the required system dependencies.
  miniball = overrideCabal super.miniball (drv: {
    librarySystemDepends = [ pkgs.miniball ];
  });
  SDL-image = overrideCabal super.SDL-image (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_image ] ++ drv.librarySystemDepends or [];
  });
  SDL-ttf = overrideCabal super.SDL-ttf (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_ttf ];
  });
  SDL-mixer = overrideCabal super.SDL-mixer (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_mixer ];
  });
  SDL-gfx = overrideCabal super.SDL-gfx (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_gfx ];
  });
  SDL-mpeg = overrideCabal super.SDL-mpeg (drv: {
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.smpeg}/lib"
      "--extra-include-dirs=${pkgs.smpeg}/include/smpeg"
    ];
  });

  # https://github.com/ivanperez-keera/hcwiid/pull/4
  hcwiid = overrideCabal super.hcwiid (drv: {
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.bluez.out}/lib"
      "--extra-lib-dirs=${pkgs.cwiid}/lib"
      "--extra-include-dirs=${pkgs.cwiid}/include"
      "--extra-include-dirs=${pkgs.bluez.dev}/include"
    ];
    prePatch = '' sed -i -e "/Extra-Lib-Dirs/d" -e "/Include-Dirs/d" "hcwiid.cabal" '';
  });

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

  # cabal2nix doesn't pick up some of the dependencies.
  ginsu = let
    g = addBuildDepend super.ginsu pkgs.perl;
    g' = overrideCabal g (drv: {
      executableSystemDepends = (drv.executableSystemDepends or []) ++ [
        pkgs.ncurses
      ];
    });
  in g';

  # https://github.com/guillaume-nargeot/hpc-coveralls/issues/52
  hpc-coveralls = disableSharedExecutables super.hpc-coveralls;

  # https://github.com/fpco/stackage/issues/838
  cryptonite = dontCheck super.cryptonite;

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/sol/hpack/issues/53
  hpack = dontCheck super.hpack;

  # Tests require `docker` command in PATH
  # Tests require running docker service :on localhost
  docker = dontCheck super.docker;

  # https://github.com/deech/fltkhs/issues/16
  fltkhs = overrideCabal super.fltkhs (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [pkgs.autoconf];
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.fltk13 pkgs.mesa_noglu pkgs.libjpeg];
    broken = true;      # linking fails because the build doesn't pull in the mesa libraries
  });
  fltkhs-fluid-examples = dontDistribute super.fltkhs-fluid-examples;

  # https://github.com/skogsbaer/hscurses/pull/26
  hscurses = overrideCabal super.hscurses (drv: {
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [ pkgs.ncurses ];
  });

  # We get lots of strange compiler errors during the test suite run.
  jsaddle = dontCheck super.jsaddle;

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

  # Haste stuff
  haste-Cabal         = markBroken (self.callPackage ../tools/haskell/haste/haste-Cabal.nix {});
  haste-cabal-install = markBroken (self.callPackage ../tools/haskell/haste/haste-cabal-install.nix { Cabal = self.haste-Cabal; });
  haste-compiler      = markBroken (self.callPackage ../tools/haskell/haste/haste-compiler.nix { inherit overrideCabal; super-haste-compiler = super.haste-compiler; });

  # Ensure the necessary frameworks are propagatedBuildInputs on darwin
  OpenGLRaw = overrideCabal super.OpenGLRaw (drv: {
    librarySystemDepends =
      pkgs.lib.optionals (!pkgs.stdenv.isDarwin) drv.librarySystemDepends;
    libraryHaskellDepends = drv.libraryHaskellDepends
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin
                            [ pkgs.darwin.apple_sdk.frameworks.OpenGL ];
    preConfigure = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      frameworkPaths=($(for i in $nativeBuildInputs; do if [ -d "$i"/Library/Frameworks ]; then echo "-F$i/Library/Frameworks"; fi done))
      frameworkPaths=$(IFS=, ; echo "''${frameworkPaths[@]}")
      configureFlags+=$(if [ -n "$frameworkPaths" ]; then echo -n "--ghc-options=-optl=$frameworkPaths"; fi)
    '';
  });
  GLURaw = overrideCabal super.GLURaw (drv: {
    librarySystemDepends =
      pkgs.lib.optionals (!pkgs.stdenv.isDarwin) drv.librarySystemDepends;
    libraryHaskellDepends = drv.libraryHaskellDepends
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin
                            [ pkgs.darwin.apple_sdk.frameworks.OpenGL ];
  });
  bindings-GLFW = overrideCabal super.bindings-GLFW (drv: {
    doCheck = false; # requires an active X11 display
    librarySystemDepends =
      pkgs.lib.optionals (!pkgs.stdenv.isDarwin) drv.librarySystemDepends;
    libraryHaskellDepends = drv.libraryHaskellDepends
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin
                            (with pkgs.darwin.apple_sdk.frameworks;
                             [ AGL Cocoa OpenGL IOKit Kernel CoreVideo
                               pkgs.darwin.CF ]);
  });
  OpenCL = overrideCabal super.OpenCL (drv: {
    librarySystemDepends =
      pkgs.lib.optionals (!pkgs.stdenv.isDarwin) drv.librarySystemDepends;
    libraryHaskellDepends = drv.libraryHaskellDepends
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin
                            [ pkgs.darwin.apple_sdk.frameworks.OpenCL ];
  });

  # tinc is a new build driver a la Stack that's not yet available from Hackage.
  tinc = self.callPackage ../tools/haskell/tinc {};

  # Tools that use gtk2hs-buildtools now depend on them in a custom-setup stanza
  cairo = addBuildTool super.cairo self.gtk2hs-buildtools;
  pango = disableHardening (addBuildTool super.pango self.gtk2hs-buildtools) ["fortify"];

  # Fix tests which would otherwise fail with "Couldn't launch intero process."
  intero = overrideCabal super.intero (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace src/test/Main.hs --replace "\"intero\"" "\"$PWD/dist/build/intero/intero\""
    '';
  });

  # The most current version needs some packages to build that are not in LTS 7.x.
  stack = super.stack.overrideScope (self: super: {
    http-client = self.http-client_0_5_5;
    http-client-tls = self.http-client-tls_0_3_3_1;
    http-conduit = self.http-conduit_2_2_3;
    optparse-applicative = dontCheck self.optparse-applicative_0_13_0_0;
    criterion = super.criterion.override { inherit (super) optparse-applicative; };
    aeson = self.aeson_1_0_2_1;
    hpack = self.hpack_0_15_0;
  });

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

  # Test suite fails a QuickCheck property.
  optparse-applicative_0_13_0_0 = dontCheck super.optparse-applicative_0_13_0_0;

  # GLUT uses `dlopen` to link to freeglut, so we need to set the RUNPATH correctly for
  # it to find `libglut.so` from the nix store. We do this by patching GLUT.cabal to pkg-config
  # depend on freeglut, which provides GHC to necessary information to generate a correct RPATH.
  #
  # Note: Simply patching the dynamic library (.so) of the GLUT build will *not* work, since the
  # RPATH also needs to be propagated when using static linking. GHC automatically handles this for
  # us when we patch the cabal file (Link options will be recored in the ghc package registry).
  #
  # Additional note: nixpkgs' freeglut and macOS's OpenGL implementation do not cooperate,
  # so disable this on Darwin only
  ${if pkgs.stdenv.isDarwin then null else "GLUT"} = addPkgconfigDepend (appendPatch super.GLUT ./patches/GLUT.patch) pkgs.freeglut;

  # https://github.com/Philonous/hs-stun/pull/1
  # Remove if a version > 0.1.0.1 ever gets released.
  stunclient = overrideCabal super.stunclient (drv: {
    postPatch = (drv.postPatch or "") + ''
      substituteInPlace source/Network/Stun/MappedAddress.hs --replace "import Network.Endian" ""
    '';
  });

  idris = overrideCabal super.idris (drv: {
    # "idris" binary cannot find Idris library otherwise while building. After
    # installing it's completely fine though. This seems like a bug in Idris
    # that's related to builds with shared libraries enabled. It would be great
    # if someone who knows a thing or two about Idris could look into this.
    preBuild = "export LD_LIBRARY_PATH=$PWD/dist/build:$LD_LIBRARY_PATH";
    # https://github.com/idris-lang/Idris-dev/issues/2499
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.gmp];
    # test suite cannot find its own "idris" binary
    doCheck = false;
  });

  # https://github.com/bos/math-functions/issues/25
  math-functions = dontCheck super.math-functions;

  # http-api-data_0.3.x requires QuickCheck > 2.9, but overriding that version
  # is hard because of transitive dependencies, so we just disable tests.
  http-api-data_0_3_5 = dontCheck super.http-api-data_0_3_5;

  # Fix build for latest versions of servant and servant-client.
  servant_0_9_1_1 = super.servant_0_9_1_1.overrideScope (self: super: {
    http-api-data = self.http-api-data_0_3_5;
  });
  servant-client_0_9_1_1 = super.servant-client_0_9_1_1.overrideScope (self: super: {
    http-api-data = self.http-api-data_0_3_5;
    servant-server = self.servant-server_0_9_1_1;
    servant = self.servant_0_9_1_1;
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
          sha256 = "0fynv77m7rk79pdp535c2a2bd44csgr32zb4wqavbalr7grpxg4q";
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

  servant-auth-server = super.servant-auth-server.overrideScope (self: super: {
    jose = super.jose_0_5_0_2;
  });

  # https://github.com/pontarius/pontarius-xmpp/issues/105
  pontarius-xmpp = dontCheck super.pontarius-xmpp;

  # https://github.com/fpco/store/issues/77
  store = dontCheck super.store;
  store_0_3 = super.store_0_3.overrideScope (self: super: { store-core = self.store-core_0_3; });

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = doJailbreak super.applicative-quoters;

  # https://github.com/roelvandijk/terminal-progress-bar/issues/13
  terminal-progress-bar = doJailbreak super.terminal-progress-bar;

  # https://github.com/vshabanov/HsOpenSSL/issues/11
  HsOpenSSL = doJailbreak super.HsOpenSSL;

  # https://github.com/NixOS/nixpkgs/issues/19612
  wai-app-file-cgi = (dontCheck super.wai-app-file-cgi).overrideScope (self: super: {
    http-client = self.http-client_0_5_5;
    http-client-tls = self.http-client-tls_0_3_3_1;
    http-conduit = self.http-conduit_2_2_3;
  });

  # https://hydra.nixos.org/build/42769611/nixlog/1/raw
  # note: the library is unmaintained, no upstream issue
  dataenc = doJailbreak super.dataenc;

  libsystemd-journal = overrideCabal super.libsystemd-journal (old: {
    librarySystemDepends = old.librarySystemDepends or [] ++ [ pkgs.systemd ];
  });

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

  socket_0_7_0_0 = super.socket_0_7_0_0.overrideScope (self: super: { QuickCheck = self.QuickCheck_2_9_2; });

  # Encountered missing dependencies: hspec >=1.3 && <2.1
  # https://github.com/rampion/ReadArgs/issues/8
  ReadArgs = doJailbreak super.ReadArgs;

  # https://github.com/philopon/barrier/issues/3
  barrier = doJailbreak super.barrier;

  # requires vty 5.13
  brick = super.brick.overrideScope (self: super: { vty = self.vty_5_14; });

  # https://github.com/krisajenkins/elm-export/pull/22
  elm-export = doJailbreak super.elm-export;

  turtle_1_3_1 = super.turtle_1_3_1.overrideScope (self: super: {
    optparse-applicative = self.optparse-applicative_0_13_0_0;
  });

  lentil = super.lentil.overrideScope (self: super: {
    pipes = self.pipes_4_3_2;
    optparse-applicative = self.optparse-applicative_0_13_0_0;
    # https://github.com/roelvandijk/terminal-progress-bar/issues/14
    terminal-progress-bar = doJailbreak self.terminal-progress-bar_0_1_1;
  });
}
