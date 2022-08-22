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
    , pythonAttr ? null
    , self # is pythonOnHostForTarget
    }: let
      pythonPackages = callPackage
        # Function that when called
        # - imports python-packages.nix
        # - adds spliced package sets to the package set
        # - applies overrides from `packageOverrides` and `pythonPackagesOverlays`.
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
          extensions = lib.composeManyExtensions ((optionalExtensions (!self.isPy3k) [python2Extension]) ++ pkgs.pythonPackagesExtensions ++ [ overrides ]);
          aliases = self: super: lib.optionalAttrs config.allowAliases (import ../../../top-level/python-aliases.nix lib self super);
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

        inherit pythonAttr;
  };

  sources = {
    python39 = {
      sourceVersion = {
        major = "3";
        minor = "9";
        patch = "13";
        suffix = "";
      };
      sha256 = "sha256-ElsMWY8eFdKqZUBug/eS330XHN84wWgDsUmZQxajCA8=";
    };
    python310 = {
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "6";
        suffix = "";
      };
      sha256 = "sha256-95X/h9EdSwx8M7yIUbDChkjYpFg6ohAKmMIrQya20/M=";
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
      patch = "13";
      suffix = "";
    };
    sha256 = "sha256-mfEGJ134iZw+jLnXwBzmhsIC7ydZUzAUJxlGk95b74Q=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "13";
      suffix = "";
    };
    sha256 = "sha256-bzCQdwEgQKo5/o8MYduMD6HEUTZ2MpnTdcnldW8Jz1c=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

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
      suffix = "rc1";
    };
    sha256 = "sha256-U6U3fDeoosbaB1sU651jN0V59/PHGPog8KH7sOlKkis=";
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
  } // sources.python310)).overrideAttrs(old: {
    # TODO(@Artturin): Add this to the main cpython expr
    strictDeps = true;
    pname = "python3-minimal";
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
      patch = "8";
    };
    sha256 = "0h493q0lhpz035afi4g09f4mz5a72vqx4sa7qcry5z4zagxq8bhz"; # linux64
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

  rustpython = callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

})
