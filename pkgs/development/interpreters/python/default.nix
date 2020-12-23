{ pkgs }:

with pkgs;

(let

  # Common passthru for all Python interpreters.
  passthruFun =
    { implementation
    , libPrefix
    , executable
    , sourceVersion
    , pythonVersion
    , packageOverrides
    , sitePackages
    , hasDistutilsCxxPatch
    , pythonOnBuildForBuild
    , pythonOnBuildForHost
    , pythonOnBuildForTarget
    , pythonOnHostForHost
    , pythonOnTargetForTarget
    , self # is pythonOnHostForTarget
    }: let
      pythonPackages = callPackage
        ({ pkgs, stdenv, python, overrides }: let
          pythonPackagesFun = import ../../../top-level/python-packages.nix {
            inherit stdenv pkgs;
            python = self;
          };
          otherSplices = {
            selfBuildBuild = pythonOnBuildForBuild.pkgs;
            selfBuildHost = pythonOnBuildForHost.pkgs;
            selfBuildTarget = pythonOnBuildForTarget.pkgs;
            selfHostHost = pythonOnHostForHost.pkgs;
            selfTargetTarget = pythonOnTargetForTarget.pkgs or {}; # There is no Python TargetTarget.
          };
          keep = self: {
            # TODO maybe only define these here so nothing is needed to be kept in sync.
            inherit (self)
              isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast pythonOlder
              python bootstrapped-pip buildPythonPackage buildPythonApplication
              fetchPypi
              hasPythonModule requiredPythonModules makePythonPath disabledIf
              toPythonModule toPythonApplication
              buildSetupcfg

              eggUnpackHook
              eggBuildHook
              eggInstallHook
              flitBuildHook
              pipBuildHook
              pipInstallHook
              pytestCheckHook
              pythonCatchConflictsHook
              pythonImportsCheckHook
              pythonNamespacesHook
              pythonRecompileBytecodeHook
              pythonRemoveBinBytecodeHook
              pythonRemoveTestsDirHook
              setuptoolsBuildHook
              setuptoolsCheckHook
              venvShellHook
              wheelUnpackHook

              wrapPython

              pythonPackages

              recursivePthLoader
            ;
          };
        in lib.makeScopeWithSplicing
          pkgs.splicePackages
          pkgs.newScope
          otherSplices
          keep
          (lib.extends overrides pythonPackagesFun))
        {
          overrides = packageOverrides;
        };
    in rec {
        isPy27 = pythonVersion == "2.7";
        isPy35 = pythonVersion == "3.5";
        isPy36 = pythonVersion == "3.6";
        isPy37 = pythonVersion == "3.7";
        isPy38 = pythonVersion == "3.8";
        isPy39 = pythonVersion == "3.9";
        isPy310 = pythonVersion == "3.10";
        isPy2 = lib.strings.substring 0 1 pythonVersion == "2";
        isPy3 = lib.strings.substring 0 1 pythonVersion == "3";
        isPy3k = isPy3;
        isPyPy = lib.hasInfix "pypy" interpreter;

        buildEnv = callPackage ./wrapper.nix { python = self; inherit (pythonPackages) requiredPythonModules; };
        withPackages = import ./with-packages.nix { inherit buildEnv pythonPackages;};
        pkgs = pythonPackages;
        interpreter = "${self}/bin/${executable}";
        inherit executable implementation libPrefix pythonVersion sitePackages;
        inherit sourceVersion;
        pythonAtLeast = lib.versionAtLeast pythonVersion;
        pythonOlder = lib.versionOlder pythonVersion;
        inherit hasDistutilsCxxPatch;
        # TODO: rename to pythonOnBuild
        # Not done immediately because its likely used outside Nixpkgs.
        pythonForBuild = pythonOnBuildForHost.override { inherit packageOverrides; self = pythonForBuild; };

        tests = callPackage ./tests.nix {
          python = self;
        };
  };
in {

  python27 = callPackage ./cpython/2.7 {
    self = python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "18";
      suffix = "";
    };
    sha256 = "0hzgxl94hnflis0d6m4szjx0b52gah7wpmcg5g00q7am6xwhwb5n";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python36 = callPackage ./cpython {
    self = python36;
    sourceVersion = {
      major = "3";
      minor = "6";
      patch = "12";
      suffix = "";
    };
    sha256 = "cJU6m11okdkuZdGEw1EhJqFYFL7hXh7/LdzOBDNOmpk=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "9";
      suffix = "";
    };
    sha256 = "008v6g1jkrjrdmiqlgjlq6msbbj848bvkws6ppwva1ahn03k14li";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "6";
      suffix = "";
    };
    sha256 = "qeC3nSeqBW65zOjWOkJ7X5urFGXe4/lC3P2yWoL0q4o=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python39 = callPackage ./cpython {
    self = python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "1";
      suffix = "";
    };
    sha256 = "1zq3k4ymify5ig739zyvx9s2ainvchxb1zpy139z74krr653y74r";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python310 = callPackage ./cpython {
    self = python310;
    sourceVersion = {
      major = "3";
      minor = "10";
      patch = "0";
      suffix = "a3";
    };
    sha256 = "sha256-sJjJdAdxOUfX7W7VioSGdxlgp2lyMOPZjg42MCd/JYY=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  # Minimal versions of Python (built without optional dependencies)
  python3Minimal = (python38.override {
    self = python3Minimal;
    # strip down that python version as much as possible
    openssl = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
    configd = null;
    stripConfig = true;
    stripIdlelib = true;
    stripTests = true;
    stripTkinter = true;
    rebuildBytecode = false;
    stripBytecode = true;
    includeSiteCustomize = false;
    enableOptimizations = false;
  }).overrideAttrs(old: {
    pname = "python3-minimal";
    meta = old.meta // {
      maintainers = [];
    };
  });

  pypy27 = callPackage ./pypy {
    self = pypy27;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "1";
    };
    sha256 = "08ckkhd0ix6j9873a7gr507c72d4cmnv5lwvprlljdca9i8p2dzs";
    pythonVersion = "2.7";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy36 = callPackage ./pypy {
    self = pypy36;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "1";
    };
    sha256 = "10zsk8jby8j6visk5mzikpb1cidvz27qq4pfpa26jv53klic6b0c";
    pythonVersion = "3.6";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy27_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy27_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "1";
    };
    sha256 = "18xc5kwidj5hjwbr0w8v1nfpg5l4lk01z8cn804zfyyz8xjqhx5y"; # linux64
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy36_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy36_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "1";
    };
    sha256 = "04nv0mkalaliphbjw7y0pmb372bxwjzwmcsqkf9kwsik99kg2z7n"; # linux64
    pythonVersion = "3.6";
    inherit passthruFun;
  };

  graalpython37 = callPackage ./graalpython/default.nix {
    self = pythonInterpreters.graalpython37;
    inherit passthruFun;
  };

})
