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
    version = "21.0.5.11.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = version;
      hash = "sha256-Df2Pq2aPrTxD4FeqG12apE/USfQULmMGsDsgXrmCINc=";
    };
  };
in
corretto
