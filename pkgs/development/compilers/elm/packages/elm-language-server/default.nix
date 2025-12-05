{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-language-server";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "elm-tooling";
    repo = "elm-language-server";
    tag = finalAttrs.version;
    hash = "sha256-OU6VoMu5Qnawxt02vT0B/37VipiBzlLBlZbQbnu8PEE=";
  };

  npmDepsHash = "sha256-jb59LiP2EZpTkc4o/t+9j287W01tDgbwFpAsWZCCL/k=";

  npmBuildScript = "compile";

  npmFlags = [ "--ignore-scripts" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/elm-tooling/elm-language-server/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Language server implementation for Elm";
    mainProgram = "elm-language-server";
    homepage = "https://github.com/elm-tooling/elm-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
