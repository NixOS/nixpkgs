{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "ast_serialize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R5hNpbJjKKZDOKQCdGZQ+0iW5vdh5CzSgzORESh4bDU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-uhUMaUkaL57X8CVy6T9pCQa62IsOeKN/dhZTPVXSn14=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
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
