{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "pysigma-backend-insightidr";
  version = "0.1.9";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-insightidr";
    rev = "refs/tags/v${version}";
    hash = "sha256-/oHwWe8EcE1CS/hOmzJm9smfRLS/wShfbSGqOuvp8rU=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  pythonRelaxDeps = [
    "pysigma"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.backends.insight_idr"
    "sigma.pipelines.insight_idr"
  ];

  meta = with lib; {
    description = "Library to support the Rapid7 InsightIDR backend for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-insightidr";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
