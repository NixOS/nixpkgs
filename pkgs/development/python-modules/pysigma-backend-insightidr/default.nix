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
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-insightidr";
    rev = "refs/tags/v${version}";
    hash = "sha256-wQMnnJ0KU+53MS3PIBkwIhUiyUdCrDbdUT6upk2Pp/8=";
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
