{ corretto17
, fetchFromGitHub
, gradle_7
, jdk17
, lib
, stdenv
, rsync
, runCommand
, testers
}:

let
  corretto = import ./mk-corretto.nix {
    inherit lib stdenv rsync runCommand testers;
    jdk = jdk17;
    gradle = gradle_7;
    version = "17.0.8.8.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-17";
      rev = "9a3cc984f76cb5f90598bdb43215bad20e0f7319";
      sha256 = "sha256-/VuB3ocD5VvDqCU7BoTG+fQ0aKvK1TejegRYmswInqQ=";
    };
  };
in
corretto
