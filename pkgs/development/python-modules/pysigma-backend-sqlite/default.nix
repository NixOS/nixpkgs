{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-sqlite";
  version = "0.2.0-unstable-2025-01-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-sqlite";
    rev = "865350ce1a398acd7182f6f8429c3048db54ef1d";
    hash = "sha256-NBgpLP3/UUrW/qM24jUyV4MH5c/uCVAfInZ6AKcl1X0=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sigma.backends.sqlite" ];

  meta = {
    description = "Library to support sqlite for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-sqlite";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-sqlite/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
