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

buildPythonPackage rec {
  pname = "fast-query-parsers";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "fast-query-parsers";
    tag = "v${version}";
    hash = "sha256-08xL0sOmUzsZYtM1thYUV93bj9ERr3LaVrW46zBrzeE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kp5bCmHYMS/e8eM6HrRw0JlVaxwPscFGDLQ0PX4ZIC4=";
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
    changelog = "https://github.com/litestar-org/fast-query-parsers/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
