{ fetchFromGitHub
, gradle_7
, jdk21
, lib
, stdenv
, rsync
, runCommand
, testers
}:

let
  corretto = import ./mk-corretto.nix rec {
    inherit lib stdenv rsync runCommand testers;
    jdk = jdk21;
    gradle = gradle_7;
    version = "21.0.2.13.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = version;
      sha256 = "sha256-MFYbdacRxmaeKxaae61/A3gOZVgmiaPbyK2jolDTcvM=";
    };
  };
in
corretto
