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
      python313 = {
        sourceVersion = {
          major = "3";
          minor = "13";
          patch = "9";
          suffix = "";
        };
        hash = "sha256-7V7zTNo2z6Lzo0DwfKx+eBT5HH88QR9tNWIyOoZsXGY=";
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
        suffix = ".12"; # ActiveState's Python 2 extended support
      };
      hash = "sha256-RuEgfpags9wJm9Xe0daotqUx4knABEUc7DvtgnQXEfE=";
      inherit passthruFun;
    };

    python310 = callPackage ./cpython {
      self = __splicedPackages.python310;
      sourceVersion = {
        major = "3";
        minor = "10";
        patch = "19";
        suffix = "";
      };
      hash = "sha256-yPSlllciAdgd19+R9w4XfhmnDx1ImWi1S1+78pqXwHY=";
      inherit passthruFun;
    };

    python311 = callPackage ./cpython {
      self = __splicedPackages.python311;
      sourceVersion = {
        major = "3";
        minor = "11";
        patch = "14";
        suffix = "";
      };
      hash = "sha256-jT7Y7FyIwclfXlWGEqclRQ0kUoE92tXlj9saU7Egm3g=";
      inherit passthruFun;
    };

    python312 = callPackage ./cpython {
      self = __splicedPackages.python312;
      sourceVersion = {
        major = "3";
        minor = "12";
        patch = "12";
        suffix = "";
      };
      hash = "sha256-+4WhNBSwKMSboYu9UjwtBVowtWsYuSzkVOosUe3GVsQ=";
      inherit passthruFun;
    };

    python313 = callPackage ./cpython (
      {
        self = __splicedPackages.python313;
        inherit passthruFun;
      }
      // sources.python313
    );

    python314 = callPackage ./cpython {
      self = __splicedPackages.python314;
      sourceVersion = {
        major = "3";
        minor = "14";
        patch = "0";
        suffix = "";
      };
      hash = "sha256-Ipna5ULTlc44g6ygDTyRAwfNaOCy9zNgmMjnt+7p8+k=";
      inherit passthruFun;
    };

    python315 = callPackage ./cpython {
      self = __splicedPackages.python315;
      sourceVersion = {
        major = "3";
        minor = "15";
        patch = "0";
        suffix = "a1";
      };
      hash = "sha256-MZSTnUiO6u79z5kNNVQtmtHOeIeJxOIwWiBg63BY5aQ=";
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
        // sources.python313
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
        patch = "19";
      };

      hash = "sha256-hwPNywH5+Clm3UO2pgGPFAOZ21HrtDwSXB+aIV57sAM=";
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
        patch = "19";
      };

      hash = "sha256-p8IpMLkY9Ahwhl7Yp0FH9ENO+E09bKKzweupNV1JKcg=";
      pythonVersion = "3.10";
      db = db.override { dbmSupport = !stdenv.hostPlatform.isDarwin; };
      python = __splicedPackages.pypy27;
      inherit passthruFun;
    };

    pypy311 = callPackage ./pypy {
      self = __splicedPackages.pypy311;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "20";
      };

      hash = "sha256-d4bdp2AAPi6nQJwQN+UCAMV47EJ84CRaxM11hxCyBvs=";
      pythonVersion = "3.11";
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
        patch = "19";
      };

      hash =
        {
          aarch64-linux = "sha256-/onU/UrxP3bf5zFZdQA1GM8XZSDjzOwVRKiNF09QkQ4=";
          x86_64-linux = "sha256-04RFUIwurxTrs4DZwd7TIcXr6uMcfmaAAXPYPLjd9CM=";
          aarch64-darwin = "sha256-KHgOC5CK1ttLTglvQjcSS+eezJcxlG2EDZyHSetnp1k=";
          x86_64-darwin = "sha256-a+KNRI2OZP/8WG2bCuTQkGSoPMrrW4BgxlHFzZrgaHg=";
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
        patch = "19";
      };
      hash =
        {
          aarch64-linux = "sha256-ryeliRePERmOIkSrZcpRBjC6l8Ex18zEAh61vFjef1c=";
          x86_64-linux = "sha256-xzrCzCOArJIn/Sl0gr8qPheoBhi6Rtt1RNU1UVMh7B4=";
          aarch64-darwin = "sha256-PbigP8SWFkgBZGhE1/OxK6oK2zrZoLfLEkUhvC4WijY=";
          x86_64-darwin = "sha256-LF5cKjOsiCVR1/KLmNGdSGuJlapQgkpztO3Mau7DXGM=";
        }
        .${stdenv.system};
      pythonVersion = "3.10";
      inherit passthruFun;
    };

    pypy311_prebuilt = callPackage ./pypy/prebuilt.nix {
      # Not included at top-level
      self = __splicedPackages.pythonInterpreters.pypy311_prebuilt;
      sourceVersion = {
        major = "7";
        minor = "3";
        patch = "19";
      };
      hash =
        {
          aarch64-linux = "sha256-EyB9v4HOJOltp2CxuGNie3e7ILH7TJUZHgKgtyOD33Q=";
          x86_64-linux = "sha256-kXfZ4LuRsF+SHGQssP9xoPNlO10ppC1A1qB4wVt1cg8=";
          aarch64-darwin = "sha256-dwTg1TAuU5INMtz+mv7rEENtTJQjPogwz2A6qVWoYcE=";
          x86_64-darwin = "sha256-okOfnTDf2ulqXpEBx9xUqKaLVsnXMU6jmbCiXT6H67I=";
        }
        .${stdenv.system};
      pythonVersion = "3.11";
      inherit passthruFun;
    };
  }
  // lib.optionalAttrs config.allowAliases {
    pypy39_prebuilt = throw "pypy 3.9 has been removed, use pypy 3.10 instead"; # Added 2025-01-03
  }
)
