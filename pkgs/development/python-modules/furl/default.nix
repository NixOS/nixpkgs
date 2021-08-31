{ lib
, buildPythonPackage
, fetchPypi
, flake8
, orderedmultidict
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "furl";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-99ujPq++59vIOWNTSyXnL4FsztSKxTGR7mC/zGKTORg=";
  };

  propagatedBuildInputs = [
    orderedmultidict
    six
  ];

  checkInputs = [
    flake8
    pytestCheckHook
  ];

  pythonImportsCheck = [ "furl" ];

  meta = with lib; {
    description = "Python library that makes parsing and manipulating URLs easy";
    homepage = "https://github.com/gruns/furl";
    license = licenses.unlicense;
    maintainers = with maintainers; [ vanzef ];
  };
}
