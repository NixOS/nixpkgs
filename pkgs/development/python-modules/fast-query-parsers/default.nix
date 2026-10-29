{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "fast-query-parsers";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "fast-query-parsers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gxKySLbBtX/6bXuTtiFw50UhmUwZE8lDaQ5P/g09Qnk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-eMZBKG5j9v3EVVwa7ooZcuIZK5ljeyc+2k1dw3O/TcQ=";
  };

  build-system = [
    cargo
    poetry-core
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fast_query_parsers" ];

  meta = {
    description = "Ultra-fast query string and url-encoded form-data parsers";
    homepage = "https://github.com/litestar-org/fast-query-parsers";
    changelog = "https://github.com/litestar-org/fast-query-parsers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
