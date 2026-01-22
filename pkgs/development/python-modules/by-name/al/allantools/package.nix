{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  matplotlib,
  numpy,
  numpydoc,
  pytest,
  scipy,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "allantools";
  version = "2024.06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aewallin";
    repo = "allantools";
    tag = version;
    hash = "sha256-dF19aSpIioOm0BnwrLkMe/DtfgWSKFnX4c/Xs1O2Quw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    matplotlib
    numpy
    numpydoc
    pytest
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "allantools"
  ];

  meta = {
    description = "Allan deviation and related time & frequency statistics library in Python";
    homepage = "https://github.com/aewallin/allantools";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ kiranshila ];
  };
}
