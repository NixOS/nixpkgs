{
  fetchFromGitHub,
  gradle_9,
  jdk25,
  lib,
  stdenv,
  rsync,
  pandoc,
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
    jdk = jdk25;
    gradle = gradle_9;
    version = "25.0.1.9.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-25";
      rev = version;
      hash = "sha256-eAjepqxp5LVQgP/HcxwwdjbXxy5jUOJC4HYntcHNX0o=";
    };
    extraNativeBuildInputs = [ pandoc ];
  };
in
corretto.overrideAttrs (
  final: prev: {
    patches = (prev.patches or [ ]) ++ [
      # See patches in openjdk/generic.nix.
      ./remove_removal_of_wformat_during_test_compilation.patch
    ];
  }
)
