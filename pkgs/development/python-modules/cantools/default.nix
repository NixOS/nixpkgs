{ lib
, buildPythonPackage
, fetchPypi
, setuptools
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
  version = "39.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LD0IGSJZG8FhHJ8f9S1sivHQMxT4xyTMEU2FbMVVzCg=";
  };

  nativeBuildInputs = [
    setuptools
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
    description = "Tools to work with CAN bus";
    homepage = "https://github.com/cantools/cantools";
    changelog = "https://github.com/cantools/cantools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gray-heron ];
  };
}
