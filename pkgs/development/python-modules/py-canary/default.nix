{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "py-canary";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "snjoetw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PE31J82Uc6mErnh7nQ1pkIjnMbuCnlYEX2R0azknMHQ=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "canary"
  ];

  meta = with lib; {
    description = "Python package for Canary Security Camera";
    homepage = "https://github.com/snjoetw/py-canary";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
