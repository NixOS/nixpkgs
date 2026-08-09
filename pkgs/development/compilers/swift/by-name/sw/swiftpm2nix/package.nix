{
  lib,
  stdenv,
  callPackage,
  makeWrapper,
  jq,
  nurl,
}:

stdenv.mkDerivation {
  name = "swiftpm2nix";

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./swiftpm2nix.sh} $out/bin/swiftpm2nix
    wrapProgram $out/bin/$name \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          nurl
        ]
      }
  '';

  preferLocalBuild = true;

  passthru = callPackage ./support.nix { };

  __structuredAttrs = true;

  meta = {
    description = "Generate a Nix expression to fetch swiftpm dependencies";
    mainProgram = "swiftpm2nix";
    teams = [ lib.teams.swift ];
    platforms = lib.platforms.all;
  };
}
