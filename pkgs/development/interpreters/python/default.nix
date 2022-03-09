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
              isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy310 isPy3k isPyPy pythonAtLeast pythonOlder
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
        isPy311 = pythonVersion == "3.11";
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
        patch = "12";
        suffix = "";
      };
      sha256 = "1si8hw2xpagh4iji89zdx69p3dv5mjqwwbx2x2sl6lrp41jaglxi";
    };
    python39 = {
      sourceVersion = {
        major = "3";
        minor = "9";
        patch = "10";
        suffix = "";
      };
      sha256 = "sha256-Co+/tSh+vDoT6brz1U4I+gZ3j/7M9jEa74Ibs6ZYbMg=";
    };
    python310 = {
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "2";
        suffix = "";
      };
      sha256 = "sha256-F946x9qfJRmqnWQ3jGA6c6DprVjf+ogS5FFgwIbeZMc=";
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

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "12";
      suffix = "";
    };
    sha256 = "041jqjl5wf7gsw84zd3jgvg91skq20l2fy5zbhz237w38zxzfyzp";
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

  python310 = callPackage ./cpython ({
    self = python310;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python310);

  python311 = callPackage ./cpython {
    self = python311;
    sourceVersion = {
      major = "3";
      minor = "11";
      patch = "0";
      suffix = "a4";
    };
    sha256 = "sha256-Q3/nN2w2Pa+vNM6A8ERrQfyaQsDiqMflGdPwoLfPs+0=";
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
    libffi = pkgs.libffiBoot; # without test suite
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

  pypy38 = callPackage ./pypy {
    self = pypy38;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "7";
    };
    sha256 = "sha256-Ia4zn09QFtbKcwAwXz47VUNzg1yzw5qQQf4w5oEcgMY=";
    pythonVersion = "3.8";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  pypy37 = pypy38.override {
    self = pythonInterpreters.pypy37;
    pythonVersion = "3.7";
    sha256 = "sha256-LtAqyecQhZxBvILer7CGGXkruaJ+6qFnbHQe3t0hTdc=";
  };

  pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy27_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "6";
    };
    sha256 = "sha256-ghJ/Q/rmznXUfWxFOfjB6jcunC2/pA+ui1g1HVInk6Q="; # linux64
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy38_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy38_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "7";
    };
    sha256 = "sha256-Xe43x8PLixYAKPveOlkBxoBD36VFoWeUUCuJfUvEDX4="; # linux64
    pythonVersion = "3.8";
    inherit passthruFun;
  };

  graalpython37 = callPackage ./graalpython/default.nix {
    self = pythonInterpreters.graalpython37;
    inherit passthruFun;
  };

  rustpython = callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

})
