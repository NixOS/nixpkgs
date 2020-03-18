{ pkgs, lib }:

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
    , pythonForBuild
    , self
    }: let
      pythonPackages = callPackage ../../../top-level/python-packages.nix {
        python = self;
        overrides = packageOverrides;
      };
    in rec {
        isPy27 = pythonVersion == "2.7";
        isPy33 = pythonVersion == "3.3"; # TODO: remove
        isPy34 = pythonVersion == "3.4"; # TODO: remove
        isPy35 = pythonVersion == "3.5";
        isPy36 = pythonVersion == "3.6";
        isPy37 = pythonVersion == "3.7";
        isPy38 = pythonVersion == "3.8";
        isPy39 = pythonVersion == "3.9";
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
        inherit hasDistutilsCxxPatch pythonForBuild;

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
      patch = "17";
      suffix = "";
    };
    sha256 = "0hds28cg226m8j8sr394nm9yc4gxhvlv109w0avsf2mxrlrz0hsd";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python35 = callPackage ./cpython {
    self = python35;
    sourceVersion = {
      major = "3";
      minor = "5";
      patch = "9";
      suffix = "";
    };
    sha256 = "0jdh9pvx6m6lfz2liwvvhn7vks7qrysqgwn517fkpxb77b33fjn2";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python36 = callPackage ./cpython {
    self = python36;
    sourceVersion = {
      major = "3";
      minor = "6";
      patch = "10";
      suffix = "";
    };
    sha256 = "1pj0mz1xl27khi250p29c0y99vxg662js8zp71aprkf8i8wkr0qa";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "6";
      suffix = "";
    };
    sha256 = "0gskry19ylw91p38pdq36qcgk6h3x5i4ia0ik977kw2943kwr8jm";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "2";
      suffix = "";
    };
    sha256 = "1ps5v323cp5czfshqjmbsqw7nvrdpcbk06f62jbzaqik4gfffii6";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python39 = callPackage ./cpython {
    self = python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "0";
      suffix = "a4";
    };
    sha256 = "0qzy0wlq0izxk8ii28gy70v138g6xnz9sgsxpyayls2j04l6b5vz";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  # Minimal versions of Python (built without optional dependencies)
  python3Minimal = (python37.override {
    self = python3Minimal;
    pythonForBuild = pkgs.buildPackages.python3Minimal;
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
      minor = "1";
      patch = "1";
    };
    sha256 = "0yq6ln1ic476sasp8zs4mg5i9524l1p96qwanp486rr1yza1grlg";
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
      minor = "1";
      patch = "1";
    };
    sha256 = "1hqvnran7d2dzj5555n7q680dyzhmbklz04pvkxgb5j604v7kkx1";
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
      minor = "1";
      patch = "1";
    };
    sha256 = "0rlx4x9xy9h989w6sy4h7lknm00956r30c5gjxwsvf8fhvq9xc3k"; # linux64
    pythonVersion = "2.7";
    inherit passthruFun;
    ncurses = ncurses5;
  };

  pypy36_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = pythonInterpreters.pypy36_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "1";
      patch = "1";
    };
    sha256 = "1c1xx6dm1n4xvh1vd3rcvyyixm5jm9rvzisji1a5bc9l38xzc540"; # linux64
    pythonVersion = "3.6";
    inherit passthruFun;
    ncurses = ncurses5;
  };

  graalpython37 = callPackage ./graalpython/default.nix {
    self = pythonInterpreters.graalpython37;
    inherit passthruFun;
  };

})
