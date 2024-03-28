{ fetchFromGitHub
, jdk17
, lib
, stdenv
, autoconf
, gradle_7
, rsync
, runCommand
, testers
, which
, xcbuild
, zip
, coreutils
, darwin
}:

let
  corretto = import ./mk-corretto.nix {
    inherit lib stdenv autoconf rsync runCommand testers which xcbuild zip coreutils darwin;
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
