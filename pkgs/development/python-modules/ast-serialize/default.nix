{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "ast_serialize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7MNtry/GDUpjuh/rMB+R4wAQpPAG/yLNGqH4tEyK7tw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iw1qkQoagmS+8e9znEEo4EZocu+ECL4c+egBY2TOrk0=";
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
