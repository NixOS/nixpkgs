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
  mysql = dontCheck (super.mysql.override { mysql = pkgs.mysql.connector-c; });

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

  hzk = overrideCabal super.hzk (drv: {
    preConfigure = "sed -i -e /include-dirs/d hzk.cabal";
    configureFlags =  "--extra-include-dirs=${pkgs.zookeeper_mt}/include/zookeeper";
  });

  haskakafka = overrideCabal super.haskakafka (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d haskakafka.cabal";
    configureFlags =  "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka";
  });

  # library has hard coded directories that need to be removed. Reported upstream here https://github.com/haskell-works/hw-kafka-client/issues/32
  hw-kafka-client = dontCheck (overrideCabal super.hw-kafka-client (drv: {
    preConfigure = "sed -i -e /extra-lib-dirs/d -e /include-dirs/d -e /librdkafka/d hw-kafka-client.cabal";
    configureFlags =  "--extra-include-dirs=${pkgs.rdkafka}/include/librdkafka";
  }));

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

  # Fix Darwin build.
  halive = if pkgs.stdenv.isDarwin
    then addBuildDepend super.halive pkgs.darwin.apple_sdk.frameworks.AppKit
    else super.halive;

  # Heist's test suite requires system pandoc
  heist = overrideCabal super.heist (drv: {
    testToolDepends = [pkgs.pandoc];
  });

  # the system-fileio tests use canonicalizePath, which fails in the sandbox
  system-fileio = if pkgs.stdenv.isDarwin then dontCheck super.system-fileio else super.system-fileio;

  # Prevents needing to add security_tool as a build tool to all of x509-system's
  # dependencies.
  x509-system = if pkgs.stdenv.targetPlatform.isDarwin && !pkgs.stdenv.cc.nativeLibc
    then let inherit (pkgs.darwin) security_tool;
      in pkgs.lib.overrideDerivation (addBuildDepend super.x509-system security_tool) (drv: {
        postPatch = (drv.postPatch or "") + ''
          substituteInPlace System/X509/MacOS.hs --replace security ${security_tool}/bin/security
        '';
      })
    else super.x509-system;

  # https://github.com/NixOS/cabal2nix/issues/136 and https://github.com/NixOS/cabal2nix/issues/216
  gio = disableHardening (addPkgconfigDepend (addBuildTool super.gio self.buildHaskellPackages.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  glib = disableHardening (addPkgconfigDepend (addBuildTool super.glib self.buildHaskellPackages.gtk2hs-buildtools) pkgs.glib) ["fortify"];
  gtk3 = disableHardening (super.gtk3.override { inherit (pkgs) gtk3; }) ["fortify"];
  gtk = disableHardening (addPkgconfigDepend (addBuildTool super.gtk self.buildHaskellPackages.gtk2hs-buildtools) pkgs.gtk2) ["fortify"];
  gtksourceview2 = addPkgconfigDepend super.gtksourceview2 pkgs.gtk2;
  gtk-traymanager = addPkgconfigDepend super.gtk-traymanager pkgs.gtk3;

  # Add necessary reference to gtk3 package, plus specify needed dbus version, plus turn on strictDeps to fix build
  taffybar = ((addPkgconfigDepend super.taffybar pkgs.gtk3).overrideDerivation (drv: { strictDeps = true; }));

  # Add necessary reference to gtk3 package
  gi-dbusmenugtk3 = addPkgconfigDepend super.gi-dbusmenugtk3 pkgs.gtk3;

  # Need WebkitGTK, not just webkit.
  webkit = super.webkit.override { webkit = pkgs.webkitgtk24x-gtk2; };
  websnap = super.websnap.override { webkit = pkgs.webkitgtk24x-gtk3; };

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
  download = dontCheck super.download;
  http-client = dontCheck super.http-client;
  http-client-openssl = dontCheck super.http-client-openssl;
  http-client-tls = dontCheck super.http-client-tls;
  http-conduit = dontCheck super.http-conduit;
  transient-universe = dontCheck super.transient-universe;
  typed-process = dontCheck super.typed-process;
  js-jquery = dontCheck super.js-jquery;
  hPDB-examples = dontCheck super.hPDB-examples;
  configuration-tools = dontCheck super.configuration-tools; # https://github.com/alephcloud/hs-configuration-tools/issues/40
  tcp-streams = dontCheck super.tcp-streams;
  holy-project = dontCheck super.holy-project;
  mustache = dontCheck super.mustache;

  # Tries to mess with extended POSIX attributes, but can't in our chroot environment.
  xattr = dontCheck super.xattr;

  # Needs access to locale data, but looks for it in the wrong place.
  scholdoc-citeproc = dontCheck super.scholdoc-citeproc;

  # Disable tests because they require a mattermost server
  mattermost-api = dontCheck super.mattermost-api;

  # Expect to find sendmail(1) in $PATH.
  mime-mail = appendConfigureFlag super.mime-mail "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"";

  # Help the test suite find system timezone data.
  tz = overrideCabal super.tz (drv: { preConfigure = "export TZDIR=${pkgs.tzdata}/share/zoneinfo"; });

  # Nix-specific workaround
  xmonad = appendPatch (dontCheck super.xmonad) ./patches/xmonad-nix.patch;

  # wxc supports wxGTX >= 3.0, but our current default version points to 2.8.
  # http://hydra.cryp.to/build/1331287/log/raw
  wxc = (addBuildDepend super.wxc self.split).override { wxGTK = pkgs.wxGTK30; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK30; };

  # Test suite wants to connect to $DISPLAY.
  hsqml = dontCheck (addExtraLibrary (super.hsqml.override { qt5 = pkgs.qt5Full; }) pkgs.libGLU_combined);

  # Tests attempt to use NPM to install from the network into
  # /homeless-shelter. Disabled.
  purescript = dontCheck super.purescript;

  # https://github.com/haskell-foundation/foundation/pull/412
  foundation =
    if pkgs.stdenv.isDarwin
    then dontCheck super.foundation
    else super.foundation;

  # Hardcoded include path
  poppler = overrideCabal super.poppler (drv: {
    postPatch = ''
      sed -i -e 's,glib/poppler.h,poppler.h,' poppler.cabal
      sed -i -e 's,glib/poppler.h,poppler.h,' Graphics/UI/Gtk/Poppler/Structs.hsc
    '';
  });

  # Uses OpenGL in testing
  caramia = dontCheck super.caramia;

  llvm-general =
    # Supports only 3.5 for now, https://github.com/bscarlet/llvm-general/issues/142
    let base = super.llvm-general.override { llvm-config = pkgs.llvm_35; };
    in if !pkgs.stdenv.isDarwin then base else overrideCabal base (
      drv: {
        preConfigure = ''
          sed -i llvm-general.cabal \
              -e 's,extra-libraries: stdc++,extra-libraries: c++,'
        '';
        configureFlags = (drv.configureFlags or []) ++ ["--extra-include-dirs=${pkgs.libcxx}/include/c++/v1"];
        librarySystemDepends = [ pkgs.libcxx ] ++ drv.librarySystemDepends or [];
      }
    );

  llvm-hs =
      let dontCheckDarwin = if pkgs.stdenv.isDarwin
                            then dontCheck
                            else pkgs.lib.id;
      in dontCheckDarwin (super.llvm-hs.override {
        llvm-config = pkgs.llvm_6;
      });

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

  yesod-bin = if pkgs.stdenv.isDarwin
    then addBuildDepend super.yesod-bin pkgs.darwin.apple_sdk.frameworks.Cocoa
    else super.yesod-bin;

  hmatrix = if pkgs.stdenv.isDarwin
    then addBuildDepend super.hmatrix pkgs.darwin.apple_sdk.frameworks.Accelerate
    else super.hmatrix;

  # https://github.com/edwinb/EpiVM/issues/13
  # https://github.com/edwinb/EpiVM/issues/14
  epic = addExtraLibraries (addBuildTool super.epic self.buildHaskellPackages.happy) [pkgs.boehmgc pkgs.gmp];

  # https://github.com/ekmett/wl-pprint-terminfo/issues/7
  wl-pprint-terminfo = addExtraLibrary super.wl-pprint-terminfo pkgs.ncurses;

  # https://github.com/bos/pcap/issues/5
  pcap = addExtraLibrary super.pcap pkgs.libpcap;

  # https://github.com/snoyberg/yaml/issues/106
  yaml = disableCabalFlag super.yaml "system-libyaml";

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
    libraryToolDepends = (drv.libraryToolDepends or []) ++ [pkgs.autoconf];
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.fltk13 pkgs.libGL pkgs.libjpeg];
  });

  # https://github.com/skogsbaer/hscurses/pull/26
  hscurses = overrideCabal super.hscurses (drv: {
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [ pkgs.ncurses ];
  });

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

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

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is really required
  # on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = if pkgs.stdenv.isDarwin then self.hfsevents else super.hinotify;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = if pkgs.stdenv.isDarwin
    then addBuildDepend (dontCheck super.fsnotify) pkgs.darwin.apple_sdk.frameworks.Cocoa
    else dontCheck super.fsnotify;

  hidapi = addExtraLibrary super.hidapi pkgs.udev;

  hs-GeoIP = super.hs-GeoIP.override { GeoIP = pkgs.geoipWithDatabase; };

  discount = super.discount.override { markdown = pkgs.discount; };

  # tests require working stack installation with all-cabal-hashes cloned in $HOME
  stackage-curator = dontCheck super.stackage-curator;

  # hardcodes /usr/bin/tr: https://github.com/snapframework/io-streams/pull/59
  io-streams = enableCabalFlag super.io-streams "NoInteractiveTests";

  # requires autotools to build
  secp256k1 = addBuildTools super.secp256k1 [ pkgs.buildPackages.autoconf pkgs.buildPackages.automake pkgs.buildPackages.libtool ];

  # tests require git
  hapistrano = addBuildTool super.hapistrano pkgs.buildPackages.git;

  # This propagates this to everything depending on haskell-gi-base
  haskell-gi-base = addBuildDepend super.haskell-gi-base pkgs.gobjectIntrospection;

  # requires valid, writeable $HOME
  hatex-guide = overrideCabal super.hatex-guide (drv: {
    preConfigure = ''
      ${drv.preConfigure or ""}
      export HOME=$PWD
    '';
  });

  # https://github.com/plow-technologies/servant-streaming/issues/12
  servant-streaming-server = dontCheck super.servant-streaming-server;

  # tests run executable, relying on PATH
  # without this, tests fail with "Couldn't launch intero process"
  intero = overrideCabal super.intero (drv: {
    preCheck = ''
      export PATH="$PWD/dist/build/intero:$PATH"
    '';
  });

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
}
