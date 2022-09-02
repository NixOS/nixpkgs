{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
, exceptiongroup
, pexpect
, doCheck ? true
, pytestCheckHook
, pytest-xdist
, sortedcontainers
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hypothesis";
  version = "6.50.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "hypothesis-python-${version}";
    hash = "sha256-G7OXlYaCPBfdXtmX/f/6i2LRCZZk5yvzhLc6sissuRo=";
  };

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  propagatedBuildInputs = [
    attrs
    sortedcontainers
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  checkInputs = [
    pexpect
    pytest-xdist
    pytestCheckHook
  ];

  inherit doCheck;

  # This file changes how pytest runs and breaks it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlagsArray = [
    "tests/cover"
  ];

  pythonImportsCheck = [
    "hypothesis"
  ];

  meta = with lib; {
    description = "Library for property based testing";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
