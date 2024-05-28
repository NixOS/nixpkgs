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

let
  inherit (pkgs) lib;
in

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

  #######################################
  ### HASKELL-LANGUAGE-SERVER SECTION ###
  #######################################

  haskell-language-server = overrideCabal (drv: {
    # starting with 1.6.1.1 haskell-language-server wants to be linked dynamically
    # by default. Unless we reflect this in the generic builder, GHC is going to
    # produce some illegal references to /build/.
    enableSharedExecutables = true;
    # The shell script wrapper checks that the runtime ghc and its boot packages match the ghc hls was compiled with.
    # This prevents linking issues when running TH splices.
    postInstall = ''
      mv "$out/bin/haskell-language-server" "$out/bin/.haskell-language-server-${self.ghc.version}-unwrapped"
      BOOT_PKGS=`ghc-pkg-${self.ghc.version} --global list --simple-output`
      ${pkgs.buildPackages.gnused}/bin/sed \
        -e "s!@@EXE_DIR@@!$out/bin!" \
        -e "s/@@EXE_NAME@@/.haskell-language-server-${self.ghc.version}-unwrapped/" \
        -e "s/@@GHC_VERSION@@/${self.ghc.version}/" \
        -e "s/@@BOOT_PKGS@@/$BOOT_PKGS/" \
        -e "s/@@ABI_HASHES@@/$(for dep in $BOOT_PKGS; do printf "%s:" "$dep" && ghc-pkg-${self.ghc.version} field $dep abi --simple-output ; done | tr '\n' ' ' | xargs)/" \
        -e "s!Consider installing ghc.* via ghcup or build HLS from source.!Visit https://nixos.org/manual/nixpkgs/unstable/#haskell-language-server to learn how to correctly install a matching hls for your ghc with nix.!" \
        bindist/wrapper.in > "$out/bin/haskell-language-server"
      ln -s "$out/bin/haskell-language-server" "$out/bin/haskell-language-server-${self.ghc.version}"
      chmod +x "$out/bin/haskell-language-server"
      '';
    testToolDepends = [ self.cabal-install pkgs.git ];
    testTarget = "func-test"; # wrapper test accesses internet
    preCheck = ''
      export PATH=$PATH:$PWD/dist/build/haskell-language-server:$PWD/dist/build/haskell-language-server-wrapper
      export HOME=$TMPDIR
    '';
  }) super.haskell-language-server;

  # ghcide-bench tests need network
  ghcide-bench = dontCheck super.ghcide-bench;

  # 2023-04-01: TODO: Either reenable at least some tests or remove the preCheck override
  ghcide = overrideCabal (drv: {
    # tests depend on executable
    preCheck = ''export PATH="$PWD/dist/build/ghcide:$PATH"'';
    # tests disabled because they require network
    doCheck = false;
  }) super.ghcide;

  hiedb = overrideCabal (drv: {
    preCheck = ''
      export PATH=$PWD/dist/build/hiedb:$PATH
    '';
  }) super.hiedb;

  # Tests access homeless-shelter.
  hie-bios = dontCheck super.hie-bios;

  ###########################################
  ### END HASKELL-LANGUAGE-SERVER SECTION ###
  ###########################################

  # Test suite needs executable
  agda2lagda = overrideCabal (drv: {
    preCheck = ''
      export PATH="$PWD/dist/build/agda2lagda:$PATH"
    '' + drv.preCheck or "";
  }) super.agda2lagda;


  audacity = enableCabalFlag "buildExamples" (overrideCabal (drv: {
      executableHaskellDepends = [self.optparse-applicative self.soxlib];
    }) super.audacity);
  # 2023-04-27: Deactivating examples for now because they cause a non-trivial build failure.
  # med-module = enableCabalFlag "buildExamples" super.med-module;
  spreadsheet = enableCabalFlag "buildExamples" (overrideCabal (drv: {
      executableHaskellDepends = [self.optparse-applicative self.shell-utility];
    }) super.spreadsheet);

  # fix errors caused by hardening flags
  epanet-haskell = disableHardening ["format"] super.epanet-haskell;

  # Link the proper version.
  zeromq4-haskell = super.zeromq4-haskell.override { zeromq = pkgs.zeromq4; };

  threadscope = enableSeparateBinOutput super.threadscope;

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

  # hledger* overrides
  inherit (
    let
      installHledgerExtraFiles = overrideCabal (drv: {
        buildTools = drv.buildTools or [] ++ [
          pkgs.buildPackages.installShellFiles
        ];
        postInstall = ''
          for i in $(seq 1 9); do
            installManPage *.$i
          done

          install -v -Dm644 *.info* -t "$out/share/info/"

          if [ -e shell-completion/hledger-completion.bash ]; then
            installShellCompletion --name hledger shell-completion/hledger-completion.bash
          fi
        '';
      });

      hledgerWebTestFix = overrideCabal (drv: {
        preCheck = ''
          ${drv.preCheck or ""}
          export HOME="$(mktemp -d)"
        '';
      });
    in
    {
      hledger = installHledgerExtraFiles super.hledger;
      hledger-web = installHledgerExtraFiles (hledgerWebTestFix super.hledger-web);
      hledger-ui = installHledgerExtraFiles super.hledger-ui;

      hledger_1_30_1 = installHledgerExtraFiles
        (doDistribute (super.hledger_1_30_1.override {
          hledger-lib = self.hledger-lib_1_30;
        }));
      hledger-web_1_30 = installHledgerExtraFiles (hledgerWebTestFix
        (doDistribute (super.hledger-web_1_30.override {
          hledger = self.hledger_1_30_1;
          hledger-lib = self.hledger-lib_1_30;
        })));
    }
  ) hledger
    hledger-web
    hledger-ui
    hledger_1_30_1
    hledger-web_1_30
    ;

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

  # Won't find it's header files without help.
  sfml-audio = appendConfigureFlag "--extra-include-dirs=${pkgs.openal}/include/AL" super.sfml-audio;

  # avoid compiling twice by providing executable as a separate output (with small closure size)
  cabal-fmt = enableSeparateBinOutput super.cabal-fmt;
  hindent = enableSeparateBinOutput super.hindent;
  releaser  = enableSeparateBinOutput super.releaser;
  eventlog2html = enableSeparateBinOutput super.eventlog2html;
  ghc-debug-brick  = enableSeparateBinOutput super.ghc-debug-brick;
  nixfmt  = enableSeparateBinOutput super.nixfmt;
  calligraphy = enableSeparateBinOutput super.calligraphy;
  niv = overrideCabal (drv: {
      buildTools = (drv.buildTools or []) ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = ''
        wrapProgram ''${!outputBin}/bin/niv --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nix ]}
      '';
    })
    (enableSeparateBinOutput (self.generateOptparseApplicativeCompletions [ "niv" ] super.niv));
  ghcid = enableSeparateBinOutput super.ghcid;
  ormolu = self.generateOptparseApplicativeCompletions [ "ormolu" ] (enableSeparateBinOutput super.ormolu);
  hnix = self.generateOptparseApplicativeCompletions [ "hnix" ] super.hnix;

  # Generate shell completion.
  cabal2nix = self.generateOptparseApplicativeCompletions [ "cabal2nix" ] super.cabal2nix;

  arbtt = overrideCabal (drv: {
    # The test suite needs the packages's executables in $PATH to succeed.
    preCheck = ''
      for i in $PWD/dist/build/*; do
        export PATH="$i:$PATH"
      done
    '';
    # One test uses timezone data
    testToolDepends = drv.testToolDepends or [] ++ [
      pkgs.tzdata
    ];
  }) super.arbtt;

  hzk = appendConfigureFlag "--extra-include-dirs=${pkgs.zookeeper_mt}/include/zookeeper" super.hzk;

  # Foreign dependency name clashes with another Haskell package.
  libarchive-conduit = super.libarchive-conduit.override { archive = pkgs.libarchive; };

  # Heist's test suite requires system pandoc
  heist = addTestToolDepend pkgs.pandoc super.heist;

  # Use Nixpkgs' double-conversion library
  double-conversion = disableCabalFlag "embedded_double_conversion" (
    addBuildDepends [ pkgs.double-conversion ] super.double-conversion
  );

  # https://github.com/NixOS/cabal2nix/issues/136 and https://github.com/NixOS/cabal2nix/issues/216
  gio = lib.pipe super.gio
    [ (disableHardening ["fortify"])
      (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools)
    ];
  glib = disableHardening ["fortify"] (addPkgconfigDepend pkgs.glib (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools super.glib));
  gtk3 = disableHardening ["fortify"] (super.gtk3.override { inherit (pkgs) gtk3; });
  gtk = lib.pipe super.gtk (
    [ (disableHardening ["fortify"])
      (addBuildTool self.buildHaskellPackages.gtk2hs-buildtools)
    ] ++
    ( if pkgs.stdenv.isDarwin then [(appendConfigureFlag "-fhave-quartz-gtk")] else [] )
  );
  gtksourceview2 = addPkgconfigDepend pkgs.gtk2 super.gtksourceview2;
  gtk-traymanager = addPkgconfigDepend pkgs.gtk3 super.gtk-traymanager;

  shelly = overrideCabal (drv: {
    # /usr/bin/env is unavailable in the sandbox
    preCheck = drv.preCheck or "" + ''
      chmod +x ./test/data/*.sh
      patchShebangs --build test/data
    '';
  }) super.shelly;

  # Add necessary reference to gtk3 package
  gi-dbusmenugtk3 = addPkgconfigDepend pkgs.gtk3 super.gi-dbusmenugtk3;

  # Doesn't declare boost dependency
  nix-serve-ng = overrideSrc {
    version = "1.0.0-unstable-2023-12-18";
    src = pkgs.fetchFromGitHub {
      repo = "nix-serve-ng";
      owner = "aristanetworks";
      rev = "21e65cb4c62b5c9e3acc11c3c5e8197248fa46a4";
      hash = "sha256-qseX+/8drgwxOb1I3LKqBYMkmyeI5d5gmHqbZccR660=";
    };
  } (addPkgconfigDepend pkgs.boost.dev super.nix-serve-ng);

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
  hjsonschema = overrideCabal (drv: { testTarget = "local"; }) super.hjsonschema;
  marmalade-upload = dontCheck super.marmalade-upload;  # http://hydra.cryp.to/build/501904/nixlog/1/raw
  mongoDB = dontCheck super.mongoDB;
  network-transport-tcp = dontCheck super.network-transport-tcp;
  network-transport-zeromq = dontCheck super.network-transport-zeromq; # https://github.com/tweag/network-transport-zeromq/issues/30
  oidc-client = dontCheck super.oidc-client;            # the spec runs openid against google.com
  persistent-migration = dontCheck super.persistent-migration; # spec requires pg_ctl binary
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

  # The curl executable is required for withApplication tests.
  warp = addTestToolDepend pkgs.curl super.warp;
  warp_3_3_30 = addTestToolDepend pkgs.curl super.warp_3_3_30;

  # Test suite requires running a database server. Testing is done upstream.
  hasql = dontCheck super.hasql;
  hasql-dynamic-statements = dontCheck super.hasql-dynamic-statements;
  hasql-interpolate = dontCheck super.hasql-interpolate;
  hasql-notifications = dontCheck super.hasql-notifications;
  hasql-pool = dontCheck super.hasql-pool;
  hasql-transaction = dontCheck super.hasql-transaction;

  # Test suite requires a running postgresql server,
  # avoid compiling twice by providing executable as a separate output (with small closure size),
  # generate shell completion
  postgrest = lib.pipe super.postgrest [
    dontCheck
    enableSeparateBinOutput
    (self.generateOptparseApplicativeCompletions [ "postgrest" ])
  ];

  # Tries to mess with extended POSIX attributes, but can't in our chroot environment.
  xattr = dontCheck super.xattr;

  # Needs access to locale data, but looks for it in the wrong place.
  scholdoc-citeproc = dontCheck super.scholdoc-citeproc;

  # Disable tests because they require a mattermost server
  mattermost-api = dontCheck super.mattermost-api;

  # Expect to find sendmail(1) in $PATH.
  mime-mail = appendConfigureFlag "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"sendmail\"" super.mime-mail;

  # Help the test suite find system timezone data.
  tz = addBuildDepends [ pkgs.tzdata ] super.tz;
  tzdata = addBuildDepends [ pkgs.tzdata ] super.tzdata;

  # https://hydra.nixos.org/build/128665302/nixlog/3
  # Disable tests because they require a running dbus session
  xmonad-dbus = dontCheck super.xmonad-dbus;

  # wxc supports wxGTX >= 3.0, but our current default version points to 2.8.
  # http://hydra.cryp.to/build/1331287/log/raw
  wxc = (addBuildDepend self.split super.wxc).override { wxGTK = pkgs.wxGTK32; };
  wxcore = super.wxcore.override { wxGTK = pkgs.wxGTK32; };

  shellify = enableSeparateBinOutput super.shellify;
  specup = enableSeparateBinOutput super.specup;

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

  # llvm-ffi needs a specific version of LLVM which we hard code here. Since we
  # can't use pkg-config (LLVM has no official .pc files), we need to pass the
  # `dev` and `lib` output in, or Cabal will have trouble finding the library.
  # Since it looks a bit neater having it in a list, we circumvent the singular
  # LLVM input here.
  llvm-ffi =
    addBuildDepends [
      pkgs.llvmPackages_16.llvm.lib
      pkgs.llvmPackages_16.llvm.dev
    ] (super.llvm-ffi.override { LLVM = null; });

  # Needs help finding LLVM.
  spaceprobe = addBuildTool self.buildHaskellPackages.llvmPackages.llvm super.spaceprobe;

  # Tries to run GUI in tests
  leksah = dontCheck (overrideCabal (drv: {
    executableSystemDepends = (drv.executableSystemDepends or []) ++ (with pkgs; [
      gnome.adwaita-icon-theme # Fix error: Icon 'window-close' not present in theme ...
      wrapGAppsHook3           # Fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
      gtk3                    # Fix error: GLib-GIO-ERROR **: Settings schema 'org.gtk.Settings.FileChooser' is not installed
    ]);
    postPatch = (drv.postPatch or "") + ''
      for f in src/IDE/Leksah.hs src/IDE/Utils/ServerConnection.hs
      do
        substituteInPlace "$f" --replace "\"leksah-server\"" "\"${self.leksah-server}/bin/leksah-server\""
      done
    '';
  }) super.leksah);

  # dyre's tests appear to be trying to directly call GHC.
  dyre = dontCheck super.dyre;

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
  libjwt-typed = addExtraLibrary pkgs.libjwt super.libjwt-typed;
  miniball = addExtraLibrary pkgs.miniball super.miniball;
  SDL-image = addExtraLibrary pkgs.SDL super.SDL-image;
  SDL-ttf = addExtraLibrary pkgs.SDL super.SDL-ttf;
  SDL-mixer = addExtraLibrary pkgs.SDL super.SDL-mixer;
  SDL-gfx = addExtraLibrary pkgs.SDL super.SDL-gfx;
  SDL-mpeg = appendConfigureFlags [
    "--extra-lib-dirs=${pkgs.smpeg}/lib"
    "--extra-include-dirs=${pkgs.smpeg.dev}/include/smpeg"
  ] super.SDL-mpeg;

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
  hscurses = addExtraLibrary pkgs.ncurses super.hscurses;

  # Looks like Avahi provides the missing library
  dnssd = super.dnssd.override { dns_sd = pkgs.avahi.override { withLibdnssdCompat = true; }; };

  # Tests execute goldplate
  goldplate = overrideCabal (drv: {
    preCheck = drv.preCheck or "" + ''
      export PATH="$PWD/dist/build/goldplate:$PATH"
    '';
  }) super.goldplate;

  # At least on 1.3.4 version on 32-bit architectures tasty requires
  # unbounded-delays via .cabal file conditions.
  tasty = overrideCabal (drv: {
    libraryHaskellDepends =
      (drv.libraryHaskellDepends or [])
      ++ lib.optionals (!(pkgs.stdenv.hostPlatform.isAarch64
                          || pkgs.stdenv.hostPlatform.isx86_64)
                        || (self.ghc.isGhcjs or false)) [
        self.unbounded-delays
      ];
  }) super.tasty;

  tasty-discover = overrideCabal (drv: {
    # Depends on itself for testing
    preBuild = ''
      export PATH="$PWD/dist/build/tasty-discover:$PATH"
    '' + (drv.preBuild or "");
  }) super.tasty-discover;

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
  ${if pkgs.stdenv.isDarwin then null else "GLUT"} = overrideCabal (drv: {
    pkg-configDepends = drv.pkg-configDepends or [] ++ [
      pkgs.freeglut
    ];
    patches = drv.patches or [] ++ [
      ./patches/GLUT.patch
    ];
    prePatch = drv.prePatch or "" + ''
      ${lib.getBin pkgs.buildPackages.dos2unix}/bin/dos2unix *.cabal
    '';
  }) super.GLUT;

  libsystemd-journal = doJailbreak (addExtraLibrary pkgs.systemd super.libsystemd-journal);

  # does not specify tests in cabal file, instead has custom runTest cabal hook,
  # so cabal2nix will not detect test dependencies.
  either-unwrap = overrideCabal (drv: {
    testHaskellDepends = (drv.testHaskellDepends or []) ++ [ self.test-framework self.test-framework-hunit ];
  }) super.either-unwrap;

  # https://github.com/haskell-fswatch/hfsnotify/issues/62
  fsnotify = dontCheck super.fsnotify;

  hs-GeoIP = super.hs-GeoIP.override { GeoIP = pkgs.geoipWithDatabase; };

  discount = super.discount.override { markdown = pkgs.discount; };

  # tests require working stack installation with all-cabal-hashes cloned in $HOME
  stackage-curator = dontCheck super.stackage-curator;

  stack = self.generateOptparseApplicativeCompletions [ "stack" ] super.stack;

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

  # Break infinite recursion cycle with OneTuple and quickcheck-instances.
  foldable1-classes-compat = dontCheck super.foldable1-classes-compat;

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

  # Not running the "example" test because it requires a binary from lsps test
  # suite which is not part of the output of lsp.
  lsp-test = overrideCabal (old: { testTarget = "tests func-test"; }) super.lsp-test;

  # the test suite attempts to run the binaries built in this package
  # through $PATH but they aren't in $PATH
  dhall-lsp-server = dontCheck super.dhall-lsp-server;

  # Expects z3 to be on path so we replace it with a hard
  #
  # The tests expect additional solvers on the path, replace the
  # available ones also with hard coded paths, and remove the missing
  # ones from the test.
  # TODO(@sternenseemann): package cvc5 and re-enable tests
  sbv = overrideCabal (drv: {
    postPatch = ''
      sed -i -e 's|"abc"|"${pkgs.abc-verifier}/bin/abc"|' Data/SBV/Provers/ABC.hs
      sed -i -e 's|"bitwuzla"|"${pkgs.bitwuzla}/bin/bitwuzla"|' Data/SBV/Provers/Bitwuzla.hs
      sed -i -e 's|"boolector"|"${pkgs.boolector}/bin/boolector"|' Data/SBV/Provers/Boolector.hs
      sed -i -e 's|"cvc4"|"${pkgs.cvc4}/bin/cvc4"|' Data/SBV/Provers/CVC4.hs
      sed -i -e 's|"cvc5"|"${pkgs.cvc5}/bin/cvc5"|' Data/SBV/Provers/CVC5.hs
      sed -i -e 's|"yices-smt2"|"${pkgs.yices}/bin/yices-smt2"|' Data/SBV/Provers/Yices.hs
      sed -i -e 's|"z3"|"${pkgs.z3}/bin/z3"|' Data/SBV/Provers/Z3.hs

      # Solvers we don't provide are removed from tests
      sed -i -e 's|, mathSAT||' SBVTestSuite/SBVConnectionTest.hs
      sed -i -e 's|, dReal||' SBVTestSuite/SBVConnectionTest.hs
    '';
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
    # Executables git-annex needs at runtime. git-annex detects these at configure
    # time and expects to be able to execute them. This means that cross-compiling
    # git-annex is not possible and strictDeps must be false (runtimeExecDeps go
    # into executableSystemDepends/buildInputs).
    runtimeExecDeps = [
      pkgs.bup
      pkgs.curl
      pkgs.git
      pkgs.gnupg
      pkgs.lsof
      pkgs.openssh
      pkgs.perl
      pkgs.rsync
      pkgs.wget
      pkgs.which
    ];
  in
  overrideCabal (drv: {
    executableSystemDepends = runtimeExecDeps;
    enableSharedExecutables = false;

    preConfigure = drv.preConfigure or "" + ''
      export HOME=$TEMPDIR
      patchShebangs .
    '';

    # git-annex ships its test suite as part of the final executable instead of
    # using a Cabal test suite.
    checkPhase = ''
      runHook preCheck

      # Setup PATH for the actual tests
      ln -sf dist/build/git-annex/git-annex git-annex
      ln -sf git-annex git-annex-shell
      PATH+=":$PWD"

      echo checkFlags: $checkFlags ''${checkFlagsArray:+"''${checkFlagsArray[@]}"}

      # Doesn't use Cabal's test mechanism
      git-annex test $checkFlags ''${checkFlagsArray:+"''${checkFlagsArray[@]}"}

      runHook postCheck
    '';

    # Use default installPhase of pkgs/stdenv/generic/setup.sh. We need to set
    # the environment variables it uses via the preInstall hook since the Haskell
    # generic builder doesn't accept them as arguments.
    preInstall = drv.preInstall or "" + ''
      installTargets="install"
      installFlagsArray+=(
        "PREFIX="
        "DESTDIR=$out"
        # Prevent Makefile from calling cabal/Setup again
        "BUILDER=:"
        # Make Haskell build dependencies available
        "GHC=${self.buildHaskellPackages.ghc.targetPrefix}ghc -global-package-db -package-db $setupPackageConfDir"
      )
    '';
    installPhase = null;

    # Ensure git-annex uses the exact same coreutils it saw at build-time.
    # This is especially important on Darwin but also in Linux environments
    # where non-GNU coreutils are used by default.
    postFixup = ''
      wrapProgram $out/bin/git-annex \
        --prefix PATH : "${pkgs.lib.makeBinPath (with pkgs; [ coreutils lsof ])}"
    '' + (drv.postFixup or "");
    buildTools = [
      pkgs.buildPackages.makeWrapper
    ] ++ (drv.buildTools or []);

    # Git annex provides a restricted login shell. Setting
    # passthru.shellPath here allows a user's login shell to be set to
    # `git-annex-shell` by making `shell = haskellPackages.git-annex`.
    # https://git-annex.branchable.com/git-annex-shell/
    passthru.shellPath = "/bin/git-annex-shell";
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
  http-download_0_2_1_0 = doDistribute (dontCheck super.http-download_0_2_1_0);
  pantry = dontCheck super.pantry;
  pantry_0_9_3_1 = dontCheck super.pantry_0_9_3_1;

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
    in
    lib.pipe (super.spago.override {
      versions = self.versions_5_0_5;
      fsnotify = self.fsnotify_0_3_0_1;
    }) [
      (overrideCabal (drv: {
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
      }))

      # Tests require network access.
      dontCheck

      # Overly strict upper bound on text
      doJailbreak

      # Generate shell completion for spago
      (self.generateOptparseApplicativeCompletions [ "spago" ])
    ];

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

  # Compiling the readme throws errors and has no purpose in nixpkgs
  aeson-gadt-th =
    disableCabalFlag "build-readme" (doJailbreak super.aeson-gadt-th);

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

  retrie = addTestToolDepends [pkgs.git pkgs.mercurial] super.retrie;
  retrie_1_2_0_0 = addTestToolDepends [pkgs.git pkgs.mercurial] super.retrie_1_2_0_0;
  retrie_1_2_1_1 = addTestToolDepends [pkgs.git pkgs.mercurial] super.retrie_1_2_1_1;


  # there are three very heavy test suites that need external repos, one requires network access
  hevm = dontCheck super.hevm;

  # hadolint enables static linking by default in the cabal file, so we have to explicitly disable it.
  # https://github.com/hadolint/hadolint/commit/e1305042c62d52c2af4d77cdce5d62f6a0a3ce7b
  hadolint = disableCabalFlag "static" super.hadolint;

  # Test suite tries to execute the build product "doctest-driver-gen", but it's not in $PATH.
  doctest-driver-gen = dontCheck super.doctest-driver-gen;

  # Tests access internet
  prune-juice = dontCheck super.prune-juice;

  citeproc = lib.pipe super.citeproc [
    enableSeparateBinOutput
    # Enable executable being built and add missing dependencies
    (enableCabalFlag "executable")
    (addBuildDepends [ self.aeson-pretty ])
    # TODO(@sternenseemann): we may want to enable that for improved performance
    # Is correctness good enough since 0.5?
    (disableCabalFlag "icu")
  ];

  # based on https://github.com/gibiansky/IHaskell/blob/aafeabef786154d81ab7d9d1882bbcd06fc8c6c4/release.nix
  ihaskell = overrideCabal (drv: {
    # ihaskell's cabal file forces building a shared executable, which we need
    # to reflect here or RPATH will contain a reference to /build/.
    enableSharedExecutables = true;
    preCheck = ''
      export HOME=$TMPDIR/home
      export PATH=$PWD/dist/build/ihaskell:$PATH
      export NIX_GHC_PACKAGE_PATH_FOR_TEST=$PWD/dist/package.conf.inplace/:$packageConfDir:
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
    (self.generateOptparseApplicativeCompletions [ "pnbackup" ] super.pinboard-notes-backup);

  # Pass the correct libarchive into the package.
  streamly-archive = super.streamly-archive.override { archive = pkgs.libarchive; };

  hlint = overrideCabal (drv: {
    postInstall = ''
      install -Dm644 data/hlint.1 -t "$out/share/man/man1"
    '' + drv.postInstall or "";
  }) super.hlint;

  taglib = overrideCabal (drv: {
    librarySystemDepends = [
      pkgs.zlib
    ] ++ (drv.librarySystemDepends or []);
  }) super.taglib;

  # random 1.2.0 has tests that indirectly depend on
  # itself causing an infinite recursion at evaluation
  # time
  random = dontCheck super.random;

  # https://github.com/Gabriella439/nix-diff/pull/74
  nix-diff = overrideCabal (drv: {
    postPatch = ''
      substituteInPlace src/Nix/Diff/Types.hs \
        --replace "{-# OPTIONS_GHC -Wno-orphans #-}" "{-# OPTIONS_GHC -Wno-orphans -fconstraint-solver-iterations=0 #-}"
      '';
  }) (doJailbreak (dontCheck super.nix-diff));

  # mockery's tests depend on hspec-discover which dependso on mockery for its tests
  mockery = dontCheck super.mockery;
  # same for logging-facade
  logging-facade = dontCheck super.logging-facade;

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
  nvfetcher = self.generateOptparseApplicativeCompletions [ "nvfetcher" ] (overrideCabal
    (drv: {
      # test needs network
      doCheck = false;
      buildTools = drv.buildTools or [ ] ++ [ pkgs.buildPackages.makeWrapper ];
      postInstall = drv.postInstall or "" + ''
        wrapProgram "$out/bin/nvfetcher" --prefix 'PATH' ':' "${
          pkgs.lib.makeBinPath [
            pkgs.nvchecker
            pkgs.nix # nix-prefetch-url
            pkgs.nix-prefetch-git
            pkgs.nix-prefetch-docker
          ]
        }"
      '';
    }) super.nvfetcher);

  rel8 = pkgs.lib.pipe super.rel8 [
    (addTestToolDepend pkgs.postgresql)
    # https://github.com/NixOS/nixpkgs/issues/198495
    (dontCheckIf (!pkgs.postgresql.doCheck))
  ];

  # Wants running postgresql database accessible over ip, so postgresqlTestHook
  # won't work (or would need to patch test suite).
  domaindriven-core = dontCheck super.domaindriven-core;

  cachix = self.generateOptparseApplicativeCompletions [ "cachix" ]
    (enableSeparateBinOutput super.cachix);

  hercules-ci-agent = super.hercules-ci-agent.override { nix = self.hercules-ci-cnix-store.passthru.nixPackage; };
  hercules-ci-cnix-expr = addTestToolDepend pkgs.git (super.hercules-ci-cnix-expr.override { nix = self.hercules-ci-cnix-store.passthru.nixPackage; });
  hercules-ci-cnix-store = overrideCabal
    (old: {
      passthru = old.passthru or { } // {
        nixPackage = pkgs.nixVersions.nix_2_19;
      };
    })
    (super.hercules-ci-cnix-store.override {
      nix = self.hercules-ci-cnix-store.passthru.nixPackage;
    });

  # the testsuite fails because of not finding tsc without some help
  aeson-typescript = overrideCabal (drv: {
    testToolDepends = drv.testToolDepends or [] ++ [ pkgs.typescript ];
    # the testsuite assumes that tsc is in the PATH if it thinks it's in
    # CI, otherwise trying to install it.
    #
    # https://github.com/codedownio/aeson-typescript/blob/ee1a87fcab8a548c69e46685ce91465a7462be89/test/Util.hs#L27-L33
    preCheck = "export CI=true";
  }) super.aeson-typescript;

  Agda = lib.pipe super.Agda [
    # Enable extra optimisations which increase build time, but also
    # later compiler performance, so we should do this for user's benefit.
    # Flag added in Agda 2.6.2
    (enableCabalFlag "optimise-heavily")
    # Enable debug printing, which worsens performance slightly but is
    # very useful.
    # Flag added in Agda 2.6.4.1, was always enabled before
    (enableCabalFlag "debug")
    # Split outputs to reduce closure size
    enableSeparateBinOutput
  ];

  # ats-format uses cli-setup in Setup.hs which is quite happy to write
  # to arbitrary files in $HOME. This doesn't either not achieve anything
  # or even fail, so we prevent it and install everything necessary ourselves.
  # See also: https://hackage.haskell.org/package/cli-setup-0.2.1.4/docs/src/Distribution.CommandLine.html#setManpathGeneric
  ats-format = self.generateOptparseApplicativeCompletions [ "atsfmt" ] (
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
  hashes = dontCheckIf (!pkgs.stdenv.hostPlatform.isx86) super.hashes;

  # Tries to access network
  aws-sns-verify = dontCheck super.aws-sns-verify;

  # Test suite requires network access
  minicurl = dontCheck super.minicurl;

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

  # Test suite wants to run main executable
  # https://github.com/fourmolu/fourmolu/issues/231
  inherit (
    let
      fourmoluTestFix = overrideCabal (drv: {
        preCheck = drv.preCheck or "" + ''
          export PATH="$PWD/dist/build/fourmolu:$PATH"
        '';
      });
    in

    {
      fourmolu = fourmoluTestFix super.fourmolu;
      fourmolu_0_14_1_0 = fourmoluTestFix super.fourmolu_0_14_1_0;
      fourmolu_0_15_0_0 = fourmoluTestFix super.fourmolu_0_15_0_0;
    })
    fourmolu
    fourmolu_0_14_1_0
    fourmolu_0_15_0_0
    ;

  # Test suite needs to execute 'disco' binary
  disco = overrideCabal (drv: {
    preCheck = drv.preCheck or "" + ''
      export PATH="$PWD/dist/build/disco:$PATH"
    '';
    testFlags = drv.testFlags or [] ++ [
      # Needs network access
      "-p" "!/oeis/"
    ];
    # disco-examples needs network access
    testTarget = "disco-tests";
  }) super.disco;

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

  # Test suite requires AWS access which requires both a network
  # connection and payment.
  aws = dontCheck super.aws;

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

  # Smoke test can't be executed in sandbox
  # https://github.com/georgefst/evdev/issues/25
  evdev = overrideCabal (drv: {
    testFlags = drv.testFlags or [] ++ [
      "-p" "!/Smoke/"
    ];
  }) super.evdev;

  # Tests assume dist-newstyle build directory is present
  cabal-hoogle = dontCheck super.cabal-hoogle;

  nfc = lib.pipe super.nfc [
    enableSeparateBinOutput
    (addBuildDepend self.base16-bytestring)
    (appendConfigureFlag "-fbuild-examples")
  ];

  # Wants to execute cabal-install to (re-)build itself
  hint = dontCheck super.hint;

  # cabal-install switched to build type simple in 3.2.0.0
  # as a result, the cabal(1) man page is no longer installed
  # automatically. Instead we need to use the `cabal man`
  # command which generates the man page on the fly and
  # install it to $out/share/man/man1 ourselves in this
  # override.
  # The commit that introduced this change:
  # https://github.com/haskell/cabal/commit/91ac075930c87712eeada4305727a4fa651726e7
  # Since cabal-install 3.8, the cabal man (without the raw) command
  # uses nroff(1) instead of man(1) for macOS/BSD compatibility. That utility
  # is not commonly installed on systems, so we add it to PATH. Closure size
  # penalty is about 10MB at the time of writing this (2022-08-20).
  cabal-install = overrideCabal (old: {
    executableToolDepends = [
      pkgs.buildPackages.makeWrapper
    ] ++ old.buildToolDepends or [];
    postInstall = old.postInstall + ''
      mkdir -p "$out/share/man/man1"
      "$out/bin/cabal" man --raw > "$out/share/man/man1/cabal.1"

      wrapProgram "$out/bin/cabal" \
        --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.groff ]}"
    '';
    hydraPlatforms = pkgs.lib.platforms.all;
    broken = false;
  }) super.cabal-install;

  tailwind = addBuildDepend
      # Overrides for tailwindcss copied from:
      # https://github.com/EmaApps/emanote/blob/master/nix/tailwind.nix
      (pkgs.nodePackages.tailwindcss.overrideAttrs (oa: {
        plugins = [
          pkgs.nodePackages."@tailwindcss/aspect-ratio"
          pkgs.nodePackages."@tailwindcss/forms"
          pkgs.nodePackages."@tailwindcss/line-clamp"
          pkgs.nodePackages."@tailwindcss/typography"
        ];
      })) super.tailwind;

  emanote = addBuildDepend pkgs.stork super.emanote;

  keid-render-basic = addBuildTool pkgs.glslang super.keid-render-basic;

  # Disable checks to break dependency loop with SCalendar
  scalendar = dontCheck super.scalendar;

  halide-haskell = super.halide-haskell.override { Halide = pkgs.halide; };

  # Sydtest has a brittle test suite that will only work with the exact
  # versions that it ships with.
  sydtest = dontCheck super.sydtest;

  # Prevent argv limit being exceeded when invoking $CC.
  inherit (lib.mapAttrs (_: overrideCabal {
    __onlyPropagateKnownPkgConfigModules = true;
    }) super)
      gi-javascriptcore
      gi-webkit2webextension
      gi-gtk_4_0_8
      gi-gdk_4_0_7
      gi-gsk
      gi-adwaita
      ;

    webkit2gtk3-javascriptcore = lib.pipe super.webkit2gtk3-javascriptcore [
      (addBuildDepend pkgs.xorg.libXtst)
      (overrideCabal { __onlyPropagateKnownPkgConfigModules = true; })
    ];

    gi-webkit2 = lib.pipe super.gi-webkit2 [
      (addBuildDepend pkgs.xorg.libXtst)
      (overrideCabal { __onlyPropagateKnownPkgConfigModules = true; })
    ];

  # Makes the mpi-hs package respect the choice of mpi implementation in Nixpkgs.
  # Also adds required test dependencies for checks to pass
  mpi-hs =
    let validMpi = [ "openmpi" "mpich" "mvapich" ];
        mpiImpl = pkgs.mpi.pname;
        disableUnused = with builtins; map disableCabalFlag (filter (n: n != mpiImpl) validMpi);
     in lib.pipe
          (super.mpi-hs_0_7_3_0.override { ompi = pkgs.mpi; })
          ( [ (addTestToolDepends [ pkgs.openssh pkgs.mpiCheckPhaseHook ]) ]
            ++ disableUnused
            ++ lib.optional (builtins.elem mpiImpl validMpi) (enableCabalFlag mpiImpl)
          );
  inherit (lib.mapAttrs (_: addTestToolDepends
    [ pkgs.openssh pkgs.mpiCheckPhaseHook ]
    ) super)
    mpi-hs-store
    mpi-hs-cereal
    mpi-hs-binary
    ;

  postgresql-libpq = overrideCabal (drv: {
    # Using use-pkg-config flag, because pg_config won't work when cross-compiling.
    configureFlags = drv.configureFlags or [] ++ [ "-fuse-pkg-config" ];
    # Move postgresql from SystemDepends to PkgconfigDepends
    libraryPkgconfigDepends = drv.librarySystemDepends;
    librarySystemDepends = [];
  }) super.postgresql-libpq;

  # Test failure is related to a GHC implementation detail of primitives and doesn't
  # cause actual problems in dependent packages, see https://github.com/lehins/pvar/issues/4
  pvar = dontCheck super.pvar;

  kmonad = enableSeparateBinOutput super.kmonad;

  xmobar = enableSeparateBinOutput super.xmobar;
}
