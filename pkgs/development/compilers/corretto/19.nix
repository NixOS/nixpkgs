{ corretto19
, fetchFromGitHub
, gradle_7
, jdk19
, lib
, stdenv
, rsync
, runCommand
, testers
}:

let
  corretto = import ./mk-corretto.nix rec {
    inherit lib stdenv rsync runCommand testers;
    jdk = jdk19;
    gradle = gradle_7;
    version = "19.0.2.7.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-19";
      rev = version;
      sha256 = "sha256-mEj/MIbdXU0+fF5RhqjPuSeyclstesGaXB0e48YlKuw=";
    };
  };
in
corretto
