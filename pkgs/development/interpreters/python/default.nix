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

              condaInstallHook
              condaUnpackHook
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
          extra = _: {};
          optionalExtensions = cond: as: if cond then as else [];
          python2Extension = import ../../../top-level/python2-packages.nix;
          extensions = lib.composeManyExtensions ((optionalExtensions (!self.isPy3k) [python2Extension]) ++ [ overrides ]);
          aliases = self: super: lib.optionalAttrs (config.allowAliases or true) (import ../../../top-level/python-aliases.nix lib self super);
        in lib.makeScopeWithSplicing
          pkgs.splicePackages
          pkgs.newScope
          otherSplices
          keep
          extra
          (lib.extends (lib.composeExtensions aliases extensions) pythonPackagesFun))
        {
          overrides = packageOverrides;
          python = self;
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
    python38 = {
      sourceVersion = {
        major = "3";
        minor = "8";
        patch = "11";
        suffix = "";
      };
      sha256 = "1chg8b0m1yrz50lizid20zha0dmj40z0iih3jqcrg7pyxca126pv";
    };
    python39 = {
      sourceVersion = {
        major = "3";
        minor = "9";
        patch = "6";
        suffix = "";
      };
      sha256 = "12hhw2685i68pwfx5hdkqngzhbji4ccyjmqb5rzvkigg6fpj0y9r";
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
      patch = "14";
      suffix = "";
    };
    sha256 = "1bnm0bx7xf1jpfm0bmzlq19vwm0bvcbl7klx4rvgq05xryhafqr6";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "11";
      suffix = "";
    };
    sha256 = "0d57b5a47wapzpkkq5rbvvi4caylc35j5910b64rxxn4nmm1kd6x";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython ({
    self = python38;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python38);

  python39 = callPackage ./cpython ({
    self = python39;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python39);

  python310 = callPackage ./cpython {
    self = python310;
    sourceVersion = {
      major = "3";
      minor = "10";
      patch = "0";
      suffix = "rc1";
    };
    sha256 = "0f76q6rsvbvrzcnsp0k7sp555krrgvjpcd09l1rybl4249ln2w3r";
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
    enableLTO = false;
    mimetypesSupport = false;
  } // sources.python39)).overrideAttrs(old: {
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
      patch = "5";
    };
    sha256 = "sha256-wERP2YcwWMHA2Z4TqTTpIoXLBZksmWi/Ujwyv5vsCp0=";
    pythonVersion = "2.7";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy37 = callPackage ./pypy {
    self = pypy37;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "5";
    };
    sha256 = "sha256-2SD+QJqeytnQdKqFaMpfPtNYG+ZvZuXYmIt+xm5tmaI=";
    pythonVersion = "3.7";
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
