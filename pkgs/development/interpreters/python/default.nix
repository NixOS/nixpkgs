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
    python312 = {
      sourceVersion = {
        major = "3";
        minor = "12";
        patch = "8";
        suffix = "";
      };
      hash = "sha256-yQkVe7JewRTlhpEkzCqcSk1MHpV8pP9VPx7caSEBFU4=";
    };
  };

in {

  python27 = callPackage ./cpython/2.7 {
    self = __splicedPackages.python27;
    sourceVersion = {
      major = "2";
      minor = "7";
      patch = "18";
      suffix = ".8"; # ActiveState's Python 2 extended support
    };
    hash = "sha256-HUOzu3uJbtd+3GbmGD35KOk/CDlwL4S7hi9jJGRFiqI=";
    inherit passthruFun;
  };

  python39 = callPackage ./cpython {
    self = __splicedPackages.python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "21";
      suffix = "";
    };
    hash = "sha256-MSb1lZLJsNeYWEdV8r97CB+hyjXOem/qmAEI11KgW7E=";
    inherit passthruFun;
  };

  python310 = callPackage ./cpython {
    self = __splicedPackages.python310;
    sourceVersion = {
      major = "3";
      minor = "10";
      patch = "16";
      suffix = "";
    };
    hash = "sha256-v7JJYJmQIgSRobkoUKBxNe0IMeQXOM9oHWPPAbKo+9E=";
    inherit passthruFun;
  };

  python311 = callPackage ./cpython {
    self = __splicedPackages.python311;
    sourceVersion = {
      major = "3";
      minor = "11";
      patch = "11";
      suffix = "";
    };
    hash = "sha256-Kpkgx6DNI23jNkTtmAoTy7whBYv9xSj+u2CBV17XO+M=";
    inherit passthruFun;
  };

  python312 = callPackage ./cpython ({
    self = __splicedPackages.python312;
    inherit passthruFun;
  } // sources.python312);

  python313 = callPackage ./cpython {
    self = __splicedPackages.python313;
    sourceVersion = {
      major = "3";
      minor = "13";
      patch = "1";
      suffix = "";
    };
    hash = "sha256-nPlCe+6eIkLjh33Q9rZBwYU8pGHznWUDziYKWcgL8Nk=";
    inherit passthruFun;
  };

  python314 = callPackage ./cpython {
    self = __splicedPackages.python314;
    sourceVersion = {
      major = "3";
      minor = "14";
      patch = "0";
      suffix = "a2";
    };
    hash = "sha256-L/nhAUc0Kz79afXNnMBuxGJQ8qBGWHWZ0Y4srGnAWSA=";
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
  } // sources.python312)).overrideAttrs(old: {
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
    db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
    python = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
    inherit passthruFun;
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
    db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
    python = __splicedPackages.pypy27;
    inherit passthruFun;
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
