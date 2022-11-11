{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "patiencediff";
  version = "0.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oJOsqZ9XCbYHJ7VEbDpC9wquCkvfj05M0nerlV5jL7w=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "patiencediff"
  ];

  meta = with lib; {
    description = "C implementation of patiencediff algorithm for Python";
    homepage = "https://github.com/breezy-team/patiencediff";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wildsebastian ];
  };
}
