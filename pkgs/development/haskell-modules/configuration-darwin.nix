# DARWIN-SPECIFIC OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS

{ pkgs, haskellLib }:

let
  inherit (pkgs) lib darwin;
in

with haskellLib;

self: super: ({

  # the tests for shell-conduit on Darwin illegitimatey assume non-GNU echo
  # see: https://github.com/psibi/shell-conduit/issues/12
  shell-conduit = dontCheck super.shell-conduit;

  conduit-extra = super.conduit-extra.overrideAttrs (drv: {
    __darwinAllowLocalNetworking = true;
  });

  streaming-commons = super.streaming-commons.overrideAttrs (_: {
    __darwinAllowLocalNetworking = true;
  });

  halive = addBuildDepend darwin.apple_sdk.frameworks.AppKit super.halive;

  # Hakyll's tests are broken on Darwin (3 failures); and they require util-linux
  hakyll = overrideCabal {
    testToolDepends = [];
    doCheck = false;
  } super.hakyll;

  barbly = addBuildDepend darwin.apple_sdk.frameworks.AppKit super.barbly;

  double-conversion = addExtraLibrary pkgs.libcxx super.double-conversion;

  streamly = addBuildDepend darwin.apple_sdk.frameworks.Cocoa super.streamly;

  apecs-physics = addPkgconfigDepends [
    darwin.apple_sdk.frameworks.ApplicationServices
  ] super.apecs-physics;

  # Framework deps are hidden behind a flag
  hmidi = addExtraLibraries [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreMIDI
  ] super.hmidi;

  # "erf table" test fails on Darwin
  # https://github.com/bos/math-functions/issues/63
  math-functions = dontCheck super.math-functions;

  # darwin doesn't have sub-second resolution
  # https://github.com/hspec/mockery/issues/11
  mockery = overrideCabal (drv: {
    preCheck = ''
      export TRAVIS=true
    '' + (drv.preCheck or "");
  }) super.mockery;

  # https://github.com/ndmitchell/shake/issues/206
  shake = dontCheck super.shake;

  filecache = dontCheck super.filecache;

  # gtk/gtk3 needs to be told on Darwin to use the Quartz
  # rather than X11 backend (see eg https://github.com/gtk2hs/gtk2hs/issues/249).
  gtk3 = appendConfigureFlag "-f have-quartz-gtk" super.gtk3;
  gtk = appendConfigureFlag "-f have-quartz-gtk" super.gtk;

  OpenAL = addExtraLibrary darwin.apple_sdk.frameworks.OpenAL super.OpenAL;

  al = overrideCabal (drv: {
    libraryFrameworkDepends = [
      darwin.apple_sdk.frameworks.OpenAL
    ] ++ (drv.libraryFrameworkDepends or []);
  }) super.al;

  proteaaudio = addExtraLibrary darwin.apple_sdk.frameworks.AudioToolbox super.proteaaudio;

  # the system-fileio tests use canonicalizePath, which fails in the sandbox
  system-fileio = dontCheck super.system-fileio;

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
  x509-system = overrideCabal (drv:
    lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
      postPatch = ''
        substituteInPlace System/X509/MacOS.hs --replace security /usr/bin/security
      '' + (drv.postPatch or "");
    }) super.x509-system;
  crypton-x509-system = overrideCabal (drv:
    lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
      postPatch = ''
        substituteInPlace System/X509/MacOS.hs --replace security /usr/bin/security
      '' + (drv.postPatch or "");
    }) super.crypton-x509-system;

  # https://github.com/haskell-foundation/foundation/pull/412
  foundation = dontCheck super.foundation;

  llvm-hs = overrideCabal (oldAttrs: {
    # One test fails on darwin.
    doCheck = false;
    # llvm-hs's Setup.hs file tries to add the lib/ directory from LLVM8 to
    # the DYLD_LIBRARY_PATH environment variable.  This messes up clang
    # when called from GHC, probably because clang is version 7, but we are
    # using LLVM8.
    preCompileBuildDriver = ''
      substituteInPlace Setup.hs --replace "addToLdLibraryPath libDir" "pure ()"
    '' + (oldAttrs.preCompileBuildDriver or "");
  }) super.llvm-hs;

  yesod-bin = addBuildDepend darwin.apple_sdk.frameworks.Cocoa super.yesod-bin;

  yesod-core = super.yesod-core.overrideAttrs (drv: {
    # Allow access to local networking when the Darwin sandbox is enabled, so yesod-core can
    # run tests that access localhost.
    __darwinAllowLocalNetworking = true;
  });

  hidapi =
    addExtraLibraries [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.CoreFoundation
    ]
    (super.hidapi.override { systemd = null; });

  hmatrix = addBuildDepend darwin.apple_sdk.frameworks.Accelerate super.hmatrix;

  blas-hs = overrideCabal (drv: {
    libraryFrameworkDepends = [
      darwin.apple_sdk.frameworks.Accelerate
    ] ++ (drv.libraryFrameworkDepends or []);
  }) super.blas-hs;

  # Ensure the necessary frameworks are propagatedBuildInputs on darwin
  OpenGLRaw = overrideCabal (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenGL
    ];
    preConfigure = ''
      frameworkPaths=($(for i in $nativeBuildInputs; do if [ -d "$i"/Library/Frameworks ]; then echo "-F$i/Library/Frameworks"; fi done))
      frameworkPaths=$(IFS=, ; echo "''${frameworkPaths[@]}")
      configureFlags+=$(if [ -n "$frameworkPaths" ]; then echo -n "--ghc-options=-optl=$frameworkPaths"; fi)
    '' + (drv.preConfigure or "");
  }) super.OpenGLRaw;
  GLURaw = overrideCabal (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenGL
    ];
  }) super.GLURaw;
  bindings-GLFW = overrideCabal (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.AGL
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.OpenGL
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Kernel
      darwin.apple_sdk.frameworks.CoreVideo
      darwin.CF
    ];
  }) super.bindings-GLFW;
  OpenCL = overrideCabal (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenCL
    ];
  }) super.OpenCL;

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is
  # really required on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = self.hfsevents;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  fsnotify = addBuildDepend darwin.apple_sdk.frameworks.Cocoa
    (dontCheck super.fsnotify);

  FractalArt = overrideCabal (drv: {
    librarySystemDepends = [
      darwin.libobjc
      darwin.apple_sdk.frameworks.AppKit
    ] ++ (drv.librarySystemDepends or []);
  }) super.FractalArt;

  arbtt = overrideCabal (drv: {
    librarySystemDepends = [
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Carbon
      darwin.apple_sdk.frameworks.IOKit
    ] ++ (drv.librarySystemDepends or []);
  }) super.arbtt;

  HTF = overrideCabal (drv: {
    # GNU find is not prefixed in stdenv
    postPatch = ''
      substituteInPlace scripts/local-htfpp --replace "find=gfind" "find=find"
    '' + (drv.postPatch or "");
  }) super.HTF;

  # conditional dependency via a cabal flag
  cas-store = overrideCabal (drv: {
    libraryHaskellDepends = [
      self.kqueue
    ] ++ (drv.libraryHaskellDepends or []);
  }) super.cas-store;

  # We are lacking pure pgrep at the moment for tests to work
  tmp-postgres = dontCheck super.tmp-postgres;

  # On darwin librt doesn't exist and will fail to link against,
  # however linking against it is also not necessary there
  GLHUI = overrideCabal (drv: {
    postPatch = ''
      substituteInPlace GLHUI.cabal --replace " rt" ""
    '' + (drv.postPatch or "");
  }) super.GLHUI;

  SDL-image = overrideCabal (drv: {
    # Prevent darwin-specific configuration code path being taken
    # which doesn't work with nixpkgs' SDL libraries
    postPatch = ''
      substituteInPlace configure --replace xDarwin noDarwinSpecialCasing
    '' + (drv.postPatch or "");
    patches = [
      # Work around SDL_main.h redefining main to SDL_main
      ./patches/SDL-image-darwin-hsc.patch
    ];
  }) super.SDL-image;

  # Prevent darwin-specific configuration code path being taken which
  # doesn't work with nixpkgs' SDL libraries
  SDL-mixer = overrideCabal (drv: {
    postPatch = ''
      substituteInPlace configure --replace xDarwin noDarwinSpecialCasing
    '' + (drv.postPatch or "");
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

  http-client-tls = overrideCabal (drv: {
    postPatch = ''
      # This comment has been inserted, so the derivation hash changes, forcing
      # a rebuild of this derivation which has succeeded to build on Hydra before,
      # but apparently been corrupted, causing reverse dependencies to fail.
      #
      # This workaround can be removed upon the next darwin stdenv rebuild,
      # presumably https://github.com/NixOS/nixpkgs/pull/152850 or the next
      # full haskellPackages rebuild.
    '' + drv.postPatch or "";
  }) super.http-client-tls;

  http2 = super.http2.overrideAttrs (drv: {
    # Allow access to local networking when the Darwin sandbox is enabled, so http2 can run tests
    # that access localhost.
    __darwinAllowLocalNetworking = true;
  });

  foldl = overrideCabal (drv: {
    postPatch = ''
      # This comment has been inserted, so the derivation hash changes, forcing
      # a rebuild of this derivation which has succeeded to build on Hydra before,
      # but apparently been corrupted, causing reverse dependencies to fail.
      #
      # This workaround can be removed upon the next darwin stdenv rebuild,
      # presumably https://github.com/NixOS/nixpkgs/pull/152850 or the next
      # full haskellPackages rebuild.
    '' + drv.postPatch or "";
  }) super.foldl;

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

  jsaddle-wkwebview = overrideCabal (drv: {
    libraryFrameworkDepends = with pkgs.buildPackages.darwin.apple_sdk.frameworks; [ Cocoa WebKit ];
    libraryHaskellDepends = with self; [ aeson data-default jsaddle ]; # cabal2nix doesn't add darwin-only deps
  }) super.jsaddle-wkwebview;
  reflex-dom = overrideCabal (drv: {
    libraryHaskellDepends = with self; [ base bytestring jsaddle-wkwebview reflex reflex-dom-core text ]; # cabal2nix doesn't add darwin-only deps
  }) super.reflex-dom;

  # Remove a problematic assert, the length is sometimes 1 instead of 2 on darwin
  di-core = overrideCabal (drv: {
    preConfigure = ''
      substituteInPlace test/Main.hs --replace \
        "2 @=? List.length (List.nub (List.sort (map Di.log_time logs)))" ""
    '';
  }) super.di-core;

} // lib.optionalAttrs pkgs.stdenv.isAarch64 {  # aarch64-darwin

  # Workarounds for justStaticExecutables on aarch64-darwin. Since dead code
  # elimination barely works on aarch64-darwin, any package that has a
  # dependency that uses a Paths_ module will incur a reference on GHC, making
  # it fail with disallowGhcReference (which is set by justStaticExecutables).
  #
  # To address this, you can either manually remove the references causing this
  # after verifying they are indeed erroneous (e.g. cabal2nix) or just disable
  # the check, sticking with the status quo. Ideally there'll be zero cases of
  # the latter in the future!
  inherit (
    lib.mapAttrs (_: overrideCabal (old: {
      postInstall = ''
        remove-references-to -t ${self.hpack} "$out/bin/cabal2nix"
        # Note: The `data` output is needed at runtime.
        remove-references-to -t ${self.distribution-nixpkgs.out} "$out/bin/hackage2nix"

        ${old.postInstall or ""}
      '';
    })) super
  ) cabal2nix cabal2nix-unstable;

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

  # https://github.com/NixOS/nixpkgs/issues/149692
  Agda = disableCabalFlag "optimise-heavily" super.Agda;

} // lib.optionalAttrs pkgs.stdenv.isx86_64 {  # x86_64-darwin

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
      "-p" "!/issue-108/"
    ];
  }) super.ad;
})
