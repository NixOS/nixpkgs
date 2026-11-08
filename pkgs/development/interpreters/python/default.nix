{
  __splicedPackages,
  callPackage,
  config,
  db,
  lib,
  makeScopeWithSplicing',
  pythonPackagesExtensions,
  stdenv,
}@args:

(
  let

    # Common passthru for all Python interpreters.
    passthruFun = import ./passthrufun.nix args;

    sources = {
      python314 = {
        sourceVersion = {
          major = "3";
          minor = "14";
          patch = "10";
          suffix = "";
        };
        hash = "sha256-3kFKVxGavvUnhNiZPjQdU67WNfwrBcJgfZ+YosW3IDI=";
      };
    };

  in
  {

    python311 = callPackage ./cpython {
      self = __splicedPackages.python311;
      sourceVersion = {
        major = "3";
        minor = "11";
        patch = "18";
        suffix = "";
      };
      hash = "sha256-kSDgplOGj242mNNs3ZnlpYkD7JRp5EjyHZj3sW2PopA=";
      inherit passthruFun;
    };

    python312 = callPackage ./cpython {
      self = __splicedPackages.python312;
      sourceVersion = {
        major = "3";
        minor = "12";
        patch = "16";
        suffix = "";
      };
      hash = "sha256-tXlpFdxF/3Rc+06ZCn58k9b1RjKKECzjFEjWnrw3V1w=";
      inherit passthruFun;
    };

    python313 = callPackage ./cpython {
      self = __splicedPackages.python313;
      sourceVersion = {
        major = "3";
        minor = "13";
        patch = "18";
        suffix = "";
      };
      hash = "sha256-q7AQLm1K4CdQm8uCMn2d2FUVtEo7qK1TjPxemEcCn2g=";
      inherit passthruFun;
    };

    python314 = callPackage ./cpython (
      {
        self = __splicedPackages.python314;
        inherit passthruFun;
      }
      // sources.python314
    );

    python315 = callPackage ./cpython {
      self = __splicedPackages.python315;
      sourceVersion = {
        major = "3";
        minor = "15";
        patch = "2";
        suffix = "";
      };
      hash = "sha256-i1U20oAULs9s3+FdEqIbocZeMAu/eyio0M24SVdXl94=";
      inherit passthruFun;
    };

    python316 = callPackage ./cpython {
      self = __splicedPackages.python315;
      sourceVersion = {
        major = "3";
        minor = "16";
        patch = "0";
        suffix = "a1";
      };
      hash = "sha256-3KqQKUNrcj4zQSxoyhfwEwvnMFjkejp8BJy4zfYDTuk=";
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
          withMinimalDeps = true;
        }
        // sources.python314
      )).overrideAttrs
        (old: {
          # TODO(@Artturin): Add this to the main cpython expr
          strictDeps = true;
          pname = "python3-minimal";
        });

    pypy27 = callPackage ./pypy {
      self = __splicedPackages.pypy27;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };

      hash = "sha256-E5fDA8Rv226ygJE3dmi/K/iZCf31gk3+Bn+bR9oxhEo=";
      pythonVersion = "2.7";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
      inherit passthruFun;
    };

    pypy311 = callPackage ./pypy {
      self = __splicedPackages.pypy311;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };

      hash = "sha256-fl8oAe6H1S+03glvtlC8pNVgXNi1/ieNulUAAZ+jc54=";
      pythonVersion = "3.11";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pypy27;
      inherit passthruFun;
    };

    pypy312 = callPackage ./pypy {
      self = __splicedPackages.pypy312;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };

      hash = "sha256-nVyC051ZDcBGd/RyFziyHWcFcM3JgkwAODa6/ThVbNo=";
      pythonVersion = "3.12";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pypy27;
      inherit passthruFun;
    };

    pypy27_prebuilt = callPackage ./pypy/prebuilt_2_7.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy27_prebuilt;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };

      hash =
        {
          aarch64-linux = "sha256-q9W9YB/FrxQ6gNAsUrXwmPAJb5sHkxQDU+Xj1Dlna4U=";
          x86_64-linux = "sha256-eGdM35XrTLHdWptopwIAOHERyylGf4pHKrfPB6JRZTw=";
          aarch64-darwin = "sha256-jZ9dm0QLtIht8H9eUDi4eYXiuXfcBIdj1mmfp7cYaxk=";
        }
        .${stdenv.system};
      pythonVersion = "2.7";
      inherit passthruFun;
    };

    pypy311_prebuilt = callPackage ./pypy/prebuilt.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy311_prebuilt;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };
      hash =
        {
          aarch64-linux = "sha256-W1aOFRXe5G31jJhE26lZIcad/Z846/ng8JHKrV4QzQw=";
          x86_64-linux = "sha256-cGllvPNydSumna/VnYYOUbwvrbsPikfOw0JhJdcFjOs=";
          aarch64-darwin = "sha256-uDkmip6vQdKOTcC+IPIgHhgSGzHcnryLwZ0UDZ00vGw=";
        }
        .${stdenv.system};
      pythonVersion = "3.11";
      inherit passthruFun;
    };

    pypy312_prebuilt = callPackage ./pypy/prebuilt.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy312_prebuilt;
      sourceVersion = {
        major = "8";
        minor = "0";
        patch = "1";
      };
      hash =
        {
          aarch64-linux = "sha256-TdlhH3gvCXT/0ltSESC0KXBJ2uwFo87FaY28YCLHT7k=";
          x86_64-linux = "sha256-ru0neXd3KW2clOU736YIgEaW29T/nyITADzOBk7kbvg=";
          aarch64-darwin = "sha256-wQuurkphBjoRg8TuToMkdlunNqOYAyNlTvsx558VFNs=";
        }
        .${stdenv.system};
      pythonVersion = "3.12";
      inherit passthruFun;
    };
  }
  // lib.optionalAttrs config.allowAliases {
    pypy39_prebuilt = throw "pypy 3.9 has been removed, use pypy 3.11 instead"; # Added 2025-01-03
    pypy310_prebuilt = throw "pypy 3.10 has been removed, use pypy 3.11 instead"; # Added 2026-11-08
  }
)
