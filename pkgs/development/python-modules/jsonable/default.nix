{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonable";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "halfak";
    repo = "python-jsonable";
    rev = "refs/tags/${version}";
    hash = "sha256-3FIzG2djSZOPDdoYeKqs3obQjgHrFtyp0sdBwZakkHA=";
  };

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jsonable" ];

  meta = with lib; {
    description = "Provides an abstract base class and utilities for defining trivially JSONable python objects";
    homepage = "https://github.com/halfak/python-jsonable";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
