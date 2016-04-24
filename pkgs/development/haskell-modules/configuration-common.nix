{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Some packages need a non-core version of Cabal.
  Cabal_1_18_1_7 = dontCheck super.Cabal_1_18_1_7;
  Cabal_1_20_0_4 = dontCheck super.Cabal_1_20_0_4;
  Cabal_1_22_4_0 = dontCheck super.Cabal_1_22_4_0;
  cabal-install = (dontCheck super.cabal-install).overrideScope (self: super: { Cabal = self.Cabal_1_22_4_0; });
  cabal-install_1_18_1_0 = (dontCheck super.cabal-install_1_18_1_0).overrideScope (self: super: { Cabal = self.Cabal_1_18_1_7; });

  # Link statically to avoid runtime dependency on GHC.
  jailbreak-cabal = (disableSharedExecutables super.jailbreak-cabal).override { Cabal = dontJailbreak self.Cabal_1_20_0_4; };

  # Apply NixOS-specific patches.
  ghc-paths = appendPatch super.ghc-paths ./patches/ghc-paths-nix.patch;

  # Break infinite recursions.
  clock = dontCheck super.clock;
  Dust-crypto = dontCheck super.Dust-crypto;
  hasql-postgres = dontCheck super.hasql-postgres;
  hspec_2_1_2 = super.hspec_2_1_2.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_3 = super.hspec_2_1_3.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_4 = super.hspec_2_1_4.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_5 = super.hspec_2_1_5.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_6 = super.hspec_2_1_6.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_7 = super.hspec_2_1_7.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_1_10 = super.hspec_2_1_10.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_2_1 = super.hspec_2_2_1.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec_2_2_2 = super.hspec_2_2_2.override { stringbuilder = dontCheck super.stringbuilder; };
  hspec-expectations_0_6_1_1 = dontCheck super.hspec-expectations_0_6_1_1;
  hspec-expectations_0_6_1 = dontCheck super.hspec-expectations_0_6_1;
  hspec-expectations_0_7_1 = dontCheck super.hspec-expectations_0_7_1;
  hspec-expectations = dontCheck super.hspec-expectations;
  hspec = super.hspec.override { stringbuilder = dontCheck super.stringbuilder; };
  HTTP = dontCheck super.HTTP;
  nanospec_0_2_0 = dontCheck super.nanospec_0_2_0;
  nanospec = dontCheck super.nanospec;
  options_1_2_1 = dontCheck super.options_1_2_1;
  options_1_2 = dontCheck super.options_1_2;
  options = dontCheck super.options;
  statistics = dontCheck super.statistics;
  c2hs = dontCheck super.c2hs;
  epanet-haskell = super.epanet-haskell.overrideDerivation (drv: {
    hardeningDisable = [ "format" ];
  });

  # Use the default version of mysql to build this package (which is actually mariadb).
  mysql = super.mysql.override { mysql = pkgs.mysql.lib; };

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # This package needs a little help compiling properly on Darwin. Furthermore,
  # Stackage compiles git-annex without the Assistant, supposedly because not
  # all required dependencies are part of Stackage. To comply with Stackage, we
  # make 'git-annex-without-assistant' our default version, but offer another
  # build which has the assistant to be used in the top-level.
  git-annex_5_20150727 = (disableCabalFlag super.git-annex_5_20150727 "assistant").override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    lsof = if pkgs.stdenv.isLinux then pkgs.lsof else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };
  git-annex = (disableCabalFlag super.git-annex "assistant").override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    lsof = if pkgs.stdenv.isLinux then pkgs.lsof else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  };
  git-annex-with-assistant = super.git-annex.override {
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
  HDBC-odbc = dontHaddock super.HDBC-odbc;
  hoodle-core = dontHaddock super.hoodle-core;
  hsc3-db = dontHaddock super.hsc3-db;
  hspec-discover_2_1_10 = dontHaddock super.hspec-discover_2_1_10;
  hspec-discover_2_1_2 = dontHaddock super.hspec-discover_2_1_2;
  hspec-discover_2_1_3 = dontHaddock super.hspec-discover_2_1_3;
  hspec-discover_2_1_4 = dontHaddock super.hspec-discover_2_1_4;
  hspec-discover_2_1_5 = dontHaddock super.hspec-discover_2_1_5;
  hspec-discover_2_1_6 = dontHaddock super.hspec-discover_2_1_6;
  hspec-discover_2_1_7 = dontHaddock super.hspec-discover_2_1_7;
  hspec-discover = dontHaddock super.hspec-discover;
  http-client-conduit = dontHaddock super.http-client-conduit;
  http-client-multipart = dontHaddock super.http-client-multipart;
  markdown-unlit = dontHaddock super.markdown-unlit;
  network-conduit = dontHaddock super.network-conduit;
  shakespeare-js = dontHaddock super.shakespeare-js;
  shakespeare-text = dontHaddock super.shakespeare-text;
  wai-test = dontHaddock super.wai-test;
  zlib-conduit = dontHaddock super.zlib-conduit;

  # The test suite won't even start.
  darcs = dontCheck super.darcs;

  # https://github.com/massysett/rainbox/issues/1
  rainbox = dontCheck super.rainbox;

  # https://github.com/techtangents/ablist/issues/1
  ABList = dontCheck super.ABList;

  # https://github.com/haskell/vector/issues/47
  vector = if pkgs.stdenv.isi686 then appendConfigureFlag super.vector "--ghc-options=-msse2" else super.vector;

  halive = if pkgs.stdenv.isDarwin
    then addBuildDepend super.halive pkgs.darwin.apple_sdk.frameworks.AppKit
    else super.halive;

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is really required
  # on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = if pkgs.stdenv.isDarwin then self.hfsevents else super.hinotify;

  # hfsevents needs CoreServices in scope
  hfsevents = if pkgs.stdenv.isDarwin
    then with pkgs.darwin.apple_sdk.frameworks; addBuildTool (addBuildDepends super.hfsevents [Cocoa]) CoreServices
    else super.hfsevents;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = dontCheck super.fsnotify; # if pkgs.stdenv.isDarwin then dontCheck super.fsnotify else super.fsnotify;

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

  # tests don't compile for some odd reason
  jwt = dontCheck super.jwt;

  # https://github.com/NixOS/cabal2nix/issues/136
  gio = addPkgconfigDepend super.gio pkgs.glib;
  gio_0_13_0_3 = addPkgconfigDepend super.gio_0_13_0_3 pkgs.glib;
  gio_0_13_0_4 = addPkgconfigDepend super.gio_0_13_0_4 pkgs.glib;
  gio_0_13_1_0 = addPkgconfigDepend super.gio_0_13_1_0 pkgs.glib;
  glib = pkgs.lib.overrideDerivation (addPkgconfigDepend super.glib pkgs.glib) (drv: {
    hardeningDisable = [ "fortify" ];
  });
  gtk3 = super.gtk3.override { inherit (pkgs) gtk3; };
  gtk = addPkgconfigDepend super.gtk pkgs.gtk;
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
  hakyll = dontCheck super.hakyll;
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
  setenv_0_1_1_1 = dontCheck super.setenv_0_1_1_1;
  snowball = dontCheck super.snowball;
  sophia = dontCheck super.sophia;
  test-sandbox = dontCheck super.test-sandbox;
  users-postgresql-simple = dontCheck super.users-postgresql-simple;
  wai-middleware-hmac = dontCheck super.wai-middleware-hmac;
  xkbcommon = dontCheck super.xkbcommon;
  xmlgen = dontCheck super.xmlgen;
  hapistrano = dontCheck super.hapistrano;
  HerbiePlugin = dontCheck super.HerbiePlugin;

  # These packages try to access the network.
  amqp-conduit = dontCheck super.amqp-conduit;
  amqp = dontCheck super.amqp;
  bitcoin-api = dontCheck super.bitcoin-api;
  bitcoin-api-extra = dontCheck super.bitcoin-api-extra;
  bitx-bitcoin = dontCheck super.bitx-bitcoin;          # http://hydra.cryp.to/build/926187/log/raw
  concurrent-dns-cache = dontCheck super.concurrent-dns-cache;
  dbus = dontCheck super.dbus;                          # http://hydra.cryp.to/build/498404/log/raw
  digitalocean-kzs = dontCheck super.digitalocean-kzs;  # https://github.com/KazumaSATO/digitalocean-kzs/issues/1
  github-types = dontCheck super.github-types;          # http://hydra.cryp.to/build/1114046/nixlog/1/raw
  hadoop-rpc = dontCheck super.hadoop-rpc;              # http://hydra.cryp.to/build/527461/nixlog/2/raw
  hasql = dontCheck super.hasql;                        # http://hydra.cryp.to/build/502489/nixlog/4/raw
  hjsonschema = overrideCabal (super.hjsonschema.override { hjsonpointer = self.hjsonpointer_0_2_0_4; }) (drv: { testTarget = "local"; });
  hoogle = overrideCabal super.hoogle (drv: { testTarget = "--test-option=--no-net"; });
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
  etcd = dontCheck super.etcd;
  fb = dontCheck super.fb;                              # needs credentials for Facebook
  fptest = dontCheck super.fptest;                      # http://hydra.cryp.to/build/499124/log/raw
  ghc-events = dontCheck super.ghc-events;              # http://hydra.cryp.to/build/498226/log/raw
  ghc-events-parallel = dontCheck super.ghc-events-parallel;    # http://hydra.cryp.to/build/496828/log/raw
  ghcid = dontCheck super.ghcid;
  ghc-imported-from = dontCheck super.ghc-imported-from;
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
  HTF_0_12_2_3 = dontCheck super.HTF_0_12_2_3;
  HTF_0_12_2_4 = dontCheck super.HTF_0_12_2_4;
  HTF_0_13_0_0 = dontCheck super.HTF_0_13_0_0;
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
  ldap-client = dontCheck super.ldap-client;
  lensref = dontCheck super.lensref;
  liquidhaskell = dontCheck super.liquidhaskell;
  lucid = dontCheck super.lucid; #https://github.com/chrisdone/lucid/issues/25
  lvmrun = pkgs.lib.overrideDerivation (dontCheck super.lvmrun) (drv: {
    hardeningDisable = [ "format" ];
  });
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
  shake-language-c_0_6_3 = dontCheck super.shake-language-c_0_6_3;
  shake-language-c_0_6_4 = dontCheck super.shake-language-c_0_6_4;
  shake-language-c_0_8_0 = dontCheck super.shake-language-c_0_8_0;
  static-resources = dontCheck super.static-resources;
  strive = dontCheck super.strive;                      # fails its own hlint test with tons of warnings
  svndump = dontCheck super.svndump;
  tar = dontCheck super.tar; #http://hydra.nixos.org/build/25088435/nixlog/2 (fails only on 32-bit)
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

  # https://github.com/vincenthz/hs-crypto-pubkey/issues/20
  crypto-pubkey = dontCheck super.crypto-pubkey;

  # https://github.com/Gabriel439/Haskell-Turtle-Library/issues/1
  turtle = dontCheck super.turtle;

  # https://github.com/Philonous/xml-picklers/issues/5
  xml-picklers = dontCheck super.xml-picklers;

  # https://github.com/joeyadams/haskell-stm-delay/issues/3
  stm-delay = dontCheck super.stm-delay;

  # https://github.com/cgaebel/stm-conduit/issues/33
  stm-conduit = dontCheck super.stm-conduit;

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

  # https://github.com/jgm/pandoc/issues/2709
  pandoc = disableSharedExecutables super.pandoc;

  # Tests attempt to use NPM to install from the network into
  # /homeless-shelter. Disabled.
  purescript = dontCheck super.purescript;

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

  # Supports only 3.5 for now, https://github.com/bscarlet/llvm-general/issues/142
  llvm-general = super.llvm-general.override { llvm-config = pkgs.llvm_35; };

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

  # Patch to consider NIX_GHC just like xmonad does
  dyre = appendPatch super.dyre ./patches/dyre-nix.patch;

  # Test suite won't compile against tasty-hunit 0.9.x.
  zlib = dontCheck super.zlib;

  # Override the obsolete version from Hackage with our more up-to-date copy.
  cabal2nix = self.callPackage ../tools/haskell/cabal2nix/cabal2nix.nix {};
  hackage2nix = self.callPackage ../tools/haskell/cabal2nix/hackage2nix.nix {};
  distribution-nixpkgs = self.callPackage ../tools/haskell/cabal2nix/distribution-nixpkgs.nix {};

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

  # https://github.com/commercialhaskell/stack/issues/408
  # https://github.com/commercialhaskell/stack/issues/409
  stack = overrideCabal super.stack (drv: { preCheck = "export HOME=$TMPDIR"; doCheck = false; });

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

  # Byte-compile elisp code for Emacs.
  structured-haskell-mode = overrideCabal super.structured-haskell-mode (drv: {
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.emacs];
    postInstall = ''
      local lispdir=( "$out/share/"*"-${self.ghc.name}/${drv.pname}-${drv.version}/elisp" )
      pushd >/dev/null $lispdir
      for i in *.el; do
        emacs -Q -L . -L ${pkgs.emacs24Packages.haskellMode}/share/emacs/site-lisp \
          --batch --eval "(byte-compile-disable-warning 'cl-functions)" \
          -f batch-byte-compile $i
      done
      popd >/dev/null
      mkdir -p $out/share/emacs
      ln -s $lispdir $out/share/emacs/site-lisp
    '';
  });

  # Byte-compile elisp code for Emacs.
  hindent = overrideCabal super.hindent (drv: {
    # https://github.com/chrisdone/hindent/issues/166
    doCheck = false;
    executableToolDepends = drv.executableToolDepends or [] ++ [pkgs.emacs];
    postInstall = ''
      local lispdir=( "$out/share/"*"-${self.ghc.name}/${drv.pname}-${drv.version}/elisp" )
      pushd >/dev/null $lispdir
      for i in *.el; do
        emacs -Q -L . -L ${pkgs.emacs24Packages.haskellMode}/share/emacs/site-lisp \
          --batch --eval "(byte-compile-disable-warning 'cl-functions)" \
          -f batch-byte-compile $i
      done
      popd >/dev/null
      mkdir -p $out/share/emacs
      ln -s $lispdir $out/share/emacs/site-lisp
    '';
  });

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
      "--extra-lib-dirs=${pkgs.bluez}/lib"
      "--extra-lib-dirs=${pkgs.cwiid}/lib"
      "--extra-include-dirs=${pkgs.cwiid}/include"
      "--extra-include-dirs=${pkgs.bluez}/include"
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
  hpc-coveralls_0_9_0 = disableSharedExecutables super.hpc-coveralls_0_9_0;

  # Test suite won't compile.
  semigroupoids_5_0_0_3 = dontCheck super.semigroupoids_5_0_0_3;

  # This is fixed in newer versions.
  zip-archive_0_2_3_5 = addBuildTool super.zip-archive_0_2_3_5 pkgs.zip;

  # https://github.com/fpco/stackage/issues/838
  cryptonite = dontCheck super.cryptonite;
  cryptonite_0_6   = dontCheck super.cryptonite_0_6  ;

  # https://github.com/fpco/stackage/issues/843
  hmatrix-gsl-stats_0_4_1 = overrideCabal super.hmatrix-gsl-stats_0_4_1 (drv: {
    postUnpack = "rm */Setup.lhs";
  });

  # We cannot build this package w/o the C library from <http://www.phash.org/>.
  phash = markBroken super.phash;

  # https://github.com/yesodweb/serversession/issues/2
  # https://github.com/haskell/cabal/issues/2661
  serversession-backend-acid-state_1_0_1 = dontCheck super.serversession-backend-acid-state_1_0_1;

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

  # https://github.com/mainland/language-c-quote/issues/57
  language-c-quote = super.language-c-quote.override { alex = self.alex_3_1_4; };

  # https://github.com/agda/agda/issues/1840
  Agda_2_4_2_3 = super.Agda_2_4_2_3.override {
    unordered-containers = self.unordered-containers_0_2_5_1;
    cpphs = self.cpphs_1_19_3;
  };
  Agda_2_4_2_4 = super.Agda_2_4_2_4.override {
    unordered-containers = self.unordered-containers_0_2_5_1;
    cpphs = self.cpphs_1_19_3;
  };
  Agda = super.Agda.override {
    unordered-containers = self.unordered-containers_0_2_5_1;
    cpphs = self.cpphs_1_19_3;
  };

  # We get lots of strange compiler errors during the test suite run.
  jsaddle = dontCheck super.jsaddle;

  # https://github.com/gwern/mueval/issues/14
  mueval = super.mueval.override { hint = self.hint_0_4_3; };

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

  # https://github.com/danidiaz/pipes-transduce/issues/2
  pipes-transduce = super.pipes-transduce.override { foldl = self.foldl_1_1_6; };

  # Haste stuff
  haste-Cabal         = self.callPackage ../tools/haskell/haste/haste-Cabal.nix {};
  haste-cabal-install = self.callPackage ../tools/haskell/haste/haste-cabal-install.nix { Cabal = self.haste-Cabal; HTTP = self.HTTP_4000_2_23; };
  haste-compiler      = self.callPackage ../tools/haskell/haste/haste-compiler.nix { inherit overrideCabal; super-haste-compiler = super.haste-compiler; };

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

  # Tests must be disabled on darwin for all versions of c2hs
  # (e.g. Stackage LTS releases).
  c2hs_0_20_1 = if pkgs.stdenv.isDarwin
                then dontCheck super.c2hs_0_20_1
                else super.c2hs_0_20_1;
  c2hs_0_25_2 = if pkgs.stdenv.isDarwin
                then dontCheck super.c2hs_0_25_2
                else super.c2hs_0_25_2;
  c2hs_0_27_1 = if pkgs.stdenv.isDarwin
                then dontCheck super.c2hs_0_27_1
                else super.c2hs_0_27_1;
}
