{
  fetchFromGitHub,
  gradle_8,
  jdk11,
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
    jdk = jdk11;
    gradle = gradle_8;
    version = "11.0.30.7.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-11";
      rev = version;
      hash = "sha256-SUdJlTYE+RRAZa8DhFW0EYW1kHmuNDG+hk+/3MXtx1w=";
    };
  };
in
corretto.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    ./corretto11-gradle8.patch
  ];

})
