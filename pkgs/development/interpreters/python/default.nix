{
  __splicedPackages,
  callPackage,
  config,
  db,
  lib,
  libffiBoot,
  makeScopeWithSplicing',
  pythonPackagesExtensions,
  stdenv,
}@args:

(
  let

    # Common passthru for all Python interpreters.
    passthruFun = import ./passthrufun.nix args;

    sources = {
      python312 = {
        sourceVersion = {
          major = "3";
          minor = "12";
          patch = "10";
          suffix = "";
        };
        hash = "sha256-B6tpdHRZXgbwZkdBfTx/qX3tB6/Bp+RFTFY5kZtG6uo=";
      };
    };

  in
  {

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

    python310 = callPackage ./cpython {
      self = __splicedPackages.python310;
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "17";
        suffix = "";
      };
      hash = "sha256-TGgFDwSdG0rFqt0N9fJ5QcA1DSqeerCQfuXrUiXZ1rA=";
      inherit passthruFun;
    };

    python311 = callPackage ./cpython {
      self = __splicedPackages.python311;
      sourceVersion = {
        major = "3";
        minor = "11";
        patch = "12";
        suffix = "";
      };
      hash = "sha256-hJ2oevTfE3cQwXluJ2qVX3qFyflxCBBnyPVl0Vw1Kgk=";
      inherit passthruFun;
    };

    python312 = callPackage ./cpython (
      {
        self = __splicedPackages.python312;
        inherit passthruFun;
      }
      // sources.python312
    );

    python313 = callPackage ./cpython {
      self = __splicedPackages.python313;
      sourceVersion = {
        major = "3";
        minor = "13";
        patch = "3";
        suffix = "";
      };
      hash = "sha256-QPhovL3rgUmjFJWAu5v9QHszIc1I8L5jGvlVrJLA4EE=";
      inherit passthruFun;
    };

    python314 = callPackage ./cpython {
      self = __splicedPackages.python314;
      sourceVersion = {
        major = "3";
        minor = "14";
        patch = "0";
        suffix = "a7";
      };
      hash = "sha256-ca287DrJ7fkzCOVc+0GE8utLFv2iuwpaOCkp7SnIOG0=";
      inherit passthruFun;
    };
    # Minimal versions of Python (built without optional dependencies)
    python3Minimal =
      (callPackage ./cpython (
        {
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
          libuuid = null;
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
        }
        // sources.python312
      )).overrideAttrs
        (old: {
          # TODO(@Artturin): Add this to the main cpython expr
          strictDeps = true;
          pname = "python3-minimal";
        });

    pypy27 = callPackage ./pypy {
      self = __splicedPackages.pypy27;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "17";
      };

      hash = "sha256-UOBoQPS73pFEgICkEYBoqJuPvK4l/42h4rsUAtyaA0Y=";
      pythonVersion = "2.7";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
      inherit passthruFun;
    };

    pypy310 = callPackage ./pypy {
      self = __splicedPackages.pypy310;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "17";
      };

      hash = "sha256-atdLxXjpxtOoocUVAzEwWOPFjDXfhvdIVFPEvmqyS/c=";
      pythonVersion = "3.10";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pypy27;
      inherit passthruFun;
    };

    pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "17";
      };

      hash =
        {
          aarch64-linux = "sha256-qN9c4WUPR1aTP4eAhwyRoKQOfJhw10YpvyQTkry1wuM=";
          x86_64-linux = "sha256-nzSX+HszctF+RHNp4AFqS+yZprTSpZq6d0olv+Q1NHQ=";
          aarch64-darwin = "sha256-gCJIc5sqzIwb5tlH8Zsy/A44wI4xKzXAXMf7IvEHCeQ=";
          x86_64-darwin = "sha256-gtRgQhRmyBraSh2Z3y3xuLNTQbOXyF///lGkwwItCDM=";
        }
        .${stdenv.system};
      pythonVersion = "2.7";
      inherit passthruFun;
    };

    pypy310_prebuilt = callPackage ./pypy/prebuilt.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy310_prebuilt;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "17";
      };
      hash =
        {
          aarch64-linux = "sha256-v79JVJirwv53G2C/ZOXDwHLgr7z8pprHKCxP9Dd/9BY=";
          x86_64-linux = "sha256-NA2kGWYGsiRQmhuLMa/SAYE/CCYB3xicE46QXB1g4K8=";
          aarch64-darwin = "sha256-KPKf/JxcyQbo6QgT/BRPA34js4TwUuGE4kIzL3tgqwY=";
          x86_64-darwin = "sha256-I/8mS3PlvFt8OhufrHdosj35bH1mDLZBLxxSNSGjNL8=";
        }
        .${stdenv.system};
      pythonVersion = "3.10";
      inherit passthruFun;
    };
  }
  // lib.optionalAttrs config.allowAliases {
    pypy39_prebuilt = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-03
  }
)
