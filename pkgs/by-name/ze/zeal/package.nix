args@{
  lib,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  httplib,
  libXdmcp,
  libarchive,
  libpthreadstubs,
  pkg-config,
  qt5,
  qt6,
  stdenv,
  xcbutilkeysyms,
}:
let
  zealData = {
    pname = "zeal";
    version = "0.7.2";
    hash = "sha256-9tlo7+namWNWrWVQNqaOvtK4NQIdb0p8qvFrrbUamOo=";
  };

  mkZeal =
    {
      pname,
      version,
      hash,
      flavor,
    }:
    args:
    import ./make-zeal.nix {
      inherit
        pname
        version
        hash
        flavor
        ;
    } args;

  _qt5 =
    mkZeal {
      pname = zealData.pname + "-qt5";
      inherit (zealData) version hash;
      flavor = "qt5";
    } args
    // {
      passthru = {
        inherit flavors;
      };
    };

  _qt6 =
    mkZeal {
      pname = zealData.pname + "-qt6";
      inherit (zealData) version hash;
      flavor = "qt6";
    } args
    // {
      passthru = {
        inherit flavors;
      };
    };

  default = _qt5;

  flavors = {
    qt5 = _qt5;
    qt6 = _qt6;
    inherit default;
  };
in
default
