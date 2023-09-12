{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, argparse-addons
, bitstruct
, can
, crccheck
, diskcache
, matplotlib
, parameterized
, pytestCheckHook
, pythonOlder
, textparser
}:

buildPythonPackage rec {
  pname = "cantools";
  version = "38.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k7/m9L1lLzaXY+qRYrAnpi9CSoQA8kI9QRN5GM5oxo4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    argparse-addons
    bitstruct
    can
    crccheck
    diskcache
    matplotlib
    textparser
  ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cantools"
  ];

  meta = with lib; {
    homepage = "https://github.com/cantools/cantools";
    description = "CAN bus tools.";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
  };
}
