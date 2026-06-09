{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-grep-cli";
  version = "0.43.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep";
    tag = finalAttrs.version;
    hash = "sha256-qQkG04aGaw3U/FFP1omlsoAKfNsVKafgJlVzAxvHkcA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-YL76pCvCco9u8nAGIuiEciQrgUgaPx1s8hHyu2x3KmI=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structural search and rewrite code using AST patterns";
    homepage = "https://ast-grep.github.io/";
    changelog = "https://github.com/ast-grep/ast-grep/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ch4s3r ];
    mainProgram = "sg";
  };
})
