# NIX-SPECIFIC OVERRIDES/PATCHES FOR HASKELL PACKAGES
#
# This file contains overrides which are needed because of Nix. For example,
# some packages may need help finding the location of native libraries. In
# general, overrides in this file are (mostly) due to one of the following reasons:
#
# * packages that hard code the location of native libraries, so they need to be patched/
#   supplied the patch explicitly
# * passing native libraries that are not detected correctly by cabal2nix
# * test suites that fail due to some features not available in the nix sandbox
#   (networking being a common one)
#
# In general, this file should *not* contain overrides that fix build failures that could
# also occur on standard, FHS-compliant non-Nix systems. For example, if tests have a compile
# error, that is a bug in the package, and that failure has nothing to do with Nix.
#
# Common examples which should *not* be a part of this file:
#
# * overriding a specific version of a haskell library because some package fails
#   to build with a newer version. Such overrides have nothing to do with Nix itself,
#   and they would also be neccessary outside of Nix if you use the same set of
#   package versions.
# * disabling tests that fail due to missing files in the tarball or compile errors
# * disabling tests that require too much memory
# * enabling/disabling certain features in packages
#
# If you have an override of this kind, see configuration-common.nix instead.
{ pkgs, haskellLib }:

with haskellLib;

# All of the overrides in this set should look like:
#
#   foo = ... something involving super.foo ...
#
# but that means that we add `foo` attribute even if there is no `super.foo`! So if
# you want to use this configuration for a package set that only contains a subset of
# the packages that have overrides defined here, you'll end up with a set that contains
# a bunch of attributes that trigger an evaluation error.
#
# To avoid this, we use `intersectAttrs` here so we never add packages that are not present
# in the parent package set (`super`).
self: super: builtins.intersectAttrs super {

  # Apply NixOS-specific patches.
  ghc-paths = appendPatch ./patches/ghc-paths-nix.patch super.ghc-paths;

  # fix errors caused by hardening flags
  epanet-haskell = disableHardening ["format"] super.epanet-haskell;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # Use the default version of mysql to build this package (which is actually mariadb).
  # test phase requires networking
  mysql = dontCheck super.mysql;

  # CUDA needs help finding the SDK headers and libraries.
  cuda = overrideCabal (drv: {
    extraLibraries = (drv.extraLibraries or []) ++ [pkgs.linuxPackages.nvidia_x11];
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.cudatoolkit.lib}/lib"
      "--extra-include-dirs=${pkgs.cudatoolkit}/include"
    ];
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
    '';
  }) super.cuda;

  nvvm = overrideCabal (drv: {
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
    '';
  }) super.nvvm;

  cufft = overrideCabal (drv: {
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
    '';
  }) super.cufft;

  # jni needs help finding libjvm.so because it's in a weird location.
  jni = overrideCabal (drv: {
    preConfigure = ''
      local libdir=( "${pkgs.jdk}/lib/openjdk/jre/lib/"*"/server" )
      configureFlags+=" --extra-lib-dir=''${libdir[0]}"
    '';
  }) super.jni;

  # The package doesn't know about the AL include hierarchy.
  # https://github.com/phaazon/al/issues/1
  al = appendConfigureFlag "--extra-include-dirs=${pkgs.openal}/include/AL" super.al;

  # Won't find it's header files without help.
  sfml-audio = appendConfigureFlag "--extra-include-dirs=${pkgs.openal}/include/AL" super.sfml-audio;

  # avoid compiling twice by providing executable as a separate output (with small closure size)
  niv = enableSeparateBinOutput super.niv;
  ormolu = enableSeparateBinOutput super.ormolu;
  ghcid = enableSeparateBinOutput super.ghcid;

  hzk = overrideCabal (drv: {
    preConfigure = "sed -i -e /include-dirs/d hzk.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.zookeeper_mt}/include/zookeeper" ];
  }) super.hzk;

  haskakafka = overrideCabal (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d haskakafka.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka" ];
  }) super.haskakafka;

  # library has hard coded directories that need to be removed. Reported upstream here https://github.com/haskell-works/hw-kafka-client/issues/32
  hw-kafka-client = dontCheck (overrideCabal (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d -e /librdkafka/d hw-kafka-client.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka" ];
  }) super.hw-kafka-client);

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

  # Heist's test suite requires system pandoc
  heist = overrideCabal (drv: {
    testToolDepends = [pkgs.pandoc];
  }) super.heist;

  # https://github.com/NixOS/cabal2nix/issues/136 and https://github.com/NixOS/cabal2nix/issues/216
  gio = disableHardening ["fortify"] (addPkgconfigDepend pkgs.glib (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.gio));
  glib = disableHardening ["fortify"] (addPkgconfigDepend pkgs.glib (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.glib));
  gtk3 = disableHardening ["fortify"] (super.gtk3.override { inherit (pkgs) gtk3; });
  gtk = let gtk1 = addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.gtk;
            gtk2 = addPkgconfigDepend pkgs.gtk2 gtk1;
            gtk3 = disableHardening ["fortify"] gtk1;
            gtk4 = if pkgs.stdenv.isDarwin then appendConfigureFlag "-fhave-quartz-gtk" gtk3 else gtk4;
        in gtk3;
  gtksourceview2 = addPkgconfigDepend pkgs.gtk2 super.gtksourceview2;
  gtk-traymanager = addPkgconfigDepend pkgs.gtk3 super.gtk-traymanager;

  # Add necessary reference to gtk3 package
  gi-dbusmenugtk3 = addPkgconfigDepend pkgs.gtk3 super.gi-dbusmenugtk3;

  hs-mesos = overrideCabal (drv: {
    # Pass _only_ mesos; the correct protobuf is propagated.
    extraLibraries = [ pkgs.mesos ];
    preConfigure = "sed -i -e /extra-lib-dirs/d -e 's|, /usr/include, /usr/local/include/mesos||' hs-mesos.cabal";
  }) super.hs-mesos;

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
  hasql-interpolate = dontCheck super.hasql-interpolate; # wants to connect to postgresql
  hasql-transaction = dontCheck super.hasql-transaction; # wants to connect to postgresql
  hjsonschema = overrideCabal (drv: { testTarget = "local"; }) super.hjsonschema;
  marmalade-upload = dontCheck super.marmalade-upload;  # http://hydra.cryp.to/build/501904/nixlog/1/raw
  mongoDB = dontCheck super.mongoDB;
  network-transport-tcp = dontCheck super.network-transport-tcp;
  network-transport-zeromq = dontCheck super.network-transport-zeromq; # https://github.com/tweag/network-transport-zeromq/issues/30
  oidc-client = dontCheck super.oidc-client;            # the spec runs openid against google.com
  pipes-mongodb = dontCheck super.pipes-mongodb;        # http://hydra.cryp.to/build/926195/log/raw
  pixiv = dontCheck super.pixiv;
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
  download = dontCheck super.download;
  http-client = dontCheck super.http-client;
  http-client-openssl = dontCheck super.http-client-openssl;
  http-client-tls = dontCheck super.http-client-tls;
  http-conduit = dontCheck super.http-conduit;
  transient-universe = dontCheck super.transient-universe;
  telegraph = dontCheck super.telegraph;
  typed-process = dontCheck super.typed-process;
  js-jquery = dontCheck super.js-jquery;
  hPDB-examples = dontCheck super.hPDB-examples;
  configuration-tools = dontCheck super.configuration-tools; # https://github.com/alephcloud/hs-configuration-tools/issues/40
  tcp-streams = dontCheck super.tcp-streams;
  holy-project = dontCheck super.holy-project;
  mustache = dontCheck super.mustache;
  arch-web = dontCheck super.arch-web;

  # Tries to mess with extended POSIX attributes, but can't in our chroot environment.
  xattr = dontCheck super.xattr;

  # Needs access to locale data, but looks for it in the wrong place.
  scholdoc-citeproc = dontCheck super.scholdoc-citeproc;

  # Disable tests because they require a mattermost server
  mattermost-api = dontCheck super.mattermost-api;

  # Expect to find sendmail(1) in $PATH.
  mime-mail = appendConfigureFlag "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"" super.mime-mail;

  # Help the test suite find system timezone data.
  tz = overrideCabal (drv: {
    preConfigure = "export TZDIR=${pkgs.tzdata}/share/zoneinfo";
  }) super.tz;

  # Nix-specific workaround
  xmonad = appendPatch ./patches/xmonad-nix.patch (dontCheck super.xmonad);
  xmonad_0_17_0 = doDistribute (appendPatch ./patches/xmonad_0_17_0-nix.patch (super.xmonad_0_17_0));

  # Need matching xmonad version
  xmonad-contrib_0_17_0 = doDistribute (super.xmonad-contrib_0_17_0.override {
    xmonad = self.xmonad_0_17_0;
  });

  xmonad-extras_0_17_0 = doDistribute (super.xmonad-extras_0_17_0.override {
    xmonad = self.xmonad_0_17_0;
    xmonad-contrib = self.xmonad-contrib_0_17_0;
  });

  # wxc supports wxGTX >= 3.0, but our current default version points to 2.8.
  # http://hydra.cryp.to/build/1331287/log/raw
  wxc = (addBuildDepend self.split super.wxc).override { wxGTK = pkgs.wxGTK30; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK30; };

  # Test suite wants to connect to $DISPLAY.
  bindings-GLFW = dontCheck super.bindings-GLFW;
  gi-gtk-declarative = dontCheck super.gi-gtk-declarative;
  gi-gtk-declarative-app-simple = dontCheck super.gi-gtk-declarative-app-simple;
  hsqml = dontCheck (addExtraLibraries [pkgs.libGLU pkgs.libGL] (super.hsqml.override { qt5 = pkgs.qt5Full; }));
  monomer = dontCheck super.monomer;

  # Wants to check against a real DB, Needs freetds
  odbc = dontCheck (addExtraLibraries [ pkgs.freetds ] super.odbc);

  # Tests attempt to use NPM to install from the network into
  # /homeless-shelter. Disabled.
  purescript = dontCheck super.purescript;

  # Hardcoded include path
  poppler = overrideCabal (drv: {
    postPatch = ''
      sed -i -e 's,glib/poppler.h,poppler.h,' poppler.cabal
      sed -i -e 's,glib/poppler.h,poppler.h,' Graphics/UI/Gtk/Poppler/Structs.hsc
    '';
  }) super.poppler;

  # Uses OpenGL in testing
  caramia = dontCheck super.caramia;

  # requires llvm 9 specifically https://github.com/llvm-hs/llvm-hs/#building-from-source
  llvm-hs = super.llvm-hs.override { llvm-config = pkgs.llvm_9; };

  # Needs help finding LLVM.
  spaceprobe = addBuildTool self.buildHaskellPackages.llvmPackages.llvm super.spaceprobe;

  # Tries to run GUI in tests
  leksah = dontCheck (overrideCabal (drv: {
    executableSystemDepends = (drv.executableSystemDepends or []) ++ (with pkgs; [
      gnome.adwaita-icon-theme # Fix error: Icon 'window-close' not present in theme ...
      wrapGAppsHook           # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
      gtk3                    # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ]);
    postPatch = (drv.postPatch or "") + ''
      for f in src/IDE/Leksah.hs src/IDE/Utils/ServerConnection.hs
      do
        substituteInPlace "$f" --replace "\"leksah-server\"" "\"${self.leksah-server}/bin/leksah-server\""
      done
    '';
  }) super.leksah);

  dyre =
    appendPatch
      # Dyre needs special support for reading the NIX_GHC env var.  This is
      # available upstream in https://github.com/willdonnelly/dyre/pull/43, but
      # hasn't been released to Hackage as of dyre-0.9.1.  Likely included in
      # next version.
      (pkgs.fetchpatch {
        url = "https://github.com/willdonnelly/dyre/commit/c7f29d321aae343d6b314f058812dffcba9d7133.patch";
        sha256 = "10m22k35bi6cci798vjpy4c2l08lq5nmmj24iwp0aflvmjdgscdb";
      })
      # dyre's tests appear to be trying to directly call GHC.
      (dontCheck super.dyre);

  # https://github.com/edwinb/EpiVM/issues/13
  # https://github.com/edwinb/EpiVM/issues/14
  epic = addExtraLibraries [pkgs.boehmgc pkgs.gmp] (addBuildTool self.buildHaskellPackages.happy super.epic);

  # https://github.com/ekmett/wl-pprint-terminfo/issues/7
  wl-pprint-terminfo = addExtraLibrary pkgs.ncurses super.wl-pprint-terminfo;

  # https://github.com/bos/pcap/issues/5
  pcap = addExtraLibrary pkgs.libpcap super.pcap;

  # https://github.com/NixOS/nixpkgs/issues/53336
  greenclip = addExtraLibrary pkgs.xorg.libXdmcp super.greenclip;

  # The cabal files for these libraries do not list the required system dependencies.
  miniball = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.miniball ];
  }) super.miniball;
  SDL-image = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_image ] ++ drv.librarySystemDepends or [];
  }) super.SDL-image;
  SDL-ttf = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_ttf ];
  }) super.SDL-ttf;
  SDL-mixer = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_mixer ];
  }) super.SDL-mixer;
  SDL-gfx = overrideCabal (drv: {
    librarySystemDepends = [ pkgs.SDL pkgs.SDL_gfx ];
  }) super.SDL-gfx;
  SDL-mpeg = overrideCabal (drv: {
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.smpeg}/lib"
      "--extra-include-dirs=${pkgs.smpeg}/include/smpeg"
    ];
  }) super.SDL-mpeg;

  # https://github.com/ivanperez-keera/hcwiid/pull/4
  hcwiid = overrideCabal (drv: {
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.bluez.out}/lib"
      "--extra-lib-dirs=${pkgs.cwiid}/lib"
      "--extra-include-dirs=${pkgs.cwiid}/include"
      "--extra-include-dirs=${pkgs.bluez.dev}/include"
    ];
    prePatch = '' sed -i -e "/Extra-Lib-Dirs/d" -e "/Include-Dirs/d" "hcwiid.cabal" '';
  }) super.hcwiid;

  # cabal2nix doesn't pick up some of the dependencies.
  ginsu = let
    g = addBuildDepend pkgs.perl super.ginsu;
    g' = overrideCabal (drv: {
      executableSystemDepends = (drv.executableSystemDepends or []) ++ [
        pkgs.ncurses
      ];
    }) g;
  in g';

  # Tests require `docker` command in PATH
  # Tests require running docker service :on localhost
  docker = dontCheck super.docker;

  # https://github.com/deech/fltkhs/issues/16
  fltkhs = overrideCabal (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [pkgs.buildPackages.autoconf];
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.fltk13 pkgs.libGL pkgs.libjpeg];
  }) super.fltkhs;

  # https://github.com/skogsbaer/hscurses/pull/26
  hscurses = overrideCabal (drv: {
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [ pkgs.ncurses ];
  }) super.hscurses;

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

  # tests depend on executable
  ghcide = overrideCabal (drv: {
    preCheck = ''export PATH="$PWD/dist/build/ghcide:$PATH"'';
  }) super.ghcide;

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
  ${if pkgs.stdenv.isDarwin then null else "GLUT"} = addPkgconfigDepend pkgs.freeglut (appendPatch ./patches/GLUT.patch super.GLUT);

  libsystemd-journal = overrideCabal (old: {
    librarySystemDepends = old.librarySystemDepends or [] ++ [ pkgs.systemd ];
  }) super.libsystemd-journal;

  # does not specify tests in cabal file, instead has custom runTest cabal hook,
  # so cabal2nix will not detect test dependencies.
  either-unwrap = overrideCabal (drv: {
    testHaskellDepends = (drv.testHaskellDepends or []) ++ [ self.test-framework self.test-framework-hunit ];
  }) super.either-unwrap;

  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = dontCheck super.fsnotify;

  hidapi = addExtraLibrary pkgs.udev super.hidapi;

  hs-GeoIP = super.hs-GeoIP.override { GeoIP = pkgs.geoipWithDatabase; };

  discount = super.discount.override { markdown = pkgs.discount; };

  # tests require working stack installation with all-cabal-hashes cloned in $HOME
  stackage-curator = dontCheck super.stackage-curator;

  # hardcodes /usr/bin/tr: https://github.com/snapframework/io-streams/pull/59
  io-streams = enableCabalFlag "NoInteractiveTests" super.io-streams;

  # requires autotools to build
  secp256k1 = addBuildTools [ pkgs.buildPackages.autoconf pkgs.buildPackages.automake pkgs.buildPackages.libtool ] super.secp256k1;

  # requires libsecp256k1 in pkg-config-depends
  secp256k1-haskell = addPkgconfigDepend pkgs.secp256k1 super.secp256k1-haskell;

  # tests require git and zsh
  hapistrano = addBuildTools [ pkgs.buildPackages.git pkgs.buildPackages.zsh ] super.hapistrano;

  # This propagates this to everything depending on haskell-gi-base
  haskell-gi-base = addBuildDepend pkgs.gobject-introspection super.haskell-gi-base;

  # requires valid, writeable $HOME
  hatex-guide = overrideCabal (drv: {
    preConfigure = ''
      ${drv.preConfigure or ""}
      export HOME=$PWD
    '';
  }) super.hatex-guide;

  # https://github.com/plow-technologies/servant-streaming/issues/12
  servant-streaming-server = dontCheck super.servant-streaming-server;

  # https://github.com/haskell-servant/servant/pull/1238
  servant-client-core = if (pkgs.lib.getVersion super.servant-client-core) == "0.16" then
    appendPatch ./patches/servant-client-core-redact-auth-header.patch super.servant-client-core
  else
    super.servant-client-core;


  # tests run executable, relying on PATH
  # without this, tests fail with "Couldn't launch intero process"
  intero = overrideCabal (drv: {
    preCheck = ''
      export PATH="$PWD/dist/build/intero:$PATH"
    '';
  }) super.intero;

  # Break infinite recursion cycle with criterion and network-uri.
  js-flot = dontCheck super.js-flot;

  # Break infinite recursion cycle between QuickCheck and splitmix.
  splitmix = dontCheck super.splitmix;

  # Break infinite recursion cycle between tasty and clock.
  clock = dontCheck super.clock;

  # Break infinite recursion cycle between devtools and mprelude.
  devtools = super.devtools.override { mprelude = dontCheck super.mprelude; };

  # Break dependency cycle between tasty-hedgehog and tasty-expected-failure
  tasty-hedgehog = dontCheck super.tasty-hedgehog;

  # Break dependency cycle between hedgehog, tasty-hedgehog and lifted-async
  lifted-async = dontCheck super.lifted-async;

  # loc and loc-test depend on each other for testing. Break that infinite cycle:
  loc-test = super.loc-test.override { loc = dontCheck self.loc; };

  # The test suites try to run the "fixpoint" and "liquid" executables built just
  # before and fail because the library search paths aren't configured properly.
  # Also needs https://github.com/ucsd-progsys/liquidhaskell/issues/1038 resolved.
  liquid-fixpoint = disableSharedExecutables super.liquid-fixpoint;
  liquidhaskell = dontCheck (disableSharedExecutables super.liquidhaskell);

  # Without this override, the builds lacks pkg-config.
  opencv-extra = addPkgconfigDepend pkgs.opencv3 super.opencv-extra;

  # Break cyclic reference that results in an infinite recursion.
  partial-semigroup = dontCheck super.partial-semigroup;
  colour = dontCheck super.colour;
  spatial-rotations = dontCheck super.spatial-rotations;

  LDAP = dontCheck (overrideCabal (drv: {
    librarySystemDepends = drv.librarySystemDepends or [] ++ [ pkgs.cyrus_sasl.dev ];
  }) super.LDAP);

  # Expects z3 to be on path so we replace it with a hard
  #
  # The tests expect additional solvers on the path, replace the
  # available ones also with hard coded paths, and remove the missing
  # ones from the test.
  sbv = overrideCabal (drv: {
    postPatch = ''
      sed -i -e 's|"abc"|"${pkgs.abc-verifier}/bin/abc"|' Data/SBV/Provers/ABC.hs
      sed -i -e 's|"boolector"|"${pkgs.boolector}/bin/boolector"|' Data/SBV/Provers/Boolector.hs
      sed -i -e 's|"yices-smt2"|"${pkgs.yices}/bin/yices-smt2"|' Data/SBV/Provers/Yices.hs
      sed -i -e 's|"z3"|"${pkgs.z3}/bin/z3"|' Data/SBV/Provers/Z3.hs
    '' + (if pkgs.stdenv.isAarch64 then ''
      sed -i -e 's|\[abc, boolector, cvc4, mathSAT, yices, z3, dReal\]|[abc, boolector, yices, z3]|' SBVTestSuite/SBVConnectionTest.hs
    ''
    else ''
      sed -i -e 's|"cvc4"|"${pkgs.cvc4}/bin/cvc4"|' Data/SBV/Provers/CVC4.hs
      sed -i -e 's|\[abc, boolector, cvc4, mathSAT, yices, z3, dReal\]|[abc, boolector, cvc4, yices, z3]|' SBVTestSuite/SBVConnectionTest.hs
    '');
  }) super.sbv;

  # The test-suite requires a running PostgreSQL server.
  Frames-beam = dontCheck super.Frames-beam;

  # Compile manpages (which are in RST and are compiled with Sphinx).
  futhark =
    overrideCabal
      (_drv: {
        postBuild = (_drv.postBuild or "") + ''
        make -C docs man
        '';

        postInstall = (_drv.postInstall or "") + ''
        mkdir -p $out/share/man/man1
        mv docs/_build/man/*.1 $out/share/man/man1/
        '';
      })
      (addBuildTools (with pkgs.buildPackages; [makeWrapper python3Packages.sphinx]) super.futhark);

  git-annex = let
    pathForDarwin = pkgs.lib.makeBinPath [ pkgs.coreutils ];
  in overrideCabal (drv: pkgs.lib.optionalAttrs (!pkgs.stdenv.isLinux) {
    # This is an instance of https://github.com/NixOS/nix/pull/1085
    # Fails with:
    #   gpg: can't connect to the agent: File name too long
    postPatch = pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      substituteInPlace Test.hs \
        --replace ', testCase "crypto" test_crypto' ""
    '' + (drv.postPatch or "");
    # On Darwin, git-annex mis-detects options to `cp`, so we wrap the
    # binary to ensure it uses Nixpkgs' coreutils.
    postFixup = ''
      wrapProgram $out/bin/git-annex \
        --prefix PATH : "${pathForDarwin}"
    '' + (drv.postFixup or "");
    buildTools = [
      pkgs.buildPackages.makeWrapper
    ] ++ (drv.buildTools or []);
  }) (super.git-annex.override {
    dbus = if pkgs.stdenv.isLinux then self.dbus else null;
    fdo-notify = if pkgs.stdenv.isLinux then self.fdo-notify else null;
    hinotify = if pkgs.stdenv.isLinux then self.hinotify else self.fsnotify;
  });

  # The test suite has undeclared dependencies on git.
  githash = dontCheck super.githash;

  # Avoid infitite recursion with yaya.
  yaya-hedgehog = super.yaya-hedgehog.override { yaya = dontCheck self.yaya; };

  # Avoid infitite recursion with tonatona.
  tonaparser = dontCheck super.tonaparser;

  # Needs internet to run tests
  HTTP = dontCheck super.HTTP;

  # Break infinite recursions.
  Dust-crypto = dontCheck super.Dust-crypto;
  nanospec = dontCheck super.nanospec;
  options = dontCheck super.options;
  snap-server = dontCheck super.snap-server;

  # Tests require internet
  http-download = dontCheck super.http-download;
  pantry = dontCheck super.pantry;

  # gtk2hs-buildtools is listed in setupHaskellDepends, but we
  # need it during the build itself, too.
  cairo = addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.cairo;
  pango = disableHardening ["fortify"] (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.pango);

  spago =
    let
      docsSearchApp_0_0_10 = pkgs.fetchurl {
        url = "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/docs-search-app.js";
        sha256 = "0m5ah29x290r0zk19hx2wix2djy7bs4plh9kvjz6bs9r45x25pa5";
      };

      docsSearchApp_0_0_11 = pkgs.fetchurl {
        url = "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/docs-search-app.js";
        sha256 = "17qngsdxfg96cka1cgrl3zdrpal8ll6vyhhnazqm4hwj16ywjm02";
      };

      purescriptDocsSearch_0_0_10 = pkgs.fetchurl {
        url = "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.10/purescript-docs-search";
        sha256 = "0wc1zyhli4m2yykc6i0crm048gyizxh7b81n8xc4yb7ibjqwhyj3";
      };

      purescriptDocsSearch_0_0_11 = pkgs.fetchurl {
        url = "https://github.com/purescript/purescript-docs-search/releases/download/v0.0.11/purescript-docs-search";
        sha256 = "1hjdprm990vyxz86fgq14ajn0lkams7i00h8k2i2g1a0hjdwppq6";
      };

      spagoDocs = overrideCabal (drv: {
        postUnpack = (drv.postUnpack or "") + ''
          # Spago includes the following two files directly into the binary
          # with Template Haskell.  They are fetched at build-time from the
          # `purescript-docs-search` repo above.  If they cannot be fetched at
          # build-time, they are pulled in from the `templates/` directory in
          # the spago source.
          #
          # However, they are not actually available in the spago source, so they
          # need to fetched with nix and put in the correct place.
          # https://github.com/spacchetti/spago/issues/510
          cp ${docsSearchApp_0_0_10} "$sourceRoot/templates/docs-search-app-0.0.10.js"
          cp ${docsSearchApp_0_0_11} "$sourceRoot/templates/docs-search-app-0.0.11.js"
          cp ${purescriptDocsSearch_0_0_10} "$sourceRoot/templates/purescript-docs-search-0.0.10"
          cp ${purescriptDocsSearch_0_0_11} "$sourceRoot/templates/purescript-docs-search-0.0.11"

          # For some weird reason, on Darwin, the open(2) call to embed these files
          # requires write permissions. The easiest resolution is just to permit that
          # (doesn't cause any harm on other systems).
          chmod u+w \
            "$sourceRoot/templates/docs-search-app-0.0.10.js" \
            "$sourceRoot/templates/purescript-docs-search-0.0.10" \
            "$sourceRoot/templates/docs-search-app-0.0.11.js" \
            "$sourceRoot/templates/purescript-docs-search-0.0.11"
        '';
      }) super.spago;

      # Tests require network access.
      spagoWithoutChecks = dontCheck spagoDocs;
    in
    spagoWithoutChecks;

  # checks SQL statements at compile time, and so requires a running PostgreSQL
  # database to run it's test suite
  postgresql-typed = dontCheck super.postgresql-typed;

  # mplayer-spot uses mplayer at runtime.
  mplayer-spot =
    let path = pkgs.lib.makeBinPath [ pkgs.mplayer ];
    in overrideCabal (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/mplayer-spot --prefix PATH : "${path}"
      '';
    }) (addBuildTool pkgs.buildPackages.makeWrapper super.mplayer-spot);

  # break infinite recursion with base-orphans
  primitive = dontCheck super.primitive;
  primitive_0_7_1_0 = dontCheck super.primitive_0_7_1_0;

  cut-the-crap =
    let path = pkgs.lib.makeBinPath [ pkgs.ffmpeg pkgs.youtube-dl ];
    in overrideCabal (_drv: {
      postInstall = ''
        wrapProgram $out/bin/cut-the-crap \
          --prefix PATH : "${path}"
      '';
    }) (addBuildTool pkgs.buildPackages.makeWrapper super.cut-the-crap);

  # Tests access homeless-shelter.
  hie-bios = dontCheck super.hie-bios;
  hie-bios_0_5_0 = dontCheck super.hie-bios_0_5_0;

  # Compiling the readme throws errors and has no purpose in nixpkgs
  aeson-gadt-th =
    disableCabalFlag "build-readme" (doJailbreak super.aeson-gadt-th);

  neuron = overrideCabal (drv: {
    # neuron expects the neuron-search script to be in PATH at built-time.
    buildTools = [ pkgs.buildPackages.makeWrapper ];
    preConfigure = ''
      mkdir -p $out/bin
      cp src-bash/neuron-search $out/bin/neuron-search
      chmod +x $out/bin/neuron-search
      wrapProgram $out/bin/neuron-search --prefix 'PATH' ':' ${
        with pkgs;
        lib.makeBinPath [ fzf ripgrep gawk bat findutils envsubst ]
      }
      PATH=$PATH:$out/bin
    '';
  }) super.neuron;

  # Fix compilation of Setup.hs by removing the module declaration.
  # See: https://github.com/tippenein/guid/issues/1
  guid = overrideCabal (drv: {
    prePatch = "sed -i '1d' Setup.hs"; # 1st line is module declaration, remove it
    doCheck = false;
  }) super.guid;

  # Tests disabled as recommended at https://github.com/luke-clifton/shh/issues/39
  shh = dontCheck super.shh;

  # The test suites fail because there's no PostgreSQL database running in our
  # build sandbox.
  hasql-queue = dontCheck super.hasql-queue;
  postgresql-libpq-notify = dontCheck super.postgresql-libpq-notify;
  postgresql-pure = dontCheck super.postgresql-pure;

  retrie = overrideCabal (drv: {
    testToolDepends = [ pkgs.git pkgs.mercurial ] ++ drv.testToolDepends or [];
  }) super.retrie;

  retrie_1_2_0_0 = overrideCabal (drv: {
    testToolDepends = [ pkgs.git pkgs.mercurial ] ++ drv.testToolDepends or [];
  }) super.retrie_1_2_0_0;

  haskell-language-server = overrideCabal (drv: {
    # starting with 1.6.1.1 haskell-language-server wants to be linked dynamically
    # by default. Unless we reflect this in the generic builder, GHC is going to
    # produce some illegal references to /build/.
    enableSharedExecutables = true;
    postInstall = "ln -s $out/bin/haskell-language-server $out/bin/haskell-language-server-${self.ghc.version}";
    testToolDepends = [ self.cabal-install pkgs.git ];
    testTarget = "func-test"; # wrapper test accesses internet
    preCheck = ''
      export PATH=$PATH:$PWD/dist/build/haskell-language-server:$PWD/dist/build/haskell-language-server-wrapper
      export HOME=$TMPDIR
    '';
  }) super.haskell-language-server;

  # tests depend on a specific version of solc
  hevm = dontCheck (doJailbreak super.hevm);

  # hadolint enables static linking by default in the cabal file, so we have to explicitly disable it.
  # https://github.com/hadolint/hadolint/commit/e1305042c62d52c2af4d77cdce5d62f6a0a3ce7b
  hadolint = disableCabalFlag "static" super.hadolint;

  # Test suite tries to execute the build product "doctest-driver-gen", but it's not in $PATH.
  doctest-driver-gen = dontCheck super.doctest-driver-gen;

  # Tests access internet
  prune-juice = dontCheck super.prune-juice;

  # based on https://github.com/gibiansky/IHaskell/blob/aafeabef786154d81ab7d9d1882bbcd06fc8c6c4/release.nix
  ihaskell = overrideCabal (drv: {
    # ihaskell's cabal file forces building a shared executable, which we need
    # to reflect here or RPATH will contain a reference to /build/.
    enableSharedExecutables = true;
    preCheck = ''
      export HOME=$TMPDIR/home
      export PATH=$PWD/dist/build/ihaskell:$PATH
      export GHC_PACKAGE_PATH=$PWD/dist/package.conf.inplace/:$GHC_PACKAGE_PATH
    '';
  }) super.ihaskell;

  # tests need to execute the built executable
  stutter = overrideCabal (drv: {
    preCheck = ''
      export PATH=dist/build/stutter:$PATH
    '' + (drv.preCheck or "");
  }) super.stutter;

  # Install man page and generate shell completions
  pinboard-notes-backup = overrideCabal
    (drv: {
      postInstall = ''
        install -D man/pnbackup.1 $out/share/man/man1/pnbackup.1
      '' + (drv.postInstall or "");
    })
    (generateOptparseApplicativeCompletion "pnbackup" super.pinboard-notes-backup);

  # set more accurate set of platforms instead of maintaining
  # an ever growing list of platforms to exclude via unsupported-platforms
  cpuid = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.cpuid;

  # Pass the correct libarchive into the package.
  streamly-archive = super.streamly-archive.override { archive = pkgs.libarchive; };

  # passes the -msse2 flag which only works on x86 platforms
  hsignal = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.hsignal;

  # uses x86 intrinsics
  blake3 = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.blake3;

  # uses x86 intrinsics, see also https://github.com/NixOS/nixpkgs/issues/122014
  crc32c = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.crc32c;

  # uses x86 intrinsics
  seqalign = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.seqalign;

  # uses x86 intrinsics
  geomancy = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.geomancy;

  hlint = overrideCabal (drv: {
    postInstall = ''
      install -Dm644 data/hlint.1 -t "$out/share/man/man1"
    '' + drv.postInstall or "";
  }) super.hlint;

  hiedb = overrideCabal (drv: {
    preCheck = ''
      export PATH=$PWD/dist/build/hiedb:$PATH
    '';
  }) super.hiedb;

  taglib = overrideCabal (drv: {
    librarySystemDepends = [
      pkgs.zlib
    ] ++ (drv.librarySystemDepends or []);
  }) super.taglib;

  # uses x86 assembler
  inline-asm = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.inline-asm;

  # uses x86 assembler in C bits
  hw-prim-bits = overrideCabal {
    platforms = pkgs.lib.platforms.x86;
  } super.hw-prim-bits;

  # random 1.2.0 has tests that indirectly depend on
  # itself causing an infinite recursion at evaluation
  # time
  random = dontCheck super.random;

  # Since this package is primarily used by nixpkgs maintainers and is probably
  # not used to link against by anyone, we can make it’s closure smaller and
  # add its runtime dependencies in `haskellPackages` (as opposed to cabal2nix).
  cabal2nix-unstable = overrideCabal
    (drv: {
      buildTools = (drv.buildTools or []) ++ [
        pkgs.buildPackages.makeWrapper
      ];
      postInstall = ''
        wrapProgram $out/bin/cabal2nix \
          --prefix PATH ":" "${
            pkgs.lib.makeBinPath [ pkgs.nix pkgs.nix-prefetch-scripts ]
          }"
      '';
    })
    (justStaticExecutables super.cabal2nix-unstable);

  # test suite needs local redis daemon
  nri-redis = dontCheck super.nri-redis;

  # Make tophat find itself for _compiling_ its test suite
  tophat = overrideCabal (drv: {
    postPatch = ''
      sed -i 's|"tophat"|"./dist/build/tophat/tophat"|' app-test-bin/*.hs
    '' + (drv.postPatch or "");
  }) super.tophat;

  # Runtime dependencies and CLI completion
  nvfetcher = generateOptparseApplicativeCompletion "nvfetcher" (overrideCabal
    (drv: {
      # test needs network
      doCheck = false;
      buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/nvfetcher" --prefix 'PATH' ':' "${
          pkgs.lib.makeBinPath [ pkgs.nvchecker pkgs.nix-prefetch-git ]
        }"
      '';
    }) super.nvfetcher);

  rel8 = addTestToolDepend pkgs.postgresql super.rel8;

  cachix = generateOptparseApplicativeCompletion "cachix" (super.cachix.override { nix = pkgs.nixVersions.nix_2_4; });

  hercules-ci-agent = appendConfigureFlag "-fnix-2_4" (super.hercules-ci-agent.override { nix = pkgs.nixVersions.nix_2_4; });
  hercules-ci-cnix-expr = appendConfigureFlag "-fnix-2_4" (super.hercules-ci-cnix-expr.override { nix = pkgs.nixVersions.nix_2_4; });
  hercules-ci-cnix-store = appendConfigureFlag "-fnix-2_4" (super.hercules-ci-cnix-store.override { nix = pkgs.nixVersions.nix_2_4; });

  # Enable extra optimisations which increase build time, but also
  # later compiler performance, so we should do this for user's benefit.
  # Flag added in Agda 2.6.2
  Agda = appendConfigureFlag "-foptimise-heavily" super.Agda;

  # ats-format uses cli-setup in Setup.hs which is quite happy to write
  # to arbitrary files in $HOME. This doesn't either not achieve anything
  # or even fail, so we prevent it and install everything necessary ourselves.
  # See also: https://hackage.haskell.org/package/cli-setup-0.2.1.4/docs/src/Distribution.CommandLine.html#setManpathGeneric
  ats-format = generateOptparseApplicativeCompletion "atsfmt" (
    justStaticExecutables (
      overrideCabal (drv: {
        # use vanilla Setup.hs
        preCompileBuildDriver = ''
          cat > Setup.hs << EOF
          module Main where
          import Distribution.Simple
          main = defaultMain
          EOF
        '' + (drv.preCompileBuildDriver or "");
        # install man page
        buildTools = [
          pkgs.buildPackages.installShellFiles
        ] ++ (drv.buildTools or []);
        postInstall = ''
          installManPage man/atsfmt.1
        '' + (drv.postInstall or "");
      }) super.ats-format
    )
  );

  # Test suite is just the default example executable which doesn't work if not
  # executed by Setup.hs, but works if started on a proper TTY
  isocline = dontCheck super.isocline;

  # Some hash implementations are x86 only, but part of the test suite.
  # So executing and building it on non-x86 platforms will always fail.
  hashes = overrideCabal {
    doCheck = with pkgs.stdenv; hostPlatform == buildPlatform
      && buildPlatform.isx86;
  } super.hashes;

  # procex relies on close_range which has been introduced in Linux 5.9,
  # the test suite seems to force the use of this feature (or the fallback
  # mechanism is broken), so we can't run the test suite on machines with a
  # Kernel < 5.9. To check for this, we use uname -r to obtain the Kernel
  # version and sort -V to compare against our minimum version. If the
  # Kernel turns out to be older, we disable the test suite.
  procex = overrideCabal (drv: {
    postConfigure = ''
      minimumKernel=5.9
      higherVersion=`printf "%s\n%s\n" "$minimumKernel" "$(uname -r)" | sort -rV | head -n1`
      if [[ "$higherVersion" = "$minimumKernel" ]]; then
        echo "Used Kernel doesn't support close_range, disabling tests"
        unset doCheck
      fi
    '' + (drv.postConfigure or "");
  }) super.procex;

  # Apply a patch which hardcodes the store path of graphviz instead of using
  # whatever graphviz is in PATH.
  graphviz = overrideCabal (drv: {
    patches = [
      (pkgs.substituteAll {
        src = ./patches/graphviz-hardcode-graphviz-store-path.patch;
        inherit (pkgs) graphviz;
      })
    ] ++ (drv.patches or []);
  }) super.graphviz;

  # Test case tries to contact the network
  http-api-data-qq = overrideCabal (drv: {
    testFlags = [
      "-p" "!/Can be used with http-client/"
    ] ++ drv.testFlags or [];
  }) super.http-api-data-qq;

  # Additionally install documentation
  jacinda = overrideCabal (drv: {
    enableSeparateDocOutput = true;
    postInstall = ''
      ${drv.postInstall or ""}

      docDir="$doc/share/doc/${drv.pname}-${drv.version}"

      # man page goes to $out, it's small enough and haskellPackages has no
      # support for a man output at the moment and $doc requires downloading
      # a full PDF
      install -Dm644 man/ja.1 -t "$out/share/man/man1"
      # language guide and examples
      install -Dm644 doc/guide.pdf -t "$docDir"
      install -Dm644 test/examples/*.jac -t "$docDir/examples"
    '';
  }) super.jacinda;

# haskell-language-server plugins all use the same test harness so we give them what we want in this loop.
} // pkgs.lib.mapAttrs
  (_: overrideCabal (drv: {
    testToolDepends = (drv.testToolDepends or [ ]) ++ [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '' + (drv.preCheck or "");
  }))
{
  inherit (super)
    hls-brittany-plugin
    hls-call-hierarchy-plugin
    hls-class-plugin
    hls-eval-plugin
    hls-floskell-plugin
    hls-fourmolu-plugin
    hls-module-name-plugin
    hls-ormolu-plugin
    hls-pragmas-plugin
    hls-rename-plugin
    hls-selection-range-plugin
    hls-splice-plugin;
  # Tests have file permissions expections that don‘t work with the nix store.
  hls-stylish-haskell-plugin = dontCheck super.hls-stylish-haskell-plugin;

  # Flaky tests
  hls-hlint-plugin = dontCheck super.hls-hlint-plugin;
  hls-alternate-number-format-plugin = dontCheck super.hls-alternate-number-format-plugin;
  hls-qualify-imported-names-plugin = dontCheck super.hls-qualify-imported-names-plugin;
  hls-haddock-comments-plugin = dontCheck super.hls-haddock-comments-plugin;
}
