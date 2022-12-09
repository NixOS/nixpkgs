{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AlJ61Sp6HSy6nJ6trVF2OD9ziSIW241peRXcda3xWnQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "patiencediff"
  ];

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    changelog = "https://github.com/breezy-team/patiencediff/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wildsebastian ];
  };
}
