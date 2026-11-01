{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "ast-serialize";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "ast_serialize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VjMCQnWhthYUK3OXI+9yJUxx2H++i4ex+zX5NTMafdU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jDV0xmlM824Thfb1UdIYum3PEp9z5hC44Qh56gFH3dM=";
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
