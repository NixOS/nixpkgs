{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-language-server";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "elm-tooling";
    repo = "elm-language-server";
    tag = finalAttrs.version;
    hash = "sha256-S+g5I7HlVvs1Z5xR9uJdZcTCreufEq/nujtJXY6y53o=";
  };

  npmDepsHash = "sha256-jItCa+WRWpI3qWPvz/XcqpIHAGmtp+BLAFUJ0YQk194=";

  npmBuildScript = "compile";

  npmFlags = [ "--ignore-scripts" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/elm-tooling/elm-language-server/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Language server implementation for Elm";
    mainProgram = "elm-language-server";
    homepage = "https://github.com/elm-tooling/elm-language-server";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
