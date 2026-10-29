{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-loki";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pySigma-backend-loki";
    tag = "v${version}";
    hash = "sha256-36fdFuvUSAeGyV5z55/MGcdMiCNz12EbiRw87MjmaKY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  pythonRelaxDeps = [ "pysigma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.backends.loki" ];

  disabledTestPaths = [
    # Tests are out-dated
    "tests/test_backend_loki_field_modifiers.py"
  ];

  meta = {
    description = "Library to support the loki backend for pySigma";
    homepage = "https://github.com/grafana/pySigma-backend-loki";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
