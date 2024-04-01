{ __splicedPackages
, callPackage
, config
, darwin
, db
, lib
, libffiBoot
, makeScopeWithSplicing'
, pythonPackagesExtensions
, stdenv
}@args:

(let

  # Common passthru for all Python interpreters.
  passthruFun = import ./passthrufun.nix args;

  sources = {
    python311 = {
      sourceVersion = {
        major = "3";
        minor = "11";
        patch = "8";
        suffix = "";
      };
      hash = "sha256-ngYAjIkBkkOVvB2jA+rFZ6cprgErqhgqs5Jp9lA4O7M=";
    };
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = __splicedPackages.python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "18";
      suffix = ".7"; # ActiveState's Python 2 extended support
    };
    hash = "sha256-zcjAoSq6491ePiDySBCKrLIyYoO/5fdH6aBTNg/NH8s=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python39 = callPackage ./cpython {
    self = __splicedPackages.python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "19";
      suffix = "";
    };
    hash = "sha256-1Iks0WGPZFjLhRIIwDDfFIJ3lgnQ85OZkb04GE+MZ54=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python310 = callPackage ./cpython {
    self = __splicedPackages.python310;
    sourceVersion = {
      major = "3";
      minor = "10";
      patch = "14";
      suffix = "";
    };
    hash = "sha256-nFBIH6qMKDIym6D8iGjQpgamgPxPYOxI0mzo4HZ1H9o=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python311 = callPackage ./cpython ({
    self = __splicedPackages.python311;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python311);

  python312 = callPackage ./cpython {
    self = __splicedPackages.python312;
    sourceVersion = {
      major = "3";
      minor = "12";
      patch = "2";
      suffix = "";
    };
    hash = "sha256-vigRLayBPSBTVFwUvxOhZAGiGHfxpp626l2ExKDz2HA=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python313 = callPackage ./cpython {
    self = __splicedPackages.python313;
    sourceVersion = {
      major = "3";
      minor = "13";
      patch = "0";
      suffix = "a5";
    };
    hash = "sha256-Hom1NVGD58iYpaAbL2AXKP5J/bidnJeB8TNghHqu+mI=";
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
    configd = null;
    sqlite = null;
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
  } // sources.python311)).overrideAttrs(old: {
    # TODO(@Artturin): Add this to the main cpython expr
    strictDeps = true;
    pname = "python3-minimal";
  });

  pypy27 = callPackage ./pypy {
    self = __splicedPackages.pypy27;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "12";
    };

    hash = "sha256-3WHYjaJ0ws4s7HdmfUo9+aZSvMUOJvkJkdTdCvZrzPQ=";
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
      patch = "12";
    };

    hash = "sha256-56IEbH5sJfw4aru1Ey6Sp8wkkeOTVpmpRstdy7NCwqo=";
    pythonVersion = "3.9";
    db = db.override { dbmSupport = !stdenv.isDarwin; };
    python = __splicedPackages.pypy27;
    inherit passthruFun;
    inherit (darwin) libunwind;
    inherit (darwin.apple_sdk.frameworks) Security;
  };

  pypy310 = __splicedPackages.pypy39.override {
    self = __splicedPackages.pythonInterpreters.pypy310;
    pythonVersion = "3.10";
    hash = "sha256-huTk6sw2BGxhgvQwGHllN/4zpg4dKizGuOf5Gl3LPkI=";
  };

  pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "12";
    };

    hash = {
      aarch64-linux = "sha256-4E3LYoantHJOw/DlDTzBuoWDMB3RZYwG1/N1meQgHFk=";
      x86_64-linux = "sha256-GmGiV0t5Rm9gYBDymZormVvZbNCF+Rp46909XCxA6B0=";
      aarch64-darwin = "sha256-a3R6oHauhZfklgPF3sTKWTWhoKEy10BKVZvpaiYNm/c=";
      x86_64-darwin = "sha256-bon/3RVTfOT/zjFFtl7lfC6clSiSvZW5NAEtLwCfUDs=";
    }.${stdenv.system};
    pythonVersion = "2.7";
    inherit passthruFun;
  };

  pypy39_prebuilt = callPackage ./pypy/prebuilt.nix {
    # Not included at top-level
    self = __splicedPackages.pythonInterpreters.pypy39_prebuilt;
    sourceVersion = {
      major = "7";
      minor = "3";
      patch = "12";
    };
    hash = {
      aarch64-linux = "sha256-6TJ/ue2vKtkZNdW4Vj7F/yQZO92xdcGsqvdywCWvGCQ=";
      x86_64-linux = "sha256-hMiblm+rK1j0UaSC7jDKf+wzUENb0LlhRhXGHcbaI5A=";
      aarch64-darwin = "sha256-DooaNGi5eQxzSsaY9bAMwD/BaJnMxs6HZGX6wLg5gOM=";
      x86_64-darwin = "sha256-ZPAI/6BwxAfl70bIJWsuAU3nGW6l2Fg4WGElTnlZ9Os=";
    }.${stdenv.system};
    pythonVersion = "3.9";
    inherit passthruFun;
  };

  rustpython = darwin.apple_sdk_11_0.callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk_11_0.frameworks) SystemConfiguration;
  };

})
