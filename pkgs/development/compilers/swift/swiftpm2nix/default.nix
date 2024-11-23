{
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  jq,
  nix-prefetch-git,
  nixVersions,
}:

let
  # https://github.com/NixOS/nix/issues/11681
  nix-prefetch-git' = nix-prefetch-git.override { nix = nixVersions.nix_2_19; };
in
stdenv.mkDerivation {
  name = "swiftpm2nix";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./swiftpm2nix.sh} $out/bin/swiftpm2nix
    wrapProgram $out/bin/$name \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          nix-prefetch-git'
        ]
      } \
  '';

  preferLocalBuild = true;

  passthru = callPackage ./support.nix { };

  meta = {
    description = "Generate a Nix expression to fetch swiftpm dependencies";
    mainProgram = "swiftpm2nix";
    maintainers = lib.teams.swift.members;
    platforms = lib.platforms.all;
  };
}
