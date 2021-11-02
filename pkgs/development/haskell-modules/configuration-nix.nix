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
  ghc-paths = appendPatch super.ghc-paths ./patches/ghc-paths-nix.patch;

  # fix errors caused by hardening flags
  epanet-haskell = disableHardening super.epanet-haskell ["format"];

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  # Use the default version of mysql to build this package (which is actually mariadb).
  # test phase requires networking
  mysql = dontCheck super.mysql;

  # CUDA needs help finding the SDK headers and libraries.
  cuda = overrideCabal super.cuda (drv: {
    extraLibraries = (drv.extraLibraries or []) ++ [pkgs.linuxPackages.nvidia_x11];
    configureFlags = (drv.configureFlags or []) ++ [
      "--extra-lib-dirs=${pkgs.cudatoolkit.lib}/lib"
      "--extra-include-dirs=${pkgs.cudatoolkit}/include"
    ];
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
    '';
  });

  nvvm = overrideCabal super.nvvm (drv: {
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
    '';
  });

  cufft = overrideCabal super.cufft (drv: {
    preConfigure = ''
      export CUDA_PATH=${pkgs.cudatoolkit}
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

  # Won't find it's header files without help.
  sfml-audio = appendConfigureFlag super.sfml-audio "--extra-include-dirs=${pkgs.openal}/include/AL";

  # avoid compiling twice by providing executable as a separate output (with small closure size)
  niv = enableSeparateBinOutput super.niv;
  ormolu = enableSeparateBinOutput super.ormolu;
  ghcid = enableSeparateBinOutput super.ghcid;

  hzk = overrideCabal super.hzk (drv: {
    preConfigure = "sed -i -e /include-dirs/d hzk.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.zookeeper_mt}/include/zookeeper" ];
  });

  haskakafka = overrideCabal super.haskakafka (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d haskakafka.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka" ];
  });

  # library has hard coded directories that need to be removed. Reported upstream here https://github.com/haskell-works/hw-kafka-client/issues/32
  hw-kafka-client = dontCheck (overrideCabal super.hw-kafka-client (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d -e /librdkafka/d hw-kafka-client.cabal";
    configureFlags = [ "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka" ];
  }));

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

  # Heist's test suite requires system pandoc
  heist = overrideCabal super.heist (drv: {
    testToolDepends = [pkgs.pandoc];
  });

  # https://github.com/NixOS/cabal2nix/issues/136 and https://github.com/NixOS/cabal2nix/issues/216
  gio = disableHardening (addPkgconfigDepend (addBuildTool super.gio self.buildHaskellPackages.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  glib = disableHardening (addPkgconfigDepend (addBuildTool super.glib self.buildHaskellPackages.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  gtk3 = disableHardening (super.gtk3.override { inherit (pkgs) gtk3; }) ["fortify"];
  gtk = let gtk1 = addBuildTool super.gtk self.buildHaskellPackages.gtk2hs-buildtools;
            gtk2 = addPkgconfigDepend gtk1 pkgs.gtk2;
            gtk3 = disableHardening gtk1 ["fortify"];
            gtk4 = if pkgs.stdenv.isDarwin then appendConfigureFlag gtk3 "-fhave-quartz-gtk" else gtk4;
        in gtk3;
  gtksourceview2 = addPkgconfigDepend super.gtksourceview2 pkgs.gtk2;
  gtk-traymanager = addPkgconfigDepend super.gtk-traymanager pkgs.gtk3;

  # Add necessary reference to gtk3 package
  gi-dbusmenugtk3 = addPkgconfigDepend super.gi-dbusmenugtk3 pkgs.gtk3;

  hs-mesos = overrideCabal super.hs-mesos (drv: {
    # Pass _only_ mesos; the correct protobuf is propagated.
    extraLibraries = [ pkgs.mesos ];
    preConfigure = "sed -i -e /extra-lib-dirs/d -e 's|, /usr/include, /usr/local/include/mesos||' hs-mesos.cabal";
  });

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
  mime-mail = appendConfigureFlag super.mime-mail "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"";

  # Help the test suite find system timezone data.
  tz = overrideCabal super.tz (drv: {
    preConfigure = "export TZDIR=${pkgs.tzdata}/share/zoneinfo";
    patches = [
      # Fix tests failing with libSystem, musl etc. due to a lack of
      # support for glibc's non-POSIX TZDIR environment variable.
      # https://github.com/nilcons/haskell-tz/pull/29
      (pkgs.fetchpatch {
        name = "support-non-glibc-tzset.patch";
        url = "https://github.com/sternenseemann/haskell-tz/commit/64928f1a50a1a276a718491ae3eeef63abcdb393.patch";
        sha256 = "1f53w8k1vpy39hzalyykpvm946ykkarj2714w988jdp4c2c4l4cf";
      })
    ] ++ (drv.patches or []);
  });

  # Nix-specific workaround
  xmonad = appendPatch (dontCheck super.xmonad) ./patches/xmonad-nix.patch;

  # wxc supports wxGTX >= 3.0, but our current default version points to 2.8.
  # http://hydra.cryp.to/build/1331287/log/raw
  wxc = (addBuildDepend super.wxc self.split).override { wxGTK = pkgs.wxGTK30; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK30; };

  # Test suite wants to connect to $DISPLAY.
  bindings-GLFW = dontCheck super.bindings-GLFW;
  gi-gtk-declarative = dontCheck super.gi-gtk-declarative;
  gi-gtk-declarative-app-simple = dontCheck super.gi-gtk-declarative-app-simple;
  hsqml = dontCheck (addExtraLibraries (super.hsqml.override { qt5 = pkgs.qt5Full; }) [pkgs.libGLU pkgs.libGL]);
  monomer = dontCheck super.monomer;

  # Wants to check against a real DB, Needs freetds
  odbc = dontCheck (addExtraLibraries super.odbc [ pkgs.freetds ]);

  # Tests attempt to use NPM to install from the network into
  # /homeless-shelter. Disabled.
  purescript = dontCheck super.purescript;

  # Hardcoded include path
  poppler = overrideCabal super.poppler (drv: {
    postPatch = ''
      sed -i -e 's,glib/poppler.h,poppler.h,' poppler.cabal
      sed -i -e 's,glib/poppler.h,poppler.h,' Graphics/UI/Gtk/Poppler/Structs.hsc
    '';
  });

  # Uses OpenGL in testing
  caramia = dontCheck super.caramia;

  # requires llvm 9 specifically https://github.com/llvm-hs/llvm-hs/#building-from-source
  llvm-hs = super.llvm-hs.override { llvm-config = pkgs.llvm_9; };

  # Needs help finding LLVM.
  spaceprobe = addBuildTool super.spaceprobe self.buildHaskellPackages.llvmPackages.llvm;

  # Tries to run GUI in tests
  leksah = dontCheck (overrideCabal super.leksah (drv: {
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
  }));

  dyre =
    appendPatch
      # dyre's tests appear to be trying to directly call GHC.
      (dontCheck super.dyre)
      # Dyre needs special support for reading the NIX_GHC env var.  This is
      # available upstream in https://github.com/willdonnelly/dyre/pull/43, but
      # hasn't been released to Hackage as of dyre-0.9.1.  Likely included in
      # next version.
      (pkgs.fetchpatch {
        url = "https://github.com/willdonnelly/dyre/commit/c7f29d321aae343d6b314f058812dffcba9d7133.patch";
        sha256 = "10m22k35bi6cci798vjpy4c2l08lq5nmmj24iwp0aflvmjdgscdb";
      });

  # https://github.com/edwinb/EpiVM/issues/13
  # https://github.com/edwinb/EpiVM/issues/14
  epic = addExtraLibraries (addBuildTool super.epic self.buildHaskellPackages.happy) [pkgs.boehmgc pkgs.gmp];

  # https://github.com/ekmett/wl-pprint-terminfo/issues/7
  wl-pprint-terminfo = addExtraLibrary super.wl-pprint-terminfo pkgs.ncurses;

  # https://github.com/bos/pcap/issues/5
  pcap = addExtraLibrary super.pcap pkgs.libpcap;

  # https://github.com/NixOS/nixpkgs/issues/53336
  greenclip = addExtraLibrary super.greenclip pkgs.xorg.libXdmcp;

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

  # cabal2nix doesn't pick up some of the dependencies.
  ginsu = let
    g = addBuildDepend super.ginsu pkgs.perl;
    g' = overrideCabal g (drv: {
      executableSystemDepends = (drv.executableSystemDepends or []) ++ [
        pkgs.ncurses
      ];
    });
  in g';

  # Tests require `docker` command in PATH
  # Tests require running docker service :on localhost
  docker = dontCheck super.docker;

  # https://github.com/deech/fltkhs/issues/16
  fltkhs = overrideCabal super.fltkhs (drv: {
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [pkgs.buildPackages.autoconf];
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.fltk13 pkgs.libGL pkgs.libjpeg];
  });

  # https://github.com/skogsbaer/hscurses/pull/26
  hscurses = overrideCabal super.hscurses (drv: {
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [ pkgs.ncurses ];
  });

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

  # tests depend on executable
  ghcide = overrideCabal super.ghcide (drv: {
    preCheck = ''export PATH="$PWD/dist/build/ghcide:$PATH"'';
  });

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

  libsystemd-journal = overrideCabal super.libsystemd-journal (old: {
    librarySystemDepends = old.librarySystemDepends or [] ++ [ pkgs.systemd ];
  });

  # does not specify tests in cabal file, instead has custom runTest cabal hook,
  # so cabal2nix will not detect test dependencies.
  either-unwrap = overrideCabal super.either-unwrap (drv: {
    testHaskellDepends = (drv.testHaskellDepends or []) ++ [ self.test-framework self.test-framework-hunit ];
  });

  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = dontCheck super.fsnotify;

  hidapi = addExtraLibrary super.hidapi pkgs.udev;

  hs-GeoIP = super.hs-GeoIP.override { GeoIP = pkgs.geoipWithDatabase; };

  discount = super.discount.override { markdown = pkgs.discount; };

  # tests require working stack installation with all-cabal-hashes cloned in $HOME
  stackage-curator = dontCheck super.stackage-curator;

  # hardcodes /usr/bin/tr: https://github.com/snapframework/io-streams/pull/59
  io-streams = enableCabalFlag super.io-streams "NoInteractiveTests";

  # requires autotools to build
  secp256k1 = addBuildTools super.secp256k1 [ pkgs.buildPackages.autoconf pkgs.buildPackages.automake pkgs.buildPackages.libtool ];

  # requires libsecp256k1 in pkg-config-depends
  secp256k1-haskell = addPkgconfigDepend super.secp256k1-haskell pkgs.secp256k1;

  # tests require git and zsh
  hapistrano = addBuildTools super.hapistrano [ pkgs.buildPackages.git pkgs.buildPackages.zsh ];

  # This propagates this to everything depending on haskell-gi-base
  haskell-gi-base = addBuildDepend super.haskell-gi-base pkgs.gobject-introspection;

  # requires valid, writeable $HOME
  hatex-guide = overrideCabal super.hatex-guide (drv: {
    preConfigure = ''
      ${drv.preConfigure or ""}
      export HOME=$PWD
    '';
  });

  # https://github.com/plow-technologies/servant-streaming/issues/12
  servant-streaming-server = dontCheck super.servant-streaming-server;

  # https://github.com/haskell-servant/servant/pull/1238
  servant-client-core = if (pkgs.lib.getVersion super.servant-client-core) == "0.16" then
    appendPatch super.servant-client-core ./patches/servant-client-core-redact-auth-header.patch
  else
    super.servant-client-core;


  # tests run executable, relying on PATH
  # without this, tests fail with "Couldn't launch intero process"
  intero = overrideCabal super.intero (drv: {
    preCheck = ''
      export PATH="$PWD/dist/build/intero:$PATH"
    '';
  });

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
  opencv-extra = addPkgconfigDepend super.opencv-extra pkgs.opencv3;

  # Break cyclic reference that results in an infinite recursion.
  partial-semigroup = dontCheck super.partial-semigroup;
  colour = dontCheck super.colour;
  spatial-rotations = dontCheck super.spatial-rotations;

  LDAP = dontCheck (overrideCabal super.LDAP (drv: {
    librarySystemDepends = drv.librarySystemDepends or [] ++ [ pkgs.cyrus_sasl.dev ];
  }));

  # Expects z3 to be on path so we replace it with a hard
  #
  # The tests expect additional solvers on the path, replace the
  # available ones also with hard coded paths, and remove the missing
  # ones from the test.
  sbv = overrideCabal super.sbv (drv: {
    postPatch = ''
      sed -i -e 's|"abc"|"${pkgs.abc-verifier}/bin/abc"|' Data/SBV/Provers/ABC.hs
      sed -i -e 's|"boolector"|"${pkgs.boolector}/bin/boolector"|' Data/SBV/Provers/Boolector.hs
      sed -i -e 's|"cvc4"|"${pkgs.cvc4}/bin/cvc4"|' Data/SBV/Provers/CVC4.hs
      sed -i -e 's|"yices-smt2"|"${pkgs.yices}/bin/yices-smt2"|' Data/SBV/Provers/Yices.hs
      sed -i -e 's|"z3"|"${pkgs.z3}/bin/z3"|' Data/SBV/Provers/Z3.hs

      sed -i -e 's|\[abc, boolector, cvc4, mathSAT, yices, z3, dReal\]|[abc, boolector, cvc4, yices, z3]|' SBVTestSuite/SBVConnectionTest.hs
   '';
  });

  # The test-suite requires a running PostgreSQL server.
  Frames-beam = dontCheck super.Frames-beam;

  # Compile manpages (which are in RST and are compiled with Sphinx).
  futhark =
    overrideCabal (addBuildTools super.futhark (with pkgs.buildPackages; [makeWrapper python3Packages.sphinx]))
      (_drv: {
        postBuild = (_drv.postBuild or "") + ''
        make -C docs man
        '';

        postInstall = (_drv.postInstall or "") + ''
        mkdir -p $out/share/man/man1
        mv docs/_build/man/*.1 $out/share/man/man1/
        '';
      });

  git-annex = with pkgs;
    if (!stdenv.isLinux) then
      let path = lib.makeBinPath [ coreutils ];
      in overrideCabal (addBuildTool super.git-annex buildPackages.makeWrapper) (_drv: {
        # This is an instance of https://github.com/NixOS/nix/pull/1085
        # Fails with:
        #   gpg: can't connect to the agent: File name too long
        postPatch = lib.optionalString stdenv.isDarwin ''
          substituteInPlace Test.hs \
            --replace ', testCase "crypto" test_crypto' ""
        '';
        # On Darwin, git-annex mis-detects options to `cp`, so we wrap the
        # binary to ensure it uses Nixpkgs' coreutils.
        postFixup = ''
          wrapProgram $out/bin/git-annex \
            --prefix PATH : "${path}"
        '';
      })
    else super.git-annex;

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
  cairo = addBuildTool super.cairo self.buildHaskellPackages.gtk2hs-buildtools;
  pango = disableHardening (addBuildTool super.pango self.buildHaskellPackages.gtk2hs-buildtools) ["fortify"];

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

      spagoWithPatches = appendPatch super.spago (
        # Spago needs a small patch to work with versions-5.0.0:
        # https://github.com/purescript/spago/pull/798
        # This can probably be removed with >spago-0.20.3.
        pkgs.fetchpatch {
          url = "https://github.com/purescript/spago/commit/dd4bf4413d9675c1c8065d24d0ed7b345c7fa5dd.patch";
          sha256 = "1i1r3f4n9mlkckx15bfrdy5m7gjf0zx7ycwyqra6qn34zpcbzpmf";
        }
      );

      spagoWithOverrides = spagoWithPatches.override {
        # spago has not yet been updated for the latest dhall.
        dhall = self.dhall_1_38_1;
      };

      spagoDocs = overrideCabal spagoWithOverrides (drv: {
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
      });

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
    in overrideCabal (addBuildTool super.mplayer-spot pkgs.buildPackages.makeWrapper) (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/mplayer-spot --prefix PATH : "${path}"
      '';
    });

  # break infinite recursion with base-orphans
  primitive = dontCheck super.primitive;
  primitive_0_7_1_0 = dontCheck super.primitive_0_7_1_0;

  cut-the-crap =
    let path = pkgs.lib.makeBinPath [ pkgs.ffmpeg pkgs.youtube-dl ];
    in overrideCabal (addBuildTool super.cut-the-crap pkgs.buildPackages.makeWrapper) (_drv: {
      postInstall = ''
        wrapProgram $out/bin/cut-the-crap \
          --prefix PATH : "${path}"
      '';
    });

  # Tests access homeless-shelter.
  hie-bios = dontCheck super.hie-bios;
  hie-bios_0_5_0 = dontCheck super.hie-bios_0_5_0;

  # Compiling the readme throws errors and has no purpose in nixpkgs
  aeson-gadt-th =
    disableCabalFlag (doJailbreak (super.aeson-gadt-th)) "build-readme";

  neuron = overrideCabal (super.neuron) (drv: {
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
  });

  # Fix compilation of Setup.hs by removing the module declaration.
  # See: https://github.com/tippenein/guid/issues/1
  guid = overrideCabal (super.guid) (drv: {
    prePatch = "sed -i '1d' Setup.hs"; # 1st line is module declaration, remove it
    doCheck = false;
  });

  # Tests disabled as recommended at https://github.com/luke-clifton/shh/issues/39
  shh = dontCheck super.shh;

  # The test suites fail because there's no PostgreSQL database running in our
  # build sandbox.
  hasql-queue = dontCheck super.hasql-queue;
  postgresql-libpq-notify = dontCheck super.postgresql-libpq-notify;
  postgresql-pure = dontCheck super.postgresql-pure;

  retrie = overrideCabal super.retrie (drv: {
    testToolDepends = [ pkgs.git pkgs.mercurial ];
  });

  nix-output-monitor = overrideCabal super.nix-output-monitor {
    # Can't ran the golden-tests with nix, because they call nix
    testTarget = "unit-tests";
  };

  haskell-language-server = overrideCabal super.haskell-language-server (drv: {
    postInstall = "ln -s $out/bin/haskell-language-server $out/bin/haskell-language-server-${self.ghc.version}";
    testToolDepends = [ self.cabal-install pkgs.git ];
    testTarget = "func-test"; # wrapper test accesses internet
    preCheck = ''
      export PATH=$PATH:$PWD/dist/build/haskell-language-server:$PWD/dist/build/haskell-language-server-wrapper
      export HOME=$TMPDIR
    '';
  });

  # tests depend on a specific version of solc
  hevm = dontCheck (doJailbreak super.hevm);

  # hadolint enables static linking by default in the cabal file, so we have to explicitly disable it.
  # https://github.com/hadolint/hadolint/commit/e1305042c62d52c2af4d77cdce5d62f6a0a3ce7b
  hadolint = disableCabalFlag super.hadolint "static";

  # Test suite tries to execute the build product "doctest-driver-gen", but it's not in $PATH.
  doctest-driver-gen = dontCheck super.doctest-driver-gen;

  # Tests access internet
  prune-juice = dontCheck super.prune-juice;

  # based on https://github.com/gibiansky/IHaskell/blob/aafeabef786154d81ab7d9d1882bbcd06fc8c6c4/release.nix
  ihaskell = overrideCabal super.ihaskell (drv: {
    configureFlags = (drv.configureFlags or []) ++ [
      # ihaskell's cabal file forces building a shared executable,
      # but without passing --enable-executable-dynamic, the RPATH
      # contains /build/ and leads to a build failure with nix
      "--enable-executable-dynamic"
    ];
    preCheck = ''
      export HOME=$TMPDIR/home
      export PATH=$PWD/dist/build/ihaskell:$PATH
      export GHC_PACKAGE_PATH=$PWD/dist/package.conf.inplace/:$GHC_PACKAGE_PATH
    '';
  });

  # tests need to execute the built executable
  stutter = overrideCabal super.stutter (drv: {
    preCheck = ''
      export PATH=dist/build/stutter:$PATH
    '' + (drv.preCheck or "");
  });

  # Install man page and generate shell completions
  pinboard-notes-backup = overrideCabal
    (generateOptparseApplicativeCompletion "pnbackup" super.pinboard-notes-backup)
    (drv: {
      postInstall = ''
        install -D man/pnbackup.1 $out/share/man/man1/pnbackup.1
      '' + (drv.postInstall or "");
    });

  # set more accurate set of platforms instead of maintaining
  # an ever growing list of platforms to exclude via unsupported-platforms
  cpuid = overrideCabal super.cpuid {
    platforms = pkgs.lib.platforms.x86;
  };

  # Pass the correct libarchive into the package.
  streamly-archive = super.streamly-archive.override { archive = pkgs.libarchive; };

  # passes the -msse2 flag which only works on x86 platforms
  hsignal = overrideCabal super.hsignal {
    platforms = pkgs.lib.platforms.x86;
  };

  # uses x86 intrinsics
  blake3 = overrideCabal super.blake3 {
    platforms = pkgs.lib.platforms.x86;
  };

  # uses x86 intrinsics, see also https://github.com/NixOS/nixpkgs/issues/122014
  crc32c = overrideCabal super.crc32c {
    platforms = pkgs.lib.platforms.x86;
  };

  # uses x86 intrinsics
  seqalign = overrideCabal super.seqalign {
    platforms = pkgs.lib.platforms.x86;
  };

  # uses x86 intrinsics
  geomancy = overrideCabal super.geomancy {
    platforms = pkgs.lib.platforms.x86;
  };

  hls-brittany-plugin = overrideCabal super.hls-brittany-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-class-plugin = overrideCabal super.hls-class-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-ormolu-plugin = overrideCabal super.hls-ormolu-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-fourmolu-plugin = overrideCabal super.hls-fourmolu-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-module-name-plugin = overrideCabal super.hls-module-name-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-rename-plugin = overrideCabal super.hls-rename-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '' + (drv.preCheck or "");
  });
  hls-splice-plugin = overrideCabal super.hls-splice-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-floskell-plugin = overrideCabal super.hls-floskell-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-pragmas-plugin = overrideCabal super.hls-pragmas-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hiedb = overrideCabal super.hiedb (drv: {
    preCheck = ''
      export PATH=$PWD/dist/build/hiedb:$PATH
    '';
  });
  hls-call-hierarchy-plugin = overrideCabal super.hls-call-hierarchy-plugin (drv: {
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  # Tests have file permissions expections that don‘t work with the nix store.
  hls-stylish-haskell-plugin = dontCheck super.hls-stylish-haskell-plugin;
  hls-haddock-comments-plugin = overrideCabal super.hls-haddock-comments-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });
  hls-eval-plugin = overrideCabal super.hls-eval-plugin (drv: {
    testToolDepends = [ pkgs.git ];
    preCheck = ''
      export HOME=$TMPDIR/home
    '';
  });

  taglib = overrideCabal super.taglib (drv: {
    librarySystemDepends = [
      pkgs.zlib
    ] ++ (drv.librarySystemDepends or []);
  });

  # uses x86 assembler
  inline-asm = overrideCabal super.inline-asm {
    platforms = pkgs.lib.platforms.x86;
  };

  # uses x86 assembler in C bits
  hw-prim-bits = overrideCabal super.hw-prim-bits {
    platforms = pkgs.lib.platforms.x86;
  };

  # random 1.2.0 has tests that indirectly depend on
  # itself causing an infinite recursion at evaluation
  # time
  random = dontCheck super.random;

  # Since this package is primarily used by nixpkgs maintainers and is probably
  # not used to link against by anyone, we can make it’s closure smaller and
  # add its runtime dependencies in `haskellPackages` (as opposed to cabal2nix).
  cabal2nix-unstable = overrideCabal
    (justStaticExecutables super.cabal2nix-unstable)
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
    });

  # test suite needs local redis daemon
  nri-redis = dontCheck super.nri-redis;

  # Make tophat find itself for _compiling_ its test suite
  tophat = overrideCabal super.tophat (drv: {
    postPatch = ''
      sed -i 's|"tophat"|"./dist/build/tophat/tophat"|' app-test-bin/*.hs
    '' + (drv.postPatch or "");
  });

  # Runtime dependencies and CLI completion
  nvfetcher = generateOptparseApplicativeCompletion "nvfetcher" (overrideCabal
    super.nvfetcher (drv: {
      # test needs network
      doCheck = false;
      buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/nvfetcher" --prefix 'PATH' ':' "${
          pkgs.lib.makeBinPath [ pkgs.nvchecker pkgs.nix-prefetch-git ]
        }"
      '';
    }));

  rel8 = addTestToolDepend super.rel8 pkgs.postgresql;

  cachix = generateOptparseApplicativeCompletion "cachix" (super.cachix.override { nix = pkgs.nix_2_3; });

  hercules-ci-agent = super.hercules-ci-agent.override { nix = pkgs.nix_2_3; };
  hercules-ci-cnix-expr = super.hercules-ci-cnix-expr.override { nix = pkgs.nix_2_3; };
  hercules-ci-cnix-store = super.hercules-ci-cnix-store.override { nix = pkgs.nix_2_3; };

  # Enable extra optimisations which increase build time, but also
  # later compiler performance, so we should do this for user's benefit.
  # Flag added in Agda 2.6.2
  Agda = appendConfigureFlag super.Agda "-foptimise-heavily";

  # ats-format uses cli-setup in Setup.hs which is quite happy to write
  # to arbitrary files in $HOME. This doesn't either not achieve anything
  # or even fail, so we prevent it and install everything necessary ourselves.
  # See also: https://hackage.haskell.org/package/cli-setup-0.2.1.4/docs/src/Distribution.CommandLine.html#setManpathGeneric
  ats-format = generateOptparseApplicativeCompletion "atsfmt" (
    justStaticExecutables (
      overrideCabal super.ats-format (drv: {
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
      })
    )
  );

  # Test suite is just the default example executable which doesn't work if not
  # executed by Setup.hs, but works if started on a proper TTY
  isocline = dontCheck super.isocline;

  # Some hash implementations are x86 only, but part of the test suite.
  # So executing and building it on non-x86 platforms will always fail.
  hashes = overrideCabal super.hashes {
    doCheck = with pkgs.stdenv; hostPlatform == buildPlatform
      && buildPlatform.isx86;
  };

  # procex relies on close_range which has been introduced in Linux 5.9,
  # the test suite seems to force the use of this feature (or the fallback
  # mechanism is broken), so we can't run the test suite on machines with a
  # Kernel < 5.9. To check for this, we use uname -r to obtain the Kernel
  # version and sort -V to compare against our minimum version. If the
  # Kernel turns out to be older, we disable the test suite.
  procex = overrideCabal super.procex (drv: {
    postConfigure = ''
      minimumKernel=5.9
      higherVersion=`printf "%s\n%s\n" "$minimumKernel" "$(uname -r)" | sort -rV | head -n1`
      if [[ "$higherVersion" = "$minimumKernel" ]]; then
        echo "Used Kernel doesn't support close_range, disabling tests"
        unset doCheck
      fi
    '' + (drv.postConfigure or "");
  });
}
