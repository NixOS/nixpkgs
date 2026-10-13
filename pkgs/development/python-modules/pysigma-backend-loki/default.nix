{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma-backend-loki";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pySigma-backend-loki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/xci4LKDCbT9vDG/ldFUL32y3r4tXUM0g6dSE0TVHpw=";
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
})
