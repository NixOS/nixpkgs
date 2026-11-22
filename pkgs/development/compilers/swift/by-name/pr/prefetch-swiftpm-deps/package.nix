{
  lib,
  stdenv,
  binutils,
  coreutils,
  curl,
  findutils,
  gnugrep,
  jq,
  nix,
  nix-prefetch-git,
  swift,
  swiftpm,
  unzip,
  writeShellApplication,
}:

writeShellApplication {
  name = "prefetch-swiftpm-deps";
  runtimeInputs = [
    coreutils
    curl
    findutils
    gnugrep
    jq
    nix
    nix-prefetch-git
    swift
    swiftpm
    unzip
  ]
  # SwiftPM needs ar on Linux
  ++ lib.optional stdenv.hostPlatform.isLinux binutils;
  text = builtins.readFile ./prefetch-swiftpm-deps.sh;
}
