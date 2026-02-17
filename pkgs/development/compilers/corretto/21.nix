{
  fetchFromGitHub,
  gradle_8,
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
    gradle = gradle_8;
    version = "21.0.9.11.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-21";
      rev = version;
      hash = "sha256-d62rXVgVlOM3M18c8GioFtMi/GhmCEMLQwy/EWAJW7I=";
    };
  };
in
corretto.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    ./corretto21-gradle8.patch
  ];

})
