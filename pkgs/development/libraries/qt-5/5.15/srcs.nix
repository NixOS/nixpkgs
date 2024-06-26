{
  lib,
  fetchgit,
  fetchFromGitHub,
}:

let
  version = "5.15.14";

  mk = name: args: {
    inherit version;
    src = fetchgit {
      inherit (args) url rev sha256;
      fetchLFS = false;
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
    };
  };
in
lib.mapAttrs mk (lib.importJSON ./srcs-generated.json)
// {
  # qtpim has no official releases
  qtpim = {
    version = "unstable-2020-11-02";
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtpim";
      # Last commit before Qt5 support was broken
      rev = "f9a8f0fc914c040d48bbd0ef52d7a68eea175a98";
      hash = "sha256-/1g+vvHjuRLB1vsm41MrHbBZ+88Udca0iEcbz0Q1BNQ=";
    };
  };

  # Has no kde/5.15 branch
  qtpositioning = rec {
    version = "5.15.2";
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtpositioning";
      rev = "v${version}";
      hash = "sha256-L/P+yAQItm3taPpCNoOOm7PNdOFZiIwJJYflk6JDWvU=";
    };
  };

  # qtwebkit does not have an official release tarball on the qt mirror and is
  # mostly maintained by the community.
  qtwebkit = rec {
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtwebkit";
      rev = "v${version}";
      sha256 = "0x8rng96h19xirn7qkz3lydal6v4vn00bcl0s3brz36dfs0z8wpg";
    };
    version = "5.212.0-alpha4";
  };

  # qtsystems has no official releases
  qtsystems = {
    version = "unstable-2019-01-03";
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtsystems";
      rev = "e3332ee38d27a134cef6621fdaf36687af1b6f4a";
      hash = "sha256-P8MJgWiDDBCYo+icbNva0LODy0W+bmQTS87ggacuMP0=";
    };
  };

  qtscript = rec {
    version = "5.15.17";

    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtscript";
      rev = "v${version}-lts";
      hash = "sha256-wXEKdu2gdlkVsWr3nb/tCBwyo9H8GPHWTUele1cP0ks=";
    };
  };

  qtwebengine = rec {
    version = "5.15.17";

    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtwebengine";
      rev = "v${version}-lts";
      hash = "sha256-1be8Y96yHYBCxQsRC/PD2X0TVWpA2/r1hvi8sBKOais=";
      fetchSubmodules = true;
    };
  };
}
