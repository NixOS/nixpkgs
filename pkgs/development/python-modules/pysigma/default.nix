{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pyparsing
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysigma";
  version = "0.6.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "refs/tags/v${version}";
    hash = "sha256-Jq37/9w1GHr+GZ8Fvftmfz2XkL3zUpTjbDlokrUoLtw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyparsing
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma"
  ];

  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
