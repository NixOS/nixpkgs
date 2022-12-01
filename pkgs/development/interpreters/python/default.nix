{ __splicedPackages
, callPackage
, config
, darwin
, db
, lib
, libffiBoot
, newScope
, pythonPackagesExtensions
, splicePackages
, stdenv
}:

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
      pythonPackages = let
        ensurePythonModules = items: let
          exceptions = [
            stdenv
          ];
          providesSetupHook = lib.attrByPath [ "provides" "setupHook"] false;
          valid = value: !((lib.isDerivation value) && !((pythonPackages.hasPythonModule value) || (providesSetupHook value))) || (lib.elem value exceptions);
          func = name: value: if (valid value) then value else throw "${name} should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set.";
        in lib.mapAttrs func items;
      in ensurePythonModules (callPackage
        # Function that when called
        # - imports python-packages.nix
        # - adds spliced package sets to the package set
        # - applies overrides from `packageOverrides` and `pythonPackagesOverlays`.
        ({ pkgs, stdenv, python, overrides }: let
          pythonPackagesFun = import ./python-packages-base.nix {
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
          hooks = import ./hooks/default.nix;
          keep = lib.extends hooks pythonPackagesFun;
          extra = _: {};
          optionalExtensions = cond: as: if cond then as else [];
          pythonExtension = import ../../../top-level/python-packages.nix;
          python2Extension = import ../../../top-level/python2-packages.nix;
          extensions = lib.composeManyExtensions ([
            pythonExtension
          ] ++ (optionalExtensions (!self.isPy3k) [
            python2Extension
          ]) ++ pythonPackagesExtensions ++ [
            overrides
          ]);
          aliases = self: super: lib.optionalAttrs config.allowAliases (import ../../../top-level/python-aliases.nix lib self super);
        in lib.makeScopeWithSplicing
          splicePackages
          newScope
          otherSplices
          keep
          extra
          (lib.extends (lib.composeExtensions aliases extensions) keep))
        {
          overrides = packageOverrides;
          python = self;
        });
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
        patch = "15";
        suffix = "";
      };
      sha256 = "sha256-Etr/aAlSjZ9hVCFpUEI8njDw5HM2y1fGqgtDh91etLI=";
    };
    python310 = {
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "8";
        suffix = "";
      };
      sha256 = "sha256-ajDs3lnEcEgBPrWmWMm13sJ3ID0nk2Z/V433Zx9/A/M=";
    };
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = __splicedPackages.python27;
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
    self = __splicedPackages.python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "15";
      suffix = "";
    };
    sha256 = "sha256-WRFHWgesK1PXRuiKBxavbStHNJQZGRNuoNM/ucdblxQ=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = __splicedPackages.python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "15";
      suffix = "";
    };
    sha256 = "sha256-URT8eRiipeIOtarGlrMMNvQSxu8ksT9cnrngVpgtlVA=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python39 = callPackage ./cpython ({
    self = __splicedPackages.python39;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python39);

  python310 = callPackage ./cpython ({
    self = __splicedPackages.python310;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python310);

  python311 = callPackage ./cpython {
    self = __splicedPackages.python311;
    sourceVersion = {
      major = "3";
      minor = "11";
      patch = "0";
      suffix = "";
    };
    sha256 = "sha256-pX3ILXc1hhe6ZbmEHO4eO0QfOGw3id3AZ27KB38pUcM=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  # Minimal versions of Python (built without optional dependencies)
  python3Minimal = (callPackage ./cpython ({
    self = __splicedPackages.python3Minimal;
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
    libffi = libffiBoot; # without test suite
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
    self = __splicedPackages.pypy27;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "9";
    };

    sha256 = "sha256-ObCXKVb2VIzlgoAZ264SUDwy1svpGivs+I0+QsxSGXs=";
    pythonVersion = "2.7";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = __splicedPackages.python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy39 = callPackage ./pypy {
    self = __splicedPackages.pypy39;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "9";
    };

    sha256 = "sha256-Krqh6f4ewOIzyfvDd6DI6aBjQICo9PMOtomDAfZhjBI=";
    pythonVersion = "3.9";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = __splicedPackages.python27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy38 = __splicedPackages.pypy39.override {
    self = __splicedPackages.pythonInterpreters.pypy38;
    pythonVersion = "3.8";
    sha256 = "sha256-W12dklbxKhKa+DhOL1gb36s7wPu+OgpIDZwdLpVJDrE=";
  };
  pypy37 = __splicedPackages.pypy39.override {
    self = __splicedPackages.pythonInterpreters.pypy37;
    pythonVersion = "3.7";
    sha256 = "sha256-cEJhY7GU7kYAmYbuptlCYJij/7VS2c29PfqmSkc3P0k=";
  };

  pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "9";
    };

    sha256 = "sha256-FyqSiwCWp+ALfVj1I/VzAMNcPef4IkkeKnvIRTdcI/g="; # linux64
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy39_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy38_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "9";
    };
    sha256 = "sha256-RoGMs9dLlrNHh1SDQ9Jm4lYrUx3brzMDg7qTD/GTDtU="; # linux64
    pythonVersion = "3.9";
    inherit passthruFun;
  };

  rustpython = callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

})
