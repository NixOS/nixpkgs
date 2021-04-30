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
            inherit stdenv pkgs lib;
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
          optionalExtensions = cond: as: if cond then as else [];
          python2Extension = import ../../../top-level/python2-packages.nix;
          extensions = lib.composeManyExtensions ((optionalExtensions (!self.isPy3k) [python2Extension]) ++ [ overrides ]);
        in lib.makeScopeWithSplicing
          pkgs.splicePackages
          pkgs.newScope
          otherSplices
          keep
          (lib.extends extensions pythonPackagesFun))
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

  sources = {
    "python38" = {
      sourceVersion = {
        major = "3";
        minor = "8";
        patch = "9";
        suffix = "";
      };
      sha256 = "XjkfPsRdopVEGcqwvq79i+OIlepc4zV3w+wUlAxLlXI=";
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
      patch = "13";
      suffix = "";
    };
    sha256 = "pHpDpTq7QihqLBGWU0P/VnEbnmTo0RvyxnAaT7jOGg8=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "10";
      suffix = "";
    };
    sha256 = "+NgudXLIbsnVXIYnquUEAST9IgOvQAw4PIIbmAMG7ms=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython ({
    self = python38;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python38);

  python39 = callPackage ./cpython {
    self = python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "4";
      suffix = "";
    };
    sha256 = "Sw5mRKdvjfhkriSsUApRu/aL0Jj2oXPifTthzcqaoTQ=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python310 = callPackage ./cpython {
    self = python310;
    sourceVersion = {
      major = "3";
      minor = "10";
      patch = "0";
      suffix = "a5";
    };
    sha256 = "BBjlfnA24hnx5rYwOyHnEfZM/Q/dsIlNjxnzev/8XU0=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  # Minimal versions of Python (built without optional dependencies)
  python3Minimal = (callPackage ./cpython ({
    self = python3Minimal;
    inherit passthruFun;
    pythonAttr = "python3Minimal";
    # strip down that python version as much as possible
    openssl = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
    configd = null;
    tzdata = null;
    stripConfig = true;
    stripIdlelib = true;
    stripTests = true;
    stripTkinter = true;
    rebuildBytecode = false;
    stripBytecode = true;
    includeSiteCustomize = false;
    enableOptimizations = false;
    mimetypesSupport = false;
  } // sources.python38)).overrideAttrs(old: {
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
      patch = "3";
    };
    sha256 = "0di3dr5ry4r0hwxh4fbqjhyl5im948wdby0bhijzsxx83c2qhd7n";
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
      patch = "3";
    };
    sha256 = "1bq5i2mqgjjfc4rhxgxm6ihwa76vn2qapd7l59ri7xp01p522gd2";
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
      patch = "3";
    };
    sha256 = "1cfpdyvbvzwc0ynjr7248jhwgcpl7073wlp7w3g2v4fnrh1bc4pl"; # linux64
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy36_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy36_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "3";
    };
    sha256 = "02lys9bjky9bqg6ggv8djirbd3zzcsq7755v4yvwm0k4a7fmzf2g"; # linux64
    pythonVersion = "3.6";
    inherit passthruFun;
  };

  graalpython37 = callPackage ./graalpython/default.nix {
    self = pythonInterpreters.graalpython37;
    inherit passthruFun;
  };

})
