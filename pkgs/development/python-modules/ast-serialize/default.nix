{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "ast_serialize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GmhbMraI16J6ePtn7lXAWaJ+9zDH1GdebKIAzm5w9ok=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-h+BklNeoQaRVWczsE9sFXgvFrnHW5vjWOVaOvLghv0U=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [
    "ast_serialize"
  ];

  meta = {
    description = "Fast Python parser that generates a serialized AST";
    homepage = "https://github.com/mypyc/ast_serialize";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
