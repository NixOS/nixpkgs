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
    version = "17.0.13.11.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-17";
      rev = version;
      hash = "sha256-2jMre5aI02uDFjSgToTyVNriyb4EuZ01lKsNi822o5Q=";
    };
  };
in
corretto.overrideAttrs (
  final: prev: {
    # Corretto17 has incorporated this patch already so it fails to apply.
    # We thus skip it here.
    # See https://github.com/corretto/corretto-17/pull/158
    patches = lib.remove (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/openjdk17/FixNullPtrCast.patch?id=41e78a067953e0b13d062d632bae6c4f8028d91c";
      sha256 = "sha256-LzmSew51+DyqqGyyMw2fbXeBluCiCYsS1nCjt9hX6zo=";
    }) (prev.patches or [ ]);
  }
)
