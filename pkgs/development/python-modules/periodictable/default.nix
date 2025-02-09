{ lib
, fetchPypi
, buildPythonPackage
, numpy
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "periodictable";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fFAcn3PXex+yjLUehbKEKcLESpnOPRJ0iUVkxy1xJgM=";
  };

  propagatedBuildInputs = [
    numpy
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "periodictable"
  ];

  meta = with lib; {
    description = "Extensible periodic table of the elements";
    homepage = "https://github.com/pkienzle/periodictable";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rprospero ];
  };
}
