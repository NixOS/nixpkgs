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

  # 2021-05-25: Tests fail and I have no way to debug them.
  hls-class-plugin = dontCheck super.hls-class-plugin;
  hls-brittany-plugin = dontCheck super.hls-brittany-plugin;
  hls-fourmolu-plugin = dontCheck super.hls-fourmolu-plugin;
  hls-module-name-plugin = dontCheck super.hls-module-name-plugin;
  hls-splice-plugin = dontCheck super.hls-splice-plugin;
  hls-ormolu-plugin = dontCheck super.hls-ormolu-plugin;
  hls-pragmas-plugin = dontCheck super.hls-pragmas-plugin;
  hls-haddock-comments-plugin = dontCheck super.hls-haddock-comments-plugin;
  hls-floskell-plugin = dontCheck super.hls-floskell-plugin;
  hls-call-hierarchy-plugin = dontCheck super.hls-call-hierarchy-plugin;
  # 2022-05-05: Tests fail and I have no way to debug them.
  hls-rename-plugin = dontCheck super.hls-rename-plugin;

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

} // lib.optionalAttrs pkgs.stdenv.isAarch64 {  # aarch64-darwin

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
  Agda = removeConfigureFlag "-foptimise-heavily" super.Agda;

  heystone = addBuildTool pkgs.fixDarwinDylibNames super.heystone;

} // lib.optionalAttrs pkgs.stdenv.isx86_64 {  # x86_64-darwin

  # tests appear to be failing to link or something:
  # https://hydra.nixos.org/build/174540882/nixlog/9
  regex-rure = dontCheck super.regex-rure;
  # same
  # https://hydra.nixos.org/build/174540882/nixlog/9
  jacinda = dontCheck super.jacinda;
})
