{
  fetchFromGitHub,
  fetchurl,
  gradle_7,
  jdk17,
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
    jdk = jdk17;
    gradle = gradle_7;
    version = "17.0.11.9.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-17";
      rev = version;
      sha256 = "sha256-LxZSFILFfyh8oBiYEnuBQ0Og2i713qdK2jIiCBnrlj0=";
    };
  };
in
corretto.overrideAttrs (
  final: prev: {
    # HACK: Removes the FixNullPtrCast patch, as it fails to apply. Need to figure out what causes it to fail to apply.
    patches = lib.remove (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/openjdk17/FixNullPtrCast.patch?id=41e78a067953e0b13d062d632bae6c4f8028d91c";
      sha256 = "sha256-LzmSew51+DyqqGyyMw2fbXeBluCiCYsS1nCjt9hX6zo=";
    }) (prev.patches or [ ]);
  }
)
