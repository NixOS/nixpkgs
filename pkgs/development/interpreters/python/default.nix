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
    python310 = {
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "12";
        suffix = "";
      };
      hash = "sha256-r7dL8ZEw56R9EDEsj154TyTgUnmB6raOIFRs+4ZYMLg=";
    };

    python311 = {
      sourceVersion = {
        major = "3";
        minor = "11";
        patch = "4";
        suffix = "";
      };
      hash = "sha256-Lw5AnfKrV6qfxMvd+5dq9E5OVb9vYZ7ua8XCKXJkp/Y=";
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

  python38 = callPackage ./cpython {
    self = __splicedPackages.python38;
    sourceVersion = {
      major = "3";
      minor = "8";
      patch = "18";
      suffix = "";
    };
    hash = "sha256-P/txzTSaMmunsvrcfn34a6V33ZxJF+UqhAGtvadAXj8=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python39 = callPackage ./cpython {
    self = __splicedPackages.python39;
    sourceVersion = {
      major = "3";
      minor = "9";
      patch = "18";
      suffix = "";
    };
    hash = "sha256-AVl9sBMsHPezMe/2iuCbWiNaPDyqnJRMKcrH0cTEwAo=";
    inherit (darwin) configd;
    inherit passthruFun;
  };

  python310 = callPackage ./cpython ({
    self = __splicedPackages.python310;
    inherit (darwin) configd;
    inherit passthruFun;
  } // sources.python310);

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
      patch = "0";
      suffix = "rc3";
    };
    hash = "sha256-ljl+iR6YgCsdOZ3uPOrrm88KolZsinsczk0BlsJ3UGo=";
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

    hash = "sha256-ERevtmgx2k6m852NIIR4enRon9AineC+MB+e2bJVCTw=";
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

    hash = "sha256-sPMWb7Klqt/VzrnbXN1feSmg7MygK0omwNrgSS98qOo=";
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
    hash = "sha256-TWdpv8pzc06GZv1wUDt86wam4lkRDmFzMbs4mcpOYFg=";
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

    hash = {
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
    hash = {
      aarch64-linux = "sha256-CRddxlLtiV2Y6a1j0haBK/PufjmNkAqb+espBrqDArk=";
      x86_64-linux = "sha256-1QYXLKEQcSdBdddOnFgcMWZDLQF5sDZHDjuejSDq5YE=";
      aarch64-darwin = "sha256-ka11APGjlTHb76CzRaPc/5J/+ZcWVOjS6e98WuMR9X4=";
      x86_64-darwin = "sha256-0z9AsgcJmHJYWv1xhzV1ym6mOKJ9gjvGISOMWuglQu0=";
    }.${stdenv.system};
    pythonVersion = "3.9";
    inherit passthruFun;
  };

  rustpython = darwin.apple_sdk_11_0.callPackage ./rustpython/default.nix {
    inherit (darwin.apple_sdk_11_0.frameworks) SystemConfiguration;
  };

})
