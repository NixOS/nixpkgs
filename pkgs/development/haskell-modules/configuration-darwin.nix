# DARWIN-SPECIFIC OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS

{ pkgs, haskellLib }:

let
  inherit (pkgs) lib darwin;
in

with haskellLib;

self: super:
(
  {

    # the tests for shell-conduit on Darwin illegitimatey assume non-GNU echo
    # see: https://github.com/psibi/shell-conduit/issues/12
    shell-conduit = dontCheck super.shell-conduit;

    conduit-extra = super.conduit-extra.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    spacecookie = super.spacecookie.overrideAttrs (_: {
      __darwinAllowLocalNetworking = true;
    });

    streaming-commons = super.streaming-commons.overrideAttrs (_: {
      __darwinAllowLocalNetworking = true;
    });

    # Hakyll's tests are broken on Darwin (3 failures); and they require util-linux
    hakyll = overrideCabal {
      testToolDepends = [ ];
      doCheck = false;
    } super.hakyll;

    double-conversion = addExtraLibrary pkgs.libcxx super.double-conversion;

    # darwin doesn't have sub-second resolution
    # https://github.com/hspec/mockery/issues/11
    mockery = overrideCabal (drv: {
      preCheck = ''
        export TRAVIS=true
      ''
      + (drv.preCheck or "");
    }) super.mockery;

    # https://github.com/ndmitchell/shake/issues/206
    shake = dontCheck super.shake;

    filecache = dontCheck super.filecache;

    # gtk/gtk3 needs to be told on Darwin to use the Quartz
    # rather than X11 backend (see eg https://github.com/gtk2hs/gtk2hs/issues/249).
    gtk3 = appendConfigureFlag "-f have-quartz-gtk" super.gtk3;
    gtk = appendConfigureFlag "-f have-quartz-gtk" super.gtk;

    # issues finding libcharset.h without libiconv in buildInputs on darwin.
    with-utf8 = addExtraLibrary pkgs.libiconv super.with-utf8;

    git-annex = overrideCabal (drv: {
      # We can't use testFlags since git-annex side steps the Cabal test mechanism
      preCheck = drv.preCheck or "" + ''
        checkFlagsArray+=(
          # The addurl test cases require security(1) to be in PATH which we can't
          # provide from nixpkgs to my (@sternenseemann) knowledge.
          "-p" "!/addurl/"
        )
      '';
    }) super.git-annex;

    # on*Finish tests rely on a threadDelay timing differential of 0.1s.
    # You'd think that's plenty of time even though immediate rescheduling
    # after threadDelay is not guaranteed. However, it appears that these
    # tests are quite flaky on Darwin.
    immortal = dontCheck super.immortal;

    # Prevents needing to add `security_tool` as a run-time dependency for
    # everything using x509-system to give access to the `security` executable.
    #
    # darwin.security_tool is broken in Mojave (#45042)
    #
    # We will use the system provided security for now.
    # Beware this WILL break in sandboxes!
    #
    # TODO(matthewbauer): If someone really needs this to work in sandboxes,
    # I think we can add a propagatedImpureHost dep here, but I’m hoping to
    # get a proper fix available soonish.
    x509-system = overrideCabal (
      drv:
      lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
        postPatch = ''
          substituteInPlace System/X509/MacOS.hs --replace-fail security /usr/bin/security
        ''
        + (drv.postPatch or "");
      }
    ) super.x509-system;
    crypton-x509-system = overrideCabal (
      drv:
      lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
        postPatch = ''
          substituteInPlace System/X509/MacOS.hs --replace-fail security /usr/bin/security
        ''
        + (drv.postPatch or "");
      }
    ) super.crypton-x509-system;
    HsOpenSSL-x509-system = overrideCabal (
      drv:
      lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
        postPatch = ''
          substituteInPlace OpenSSL/X509/SystemStore/MacOSX.hs --replace-fail security /usr/bin/security
        ''
        + (drv.postPatch or "");
      }
    ) super.HsOpenSSL-x509-system;

    # https://github.com/haskell-foundation/foundation/pull/412
    foundation = dontCheck super.foundation;

    # Test suite attempts to create illegal paths on HFS+
    # https://github.com/fpco/haskell-filesystem/issues/37
    system-fileio = dontCheck super.system-fileio;

    llvm-hs = overrideCabal (oldAttrs: {
      # One test fails on darwin.
      doCheck = false;
      # llvm-hs's Setup.hs file tries to add the lib/ directory from LLVM8 to
      # the DYLD_LIBRARY_PATH environment variable.  This messes up clang
      # when called from GHC, probably because clang is version 7, but we are
      # using LLVM8.
      preCompileBuildDriver = ''
        substituteInPlace Setup.hs --replace-fail "addToLdLibraryPath libDir" "pure ()"
      ''
      + (oldAttrs.preCompileBuildDriver or "");
    }) super.llvm-hs;

    sym = markBroken super.sym;

    yesod-core = super.yesod-core.overrideAttrs (drv: {
      # Allow access to local networking when the Darwin sandbox is enabled, so yesod-core can
      # run tests that access localhost.
      __darwinAllowLocalNetworking = true;
    });

    hidapi = super.hidapi.override { systemd = null; };

    # Ensure the necessary frameworks are propagatedBuildInputs on darwin
    OpenGLRaw = overrideCabal (drv: {
      librarySystemDepends = [ ];
      libraryHaskellDepends = drv.libraryHaskellDepends;
      preConfigure = ''
        frameworkPaths=($(for i in $nativeBuildInputs; do if [ -d "$i"/Library/Frameworks ]; then echo "-F$i/Library/Frameworks"; fi done))
        frameworkPaths=$(IFS=, ; echo "''${frameworkPaths[@]}")
        configureFlags+=$(if [ -n "$frameworkPaths" ]; then echo -n "--ghc-options=-optl=$frameworkPaths"; fi)
      ''
      + (drv.preConfigure or "");
    }) super.OpenGLRaw;
    bindings-GLFW = overrideCabal (drv: {
      librarySystemDepends = [ ];
    }) super.bindings-GLFW;

    # cabal2nix likes to generate dependencies on hinotify when hfsevents is
    # really required on darwin: https://github.com/NixOS/cabal2nix/issues/146.
    hinotify = self.hfsevents;

    # FSEvents API is very buggy and tests are unreliable. See
    # http://openradar.appspot.com/10207999 and similar issues.
    fsnotify = dontCheck super.fsnotify;

    HTF = overrideCabal (drv: {
      # GNU find is not prefixed in stdenv
      postPatch = ''
        substituteInPlace scripts/local-htfpp --replace-fail "find=gfind" "find=find"
      ''
      + (drv.postPatch or "");
    }) super.HTF;

    # conditional dependency via a cabal flag
    cas-store = overrideCabal (drv: {
      libraryHaskellDepends = [
        self.kqueue
      ]
      ++ (drv.libraryHaskellDepends or [ ]);
    }) super.cas-store;

    # We are lacking pure pgrep at the moment for tests to work
    tmp-postgres = dontCheck super.tmp-postgres;

    # On darwin librt doesn't exist and will fail to link against,
    # however linking against it is also not necessary there
    GLHUI = overrideCabal (drv: {
      postPatch = ''
        substituteInPlace GLHUI.cabal --replace-fail " rt" ""
      ''
      + (drv.postPatch or "");
    }) super.GLHUI;

    SDL-image = overrideCabal (drv: {
      # Prevent darwin-specific configuration code path being taken
      # which doesn't work with nixpkgs' SDL libraries
      postPatch = ''
        substituteInPlace configure --replace-fail xDarwin noDarwinSpecialCasing
      ''
      + (drv.postPatch or "");
      patches = [
        # Work around SDL_main.h redefining main to SDL_main
        ./patches/SDL-image-darwin-hsc.patch
      ];
    }) super.SDL-image;

    # Prevent darwin-specific configuration code path being taken which
    # doesn't work with nixpkgs' SDL libraries
    SDL-mixer = overrideCabal (drv: {
      postPatch = ''
        substituteInPlace configure --replace-fail xDarwin noDarwinSpecialCasing
      ''
      + (drv.postPatch or "");
    }) super.SDL-mixer;

    # Work around SDL_main.h redefining main to SDL_main
    SDL-ttf = appendPatch ./patches/SDL-ttf-darwin-hsc.patch super.SDL-ttf;

    # Disable a bunch of test suites that fail because of darwin's case insensitive
    # file system: When a test suite has a test suite file that has the same name
    # as a module in scope, but in different case (e. g. hedgehog.hs and Hedgehog
    # in scope), GHC will complain that the file name and module name differ (in
    # the example hedgehog.hs would be Main).
    # These failures can easily be fixed by upstream by renaming files, so we
    # should create issues for them.
    # https://github.com/typeclasses/aws-cloudfront-signed-cookies/issues/2
    aws-cloudfront-signed-cookies = dontCheck super.aws-cloudfront-signed-cookies;

    # https://github.com/acid-state/acid-state/issues/133
    acid-state = dontCheck super.acid-state;

    # Otherwise impure gcc is used, which is Apple's weird wrapper
    c2hsc = addTestToolDepends [ pkgs.gcc ] super.c2hsc;

    http2 = super.http2.overrideAttrs (drv: {
      # Allow access to local networking when the Darwin sandbox is enabled, so http2 can run tests
      # that access localhost.
      __darwinAllowLocalNetworking = true;
    });

    # https://hydra.nixos.org/build/230964714/nixlog/1
    inline-c-cpp = appendPatch (pkgs.fetchpatch {
      url = "https://github.com/fpco/inline-c/commit/e8dc553b13bb847409fdced649a6a863323cff8a.patch";
      name = "revert-use-system-cxx-std-lib.patch";
      sha256 = "sha256-ql1/+8bvmWexyCdFR0VS4M4cY2lD0Px/9dHYLqlKyNA=";
      revert = true;
      stripLen = 1;
    }) super.inline-c-cpp;

    # Tests fail on macOS https://github.com/mrkkrp/zip/issues/112
    zip = dontCheck super.zip;

    http-streams = super.http-streams.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    io-streams = super.io-streams.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    io-streams-haproxy = super.io-streams-haproxy.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    openssl-streams = super.openssl-streams.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    snap = super.snap.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    warp = super.warp.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    ghcjs-dom-hello = overrideCabal (drv: {
      libraryHaskellDepends = with self; [
        jsaddle
        jsaddle-warp
      ];
      executableHaskellDepends = with self; [
        ghcjs-dom
        jsaddle-wkwebview
      ];
    }) super.ghcjs-dom-hello;

    jsaddle-hello = overrideCabal (drv: {
      libraryHaskellDepends = with self; [
        jsaddle
        lens
      ];
      executableHaskellDepends = with self; [
        jsaddle-warp
        jsaddle-wkwebview
      ];
    }) super.jsaddle-hello;

    jsaddle-wkwebview = overrideCabal (drv: {
      libraryHaskellDepends = with self; [
        aeson
        data-default
        jsaddle
      ]; # cabal2nix doesn't add darwin-only deps
    }) super.jsaddle-wkwebview;

    # cabal2nix doesn't add darwin-only deps
    reflex-dom = addBuildDepend self.jsaddle-wkwebview (
      super.reflex-dom.override (drv: {
        jsaddle-webkit2gtk = null;
      })
    );

    # Remove a problematic assert, the length is sometimes 1 instead of 2 on darwin
    di-core = overrideCabal (drv: {
      preConfigure = ''
        substituteInPlace test/Main.hs --replace-fail \
          "2 @=? List.length (List.nub (List.sort (map Di.log_time logs)))" ""
      '';
    }) super.di-core;

    # Require /usr/bin/security which breaks sandbox
    http-reverse-proxy = dontCheck super.http-reverse-proxy;
    servant-auth-server = dontCheck super.servant-auth-server;

    sysinfo = dontCheck super.sysinfo;

    network = super.network.overrideAttrs (drv: {
      __darwinAllowLocalNetworking = true;
    });

    # 2025-08-04: Some RNG tests fail only on Darwin
    botan-low = overrideCabal (drv: {
      testFlags =
        drv.testFlags or [ ]
        ++ (lib.concatMap (x: [ "--skip" ] ++ [ x ]) [
          # botan-low-rng-tests
          "/rdrand/rngInit/"
          "/rdrand/rngGet/"
          "/rdrand/rngReseed/"
          "/rdrand/rngReseedFromRNGCtx/"
          "/rdrand/rngAddEntropy/"
        ]);
    }) super.botan-low;
  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch64 {
    # aarch64-darwin

    # Workarounds for justStaticExecutables on aarch64-darwin. Since dead code
    # elimination barely works on aarch64-darwin, any package that has a
    # dependency that uses a Paths_ module will incur a reference on GHC, making
    # it fail with disallowGhcReference (which is set by justStaticExecutables).
    #
    # To address this, you can either manually remove the references causing this
    # after verifying they are indeed erroneous (e.g. cabal2nix) or just disable
    # the check, sticking with the status quo. Ideally there'll be zero cases of
    # the latter in the future!
    cabal2nix = overrideCabal (old: {
      postInstall = ''
        remove-references-to -t ${self.hpack} "''${!outputBin}/bin/cabal2nix"
        # Note: The `data` output is needed at runtime.
        remove-references-to -t ${self.distribution-nixpkgs.out} "''${!outputBin}/bin/hackage2nix"

        ${old.postInstall or ""}
      '';
    }) super.cabal2nix;
    cabal2nix-unstable = overrideCabal (old: {
      postInstall = ''
        remove-references-to -t ${self.hpack} "''${!outputBin}/bin/cabal2nix"
        # Note: The `data` output is needed at runtime.
        remove-references-to -t ${self.distribution-nixpkgs-unstable.out} "''${!outputBin}/bin/hackage2nix"

        ${old.postInstall or ""}
      '';
    }) super.cabal2nix-unstable;
    happy = overrideCabal (old: {
      postInstall = ''
        remove-references-to -t ${lib.getLib self.happy-lib} "''${!outputBin}/bin/happy"

        ${old.postInstall or ""}
      '';
    }) super.happy;

    # https://github.com/fpco/unliftio/issues/87
    unliftio = dontCheck super.unliftio;
    # This is the same issue as above; the rio tests call functions in unliftio
    # that have issues as tracked in the GitHub issue above. Once the unliftio
    # tests are fixed, we can remove this as well.
    #
    # We skip just the problematic tests by replacing 'it' with 'xit'.
    rio = overrideCabal (drv: {
      preConfigure = ''
        sed -i 's/\bit /xit /g' test/RIO/FileSpec.hs
      '';
    }) super.rio;

    # Don't use homebrew icu on macOS
    # https://github.com/NixOS/nixpkgs/issues/462046
    text-icu = disableCabalFlag "homebrew" super.text-icu;

    # https://github.com/haskell-crypto/cryptonite/issues/360
    cryptonite = appendPatch ./patches/cryptonite-remove-argon2.patch super.cryptonite;

    # Build segfaults unless `fixity-th` is disabled.
    # https://github.com/tweag/ormolu/issues/927
    ormolu = overrideCabal (drv: {
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.file-embed ];
    }) (disableCabalFlag "fixity-th" super.ormolu);
    fourmolu = overrideCabal (drv: {
      libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.file-embed ];
    }) (disableCabalFlag "fixity-th" super.fourmolu);

    Agda = lib.pipe super.Agda [
      # https://github.com/NixOS/nixpkgs/issues/149692
      (disableCabalFlag "optimise-heavily")
      # https://github.com/agda/agda/issues/8016
      (appendConfigureFlag "--ghc-option=-Wwarn=deprecations")
    ];

    # https://github.com/NixOS/nixpkgs/issues/198495
    eventsourcing-postgresql = dontCheck super.eventsourcing-postgresql;
    gargoyle-postgresql-connect = dontCheck super.gargoyle-postgresql-connect;
    hs-opentelemetry-instrumentation-postgresql-simple = dontCheck super.hs-opentelemetry-instrumentation-postgresql-simple;
    moto-postgresql = dontCheck super.moto-postgresql;
    persistent-postgresql = dontCheck super.persistent-postgresql;
    pipes-postgresql-simple = dontCheck super.pipes-postgresql-simple;
    postgresql-connector = dontCheck super.postgresql-connector;
    postgresql-migration = dontCheck super.postgresql-migration;
    postgresql-schema = dontCheck super.postgresql-schema;
    postgresql-simple = dontCheck super.postgresql-simple;
    postgresql-simple-interpolate = dontCheck super.postgresql-simple-interpolate;
    postgresql-simple-migration = dontCheck super.postgresql-simple-migration;
    postgresql-simple-url = dontCheck super.postgresql-simple-url;
    postgresql-transactional = dontCheck super.postgresql-transactional;
    postgrest = dontCheck super.postgrest;
    rivet-adaptor-postgresql = dontCheck super.rivet-adaptor-postgresql;
    tmp-proc-postgres = dontCheck super.tmp-proc-postgres;

  }
  // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
    # x86_64-darwin

    # tests appear to be failing to link or something:
    # https://hydra.nixos.org/build/174540882/nixlog/9
    regex-rure = dontCheck super.regex-rure;
    # same
    # https://hydra.nixos.org/build/174540882/nixlog/9
    jacinda = dontCheck super.jacinda;

    # Greater floating point error on x86_64-darwin (!) for some reason
    # https://github.com/ekmett/ad/issues/113
    ad = overrideCabal (drv: {
      testFlags = drv.testFlags or [ ] ++ [
        "-p"
        "!/issue-108/"
      ];
    }) super.ad;
  }
)
