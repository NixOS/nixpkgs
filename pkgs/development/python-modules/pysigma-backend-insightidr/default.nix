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
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-insightidr";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-B42MADteF0+GC/CPJPLaTGdGcQjC8KEsK9u3tBmtObg=";
=======
    hash = "sha256-3Tr6WvYuHddc0vGb8li6hZLk2GgfXr67/T2AnYQ7qeo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
