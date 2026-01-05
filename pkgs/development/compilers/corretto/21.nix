{
  corretto21,
  fetchFromGitHub,
  gradle_7,
  jdk21,
  lib,
  stdenv,
  rsync,
  runCommand,
  testers,
}:

let
  corretto = import ./mk-corretto.nix rec {
    inherit
      lib
      stdenv
      rsync
      runCommand
      testers
      ;
    jdk = jdk21;
    gradle = gradle_7;
    version = "21.0.6.7.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = version;
      hash = "sha256-kF7Quf8bU5scfunmwfEYLkje/jEJOx7CFnBIUWCovzI=";
    };
  };
in
corretto
