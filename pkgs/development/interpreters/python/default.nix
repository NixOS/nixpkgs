{ __splicedPackages
, callPackage
, config
, darwin
, db
, lib
, libffiBoot
, makeScopeWithSplicing
, pythonPackagesExtensions
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
        in makeScopeWithSplicing
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
        isPy37 = pythonVersion == "3.7";
        isPy38 = pythonVersion == "3.8";
        isPy39 = pythonVersion == "3.9";
        isPy310 = pythonVersion == "3.10";
        isPy311 = pythonVersion == "3.11";
        isPy312 = pythonVersion == "3.12";
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
        patch = "16";
        suffix = "";
      };
      sha256 = "sha256-It3cCZJG3SdgZlVh6K23OU6gzEOnJoTGSA+TgPd4ZDk=";
    };
    python310 = {
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "9";
        suffix = "";
      };
      sha256 = "sha256-WuA+MIJgFkuro5kh/bTb+ObQPYI1qTnUWCsz8LXkaoM=";
    };
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = __splicedPackages.python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "18";
      suffix = ".6"; # ActiveState's Python 2 extended support
    };
    sha256 = "sha256-+I0QOBkuTHMIQz71lgNn1X1vjPsjJMtFbgC0xcGTwWY=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = __splicedPackages.python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "16";
      suffix = "";
    };
    sha256 = "sha256-2F27N3QTJHPYCB3LFY80oQzK16kLlsflDqS7YfXORWI=";
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
      patch = "1";
      suffix = "";
    };
    sha256 = "sha256-hYeRkvLP/VbLFsCSkFlJ6/Pl45S392RyNSljeQHftY8=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python312 = callPackage ./cpython {
    self = __splicedPackages.python312;
    sourceVersion = {
      major = "3";
      minor = "12";
      patch = "0";
      suffix = "a3";
    };
    sha256 = "sha256-G2SzB14KkkGXTlgOCbCckRehxOK+aYA5IB7x2Kc0U9E=";
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
      patch = "11";
    };

    sha256 = "sha256-ERevtmgx2k6m852NIIR4enRon9AineC+MB+e2bJVCTw=";
    pythonVersion = "2.7";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy39 = callPackage ./pypy {
    self = __splicedPackages.pypy39;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "11";
    };

    sha256 = "sha256-sPMWb7Klqt/VzrnbXN1feSmg7MygK0omwNrgSS98qOo=";
    pythonVersion = "3.9";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = __splicedPackages.pypy27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy38 = __splicedPackages.pypy39.override {
    self = __splicedPackages.pythonInterpreters.pypy38;
    pythonVersion = "3.8";
    sha256 = "sha256-TWdpv8pzc06GZv1wUDt86wam4lkRDmFzMbs4mcpOYFg=";
  };

  pypy37 = throw "pypy37 has been removed from nixpkgs since it is no longer supported upstream"; # Added 2023-01-04

  pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "11";
    };

    sha256 = {
      aarch64-linux = "sha256-6pJNod7+kyXvdg4oiwT5hGFOQFWA9TIetqXI9Tm9QVo=";
      x86_64-linux = "sha256-uo7ZWKkFwHNaTP/yh1wlCJlU3AIOCH2YKw/6W52jFs0=";
      aarch64-darwin = "sha256-zFaWq0+TzTSBweSZC13t17pgrAYC+hiQ02iImmxb93E=";
      x86_64-darwin = "sha256-Vt7unCJkD1aGw1udZP2xzjq9BEWD5AePCxccov0qGY4=";
    }.${stdenv.system};
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy39_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy38_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "11";
    };
    sha256 = {
      aarch64-linux = "sha256-CRddxlLtiV2Y6a1j0haBK/PufjmNkAqb+espBrqDArk=";
      x86_64-linux = "sha256-1QYXLKEQcSdBdddOnFgcMWZDLQF5sDZHDjuejSDq5YE=";
      aarch64-darwin = "sha256-ka11APGjlTHb76CzRaPc/5J/+ZcWVOjS6e98WuMR9X4=";
      x86_64-darwin = "sha256-0z9AsgcJmHJYWv1xhzV1ym6mOKJ9gjvGISOMWuglQu0=";
    }.${stdenv.system};
    pythonVersion = "3.9";
    inherit passthruFun;
  };

  rustpython = callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  };

})
