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
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "16";
      suffix = "";
    };
    sha256 = "1mqfcqp5y8r0bfyr7ppl74n0lig45p9mc4b8adlcpvj74rhfy8pj";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python35 = callPackage ./cpython {
    self = python35;
    sourceVersion = {
      major = "3";
      minor = "5";
      patch = "7";
      suffix = "";
    };
    sha256 = "1p67pnp2ca5przx2s45r8m55dcn6f5hsm0l4s1zp7mglkf4r4n18";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python36 = callPackage ./cpython {
    self = python36;
    sourceVersion = {
      major = "3";
      minor = "6";
      patch = "9";
      suffix = "";
    };
    sha256 = "1nkh70azbv866aw5a9bbxsxarsf40233vrzpjq17z3rz9ramybsy";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python37 = callPackage ./cpython {
    self = python37;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "5";
      suffix = "";
    };
    sha256 = "154xc6dxww21qkmphg66pfks8987a17cl3vqq5g4hv1xkzm7cnp8";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  python38 = callPackage ./cpython {
    self = python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "0";
      suffix = "b3";
    };
    sha256 = "03wq85pkpr9j56k3zg6whahc5park1pzshbakl7y50lzrkpq2ynd";
    inherit (darwin) CF configd;
    inherit passthruFun;
  };

  # Minimal versions of Python (built without optional dependencies)
  python3Minimal = (callPackage ./cpython {
    self = python3Minimal;
    sourceVersion = {
      major = "3";
      minor = "7";
      patch = "4";
      suffix = "";
    };
    sha256 = "0gxiv5617zd7dnqm5k9r4q2188lk327nf9jznwq9j6b8p0s92ygv";
    inherit (darwin) CF configd;
    inherit passthruFun;

    # strip down that python version as much as possible
    openssl = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
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
    db = db.override { dbmSupport = true; };
    python = python27;
    inherit passthruFun;
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
    db = db.override { dbmSupport = true; };
    python = python27;
    inherit passthruFun;
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

})
