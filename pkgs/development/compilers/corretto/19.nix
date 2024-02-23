{ fetchFromGitHub
, jdk19
, lib
, stdenv
, autoconf
, gradle_7
, rsync
, runCommand
, testers
, which
, xcbuild
}:

let
  corretto = import ./mk-corretto.nix {
    inherit lib stdenv autoconf rsync runCommand testers which xcbuild;
    jdk = jdk19;
    gradle = gradle_7;
    version = "19.0.2.7.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-19";
      rev = "72f064a1d716272bd17d4e425d4a264b2c2c7d36";
      sha256 = "sha256-mEj/MIbdXU0+fF5RhqjPuSeyclstesGaXB0e48YlKuw=";
    };
  };
in
corretto
