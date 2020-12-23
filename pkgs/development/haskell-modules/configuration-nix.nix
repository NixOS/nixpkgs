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
  mysql = dontCheck (super.mysql.override { mysql = pkgs.libmysqlclient; });

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

  # profiling is disabled to allow C++/C mess to work, which is fixed in GHC 8.8
  cachix = overrideSrc (disableLibraryProfiling super.cachix) {
    src = (pkgs.fetchFromGitHub {
      owner = "cachix";
      repo = "cachix";
      rev = "1471050f5906ecb7cd0d72115503d07d2e3beb17";
      sha256 = "1lkrmhv5x9dpy53w33kxnhv4x4qm711ha8hsgccrjmxaqcsdm59g";
    }) + "/cachix";
    version = "0.5.1";
  };
  hercules-ci-agent = disableLibraryProfiling super.hercules-ci-agent;

  # avoid compiling twice by providing executable as a separate output (with small closure size)
  niv = enableSeparateBinOutput super.niv;
  ormolu = enableSeparateBinOutput super.ormolu;
  ghcid = enableSeparateBinOutput super.ghcid;

  # Ensure the necessary frameworks for Darwin.
  OpenAL = if pkgs.stdenv.isDarwin
    then addExtraLibrary super.OpenAL pkgs.darwin.apple_sdk.frameworks.OpenAL
    else super.OpenAL;

  # Ensure the necessary frameworks for Darwin.
  proteaaudio = if pkgs.stdenv.isDarwin
    then addExtraLibrary super.proteaaudio pkgs.darwin.apple_sdk.frameworks.AudioToolbox
    else super.proteaaudio;


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

  # Prevents needing to add `security_tool` as a run-time dependency for
  # everything using x509-system to give access to the `security` executable.
  x509-system =
    if pkgs.stdenv.hostPlatform.isDarwin && !pkgs.stdenv.cc.nativeLibc
    then
      # darwin.security_tool is broken in Mojave (#45042)

      # We will use the system provided security for now.
      # Beware this WILL break in sandboxes!

      # TODO(matthewbauer): If someone really needs this to work in sandboxes,
      # I think we can add a propagatedImpureHost dep here, but I’m hoping to
      # get a proper fix available soonish.
      overrideCabal super.x509-system (drv: {
        postPatch = (drv.postPatch or "") + ''
          substituteInPlace System/X509/MacOS.hs --replace security /usr/bin/security
        '';
      })
    else super.x509-system;

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
  hsqml = dontCheck (addExtraLibraries (super.hsqml.override { qt5 = pkgs.qt5Full; }) [pkgs.libGLU pkgs.libGL]);

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

  llvm-hs =
    let llvmHsWithLlvm9 = super.llvm-hs.override { llvm-config = pkgs.llvm_9; };
    in
    if pkgs.stdenv.isDarwin
    then
      overrideCabal llvmHsWithLlvm9 (oldAttrs: {
        # One test fails on darwin.
        doCheck = false;
        # llvm-hs's Setup.hs file tries to add the lib/ directory from LLVM8 to
        # the DYLD_LIBRARY_PATH environment variable.  This messes up clang
        # when called from GHC, probably because clang is version 7, but we are
        # using LLVM8.
        preCompileBuildDriver = oldAttrs.preCompileBuildDriver or "" + ''
          substituteInPlace Setup.hs --replace "addToLdLibraryPath libDir" "pure ()"
        '';
      })
    else llvmHsWithLlvm9;

  # Needs help finding LLVM.
  spaceprobe = addBuildTool super.spaceprobe self.llvmPackages.llvm;

  # Tries to run GUI in tests
  leksah = dontCheck (overrideCabal super.leksah (drv: {
    executableSystemDepends = (drv.executableSystemDepends or []) ++ (with pkgs; [
      gnome3.adwaita-icon-theme # Fix error: Icon 'window-close' not present in theme ...
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

  # requires an X11 display in test suite
  gi-gtk-declarative = dontCheck super.gi-gtk-declarative;

  # depends on 'hie' executable
  lsp-test = dontCheck super.lsp-test;

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

  # requires libsecp256k1 in pkgconfig-depends
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
  splitmix_0_1_0_3 = dontCheck super.splitmix_0_1_0_3;

  # Break infinite recursion cycle between tasty and clock.
  clock = dontCheck super.clock;

  # Break infinite recursion cycle between devtools and mprelude.
  devtools = super.devtools.override { mprelude = dontCheck super.mprelude; };

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
  futhark = with pkgs;
    overrideCabal (addBuildTools super.futhark [makeWrapper python37Packages.sphinx])
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
      let path = stdenv.lib.makeBinPath [ coreutils ];
      in overrideCabal (addBuildTool super.git-annex makeWrapper) (_drv: {
        # This is an instance of https://github.com/NixOS/nix/pull/1085
        # Fails with:
        #   gpg: can't connect to the agent: File name too long
        postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
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
      # spago requires an older version of megaparsec, but it appears to work
      # fine with newer versions.
      spagoWithOverrides = doJailbreak super.spago;

      # This defines the version of the purescript-docs-search release we are using.
      # This is defined in the src/Spago/Prelude.hs file in the spago source.
      docsSearchVersion = "v0.0.10";

      docsSearchAppJsFile = pkgs.fetchurl {
        url = "https://github.com/spacchetti/purescript-docs-search/releases/download/${docsSearchVersion}/docs-search-app.js";
        sha256 = "0m5ah29x290r0zk19hx2wix2djy7bs4plh9kvjz6bs9r45x25pa5";
      };

      purescriptDocsSearchFile = pkgs.fetchurl {
        url = "https://github.com/spacchetti/purescript-docs-search/releases/download/${docsSearchVersion}/purescript-docs-search";
        sha256 = "0wc1zyhli4m2yykc6i0crm048gyizxh7b81n8xc4yb7ibjqwhyj3";
      };

      spagoFixHpack = overrideCabal spagoWithOverrides (drv: {
        postUnpack = (drv.postUnpack or "") + ''
          # The source for spago is pulled directly from GitHub.  It uses a
          # package.yaml file with hpack, not a .cabal file.  In the package.yaml file,
          # it uses defaults from the master branch of the hspec repo.  It will try to
          # fetch these at build-time (but it will fail if running in the sandbox).
          #
          # The following line modifies the package.yaml to not pull in
          # defaults from the hspec repo.
          substituteInPlace "$sourceRoot/package.yaml" --replace 'defaults: hspec/hspec@master' ""

          # Spago includes the following two files directly into the binary
          # with Template Haskell.  They are fetched at build-time from the
          # `purescript-docs-search` repo above.  If they cannot be fetched at
          # build-time, they are pulled in from the `templates/` directory in
          # the spago source.
          #
          # However, they are not actually available in the spago source, so they
          # need to fetched with nix and put in the correct place.
          # https://github.com/spacchetti/spago/issues/510
          cp ${docsSearchAppJsFile} "$sourceRoot/templates/docs-search-app.js"
          cp ${purescriptDocsSearchFile} "$sourceRoot/templates/purescript-docs-search"

          # For some weird reason, on Darwin, the open(2) call to embed these files
          # requires write permissions. The easiest resolution is just to permit that
          # (doesn't cause any harm on other systems).
          chmod u+w "$sourceRoot/templates/docs-search-app.js" "$sourceRoot/templates/purescript-docs-search"
        '';
      });

      # Because of the problem above with pulling in hspec defaults to the
      # package.yaml file, the tests are disabled.
      spagoWithoutChecks = dontCheck spagoFixHpack;
    in
    spagoWithoutChecks;

  # checks SQL statements at compile time, and so requires a running PostgreSQL
  # database to run it's test suite
  postgresql-typed = dontCheck super.postgresql-typed;

  # mplayer-spot uses mplayer at runtime.
  mplayer-spot =
    let path = pkgs.stdenv.lib.makeBinPath [ pkgs.mplayer ];
    in overrideCabal (addBuildTool super.mplayer-spot pkgs.makeWrapper) (oldAttrs: {
      postInstall = ''
        wrapProgram $out/bin/mplayer-spot --prefix PATH : "${path}"
      '';
    });

  # break infinite recursion with base-orphans
  primitive = dontCheck super.primitive;
  primitive_0_7_1_0 = dontCheck super.primitive_0_7_1_0;

  cut-the-crap =
    let path = pkgs.stdenv.lib.makeBinPath [ pkgs.ffmpeg_3 pkgs.youtube-dl ];
    in overrideCabal (addBuildTool super.cut-the-crap pkgs.makeWrapper) (_drv: {
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
    buildTools = [ pkgs.makeWrapper ];
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
    postInstall = let
      inherit (pkgs.lib) concatStringsSep take splitString;
      ghc_version = self.ghc.version;
      ghc_major_version = concatStringsSep "." (take 2 (splitString "." ghc_version));
    in ''
        ln -s $out/bin/haskell-language-server $out/bin/haskell-language-server-${ghc_version}
        ln -s $out/bin/haskell-language-server $out/bin/haskell-language-server-${ghc_major_version}
       '';
    testToolDepends = [ self.cabal-install pkgs.git ];
    testTarget = "func-test"; # wrapper test accesses internet
    preCheck = ''
      export PATH=$PATH:$PWD/dist/build/haskell-language-server:$PWD/dist/build/haskell-language-server-wrapper
      export HOME=$TMPDIR
    '';
  });

  # tests depend on a specific version of solc
  hevm = dontCheck (doJailbreak super.hevm);
}
