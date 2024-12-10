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
  corretto = import ./mk-corretto.nix {
    inherit
      lib
      stdenv
      rsync
      runCommand
      testers
      ;
    jdk = jdk21;
    gradle = gradle_7;
    version = "21.0.3.9.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = "97b366227b4dc8f5a89bbedea88b0b18c9e21886";
      sha256 = "sha256-V8UDyukDCQVTWUg4IpSKoY0qnnQ5fePbm3rxcw06Vr0=";
    };
  };
in
corretto
