{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-language-server";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "elm-tooling";
    repo = "elm-language-server";
    tag = finalAttrs.version;
    hash = "sha256-HwTkmhA3C3ByVoVq7QtQQoAraH/jRcljooobp6Ao8Ko=";
  };

  npmDepsHash = "sha256-hj7Y0wUORN42OO4YtsZjMfivmmEMYdMyLIoAGK9jcis=";

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
