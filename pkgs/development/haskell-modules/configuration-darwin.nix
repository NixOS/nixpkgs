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

  halive = addBuildDepend super.halive darwin.apple_sdk.frameworks.AppKit;

  # Hakyll's tests are broken on Darwin (3 failures); and they require util-linux
  hakyll = overrideCabal super.hakyll {
    testToolDepends = [];
    doCheck = false;
  };

  barbly = addBuildDepend super.barbly darwin.apple_sdk.frameworks.AppKit;

  double-conversion = addExtraLibrary super.double-conversion pkgs.libcxx;

  apecs-physics = addPkgconfigDepends super.apecs-physics [
    darwin.apple_sdk.frameworks.ApplicationServices
  ];

  # "erf table" test fails on Darwin
  # https://github.com/bos/math-functions/issues/63
  math-functions = dontCheck super.math-functions;

  # darwin doesn't have sub-second resolution
  # https://github.com/hspec/mockery/issues/11
  mockery = overrideCabal super.mockery (drv: {
    preCheck = ''
      export TRAVIS=true
    '' + (drv.preCheck or "");
  });

  # https://github.com/ndmitchell/shake/issues/206
  shake = dontCheck super.shake;

  filecache = dontCheck super.filecache;

  # gtk/gtk3 needs to be told on Darwin to use the Quartz
  # rather than X11 backend (see eg https://github.com/gtk2hs/gtk2hs/issues/249).
  gtk3 = appendConfigureFlag super.gtk3 "-f have-quartz-gtk";
  gtk = appendConfigureFlag super.gtk "-f have-quartz-gtk";

  OpenAL = addExtraLibrary super.OpenAL darwin.apple_sdk.frameworks.OpenAL;

  al = overrideCabal super.al (drv: {
    libraryFrameworkDepends = [
      darwin.apple_sdk.frameworks.OpenAL
    ] ++ (drv.libraryFrameworkDepends or []);
  });

  proteaaudio = addExtraLibrary super.proteaaudio darwin.apple_sdk.frameworks.AudioToolbox;

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
  x509-system = overrideCabal super.x509-system (drv:
    lib.optionalAttrs (!pkgs.stdenv.cc.nativeLibc) {
      postPatch = ''
        substituteInPlace System/X509/MacOS.hs --replace security /usr/bin/security
      '' + (drv.postPatch or "");
    });

  # https://github.com/haskell-foundation/foundation/pull/412
  foundation = dontCheck super.foundation;

  llvm-hs = overrideCabal super.llvm-hs (oldAttrs: {
    # One test fails on darwin.
    doCheck = false;
    # llvm-hs's Setup.hs file tries to add the lib/ directory from LLVM8 to
    # the DYLD_LIBRARY_PATH environment variable.  This messes up clang
    # when called from GHC, probably because clang is version 7, but we are
    # using LLVM8.
    preCompileBuildDriver = ''
      substituteInPlace Setup.hs --replace "addToLdLibraryPath libDir" "pure ()"
    '' + (oldAttrs.preCompileBuildDriver or "");
  });

  yesod-bin = addBuildDepend super.yesod-bin darwin.apple_sdk.frameworks.Cocoa;

  hmatrix = addBuildDepend super.hmatrix darwin.apple_sdk.frameworks.Accelerate;

  blas-hs = overrideCabal super.blas-hs (drv: {
    libraryFrameworkDepends = [
      darwin.apple_sdk.frameworks.Accelerate
    ] ++ (drv.libraryFrameworkDepends or []);
  });

  # Ensure the necessary frameworks are propagatedBuildInputs on darwin
  OpenGLRaw = overrideCabal super.OpenGLRaw (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenGL
    ];
    preConfigure = ''
      frameworkPaths=($(for i in $nativeBuildInputs; do if [ -d "$i"/Library/Frameworks ]; then echo "-F$i/Library/Frameworks"; fi done))
      frameworkPaths=$(IFS=, ; echo "''${frameworkPaths[@]}")
      configureFlags+=$(if [ -n "$frameworkPaths" ]; then echo -n "--ghc-options=-optl=$frameworkPaths"; fi)
    '' + (drv.preConfigure or "");
  });
  GLURaw = overrideCabal super.GLURaw (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenGL
    ];
  });
  bindings-GLFW = overrideCabal super.bindings-GLFW (drv: {
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
  });
  OpenCL = overrideCabal super.OpenCL (drv: {
    librarySystemDepends = [];
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [
      darwin.apple_sdk.frameworks.OpenCL
    ];
  });

  # cabal2nix likes to generate dependencies on hinotify when hfsevents is
  # really required on darwin: https://github.com/NixOS/cabal2nix/issues/146.
  hinotify = self.hfsevents;

  # FSEvents API is very buggy and tests are unreliable. See
  # http://openradar.appspot.com/10207999 and similar issues.
  fsnotify = addBuildDepend (dontCheck super.fsnotify)
    darwin.apple_sdk.frameworks.Cocoa;

  FractalArt = overrideCabal super.FractalArt (drv: {
    librarySystemDepends = [
      darwin.libobjc
      darwin.apple_sdk.frameworks.AppKit
    ] ++ (drv.librarySystemDepends or []);
  });

  arbtt = overrideCabal super.arbtt (drv: {
    librarySystemDepends = [
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Carbon
      darwin.apple_sdk.frameworks.IOKit
    ] ++ (drv.librarySystemDepends or []);
  });

  HTF = overrideCabal super.HTF (drv: {
    # GNU find is not prefixed in stdenv
    postPatch = ''
      substituteInPlace scripts/local-htfpp --replace "find=gfind" "find=find"
    '' + (drv.postPatch or "");
  });

  # conditional dependency via a cabal flag
  cas-store = overrideCabal super.cas-store (drv: {
    libraryHaskellDepends = [
      self.kqueue
    ] ++ (drv.libraryHaskellDepends or []);
  });

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

  # We are lacking pure pgrep at the moment for tests to work
  tmp-postgres = dontCheck super.tmp-postgres;

  # On darwin librt doesn't exist and will fail to link against,
  # however linking against it is also not necessary there
  GLHUI = overrideCabal super.GLHUI (drv: {
    postPatch = ''
      substituteInPlace GLHUI.cabal --replace " rt" ""
    '' + (drv.postPatch or "");
  });

  SDL-image = overrideCabal super.SDL-image (drv: {
    # Prevent darwin-specific configuration code path being taken
    # which doesn't work with nixpkgs' SDL libraries
    postPatch = ''
      substituteInPlace configure --replace xDarwin noDarwinSpecialCasing
    '' + (drv.postPatch or "");
    patches = [
      # Work around SDL_main.h redefining main to SDL_main
      ./patches/SDL-image-darwin-hsc.patch
    ];
  });

  # Prevent darwin-specific configuration code path being taken which
  # doesn't work with nixpkgs' SDL libraries
  SDL-mixer = overrideCabal super.SDL-mixer (drv: {
    postPatch = ''
      substituteInPlace configure --replace xDarwin noDarwinSpecialCasing
    '' + (drv.postPatch or "");
  });

  # Work around SDL_main.h redefining main to SDL_main
  SDL-ttf = appendPatch super.SDL-ttf ./patches/SDL-ttf-darwin-hsc.patch;

  # Disable a bunch of test suites that fail because of darwin's case insensitive
  # file system: When a test suite has a test suite file that has the same name
  # as a module in scope, but in different case (e. g. hedgehog.hs and Hedgehog
  # in scope), GHC will complain that the file name and module name differ (in
  # the example hedgehog.hs would be Main).
  # These failures can easily be fixed by upstream by renaming files, so we
  # should create issues for them.
  # https://github.com/typeclasses/aws-cloudfront-signed-cookies/issues/2
  aws-cloudfront-signed-cookies = dontCheck super.aws-cloudfront-signed-cookies;
  # https://github.com/typeclasses/assoc-list/issues/2
  assoc-list = dontCheck super.assoc-list;
  assoc-listlike = dontCheck super.assoc-listlike;
  # https://github.com/typeclasses/dsv/issues/1
  dsv = dontCheck super.dsv;

  # https://github.com/acid-state/acid-state/issues/133
  acid-state = dontCheck super.acid-state;

  # Otherwise impure gcc is used, which is Apple's weird wrapper
  c2hsc = addTestToolDepends super.c2hsc [ pkgs.gcc ];

} // lib.optionalAttrs pkgs.stdenv.isAarch64 {  # aarch64-darwin

  # https://github.com/fpco/unliftio/issues/87
  unliftio = dontCheck super.unliftio;

  # https://github.com/fpco/inline-c/issues/127
  inline-c-cpp = dontCheck super.inline-c-cpp;
})
