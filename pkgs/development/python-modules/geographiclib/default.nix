{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "2.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9/Qchdw+HC09k17IZmDcOyyEjIPhf5qeUbqdUUahWFk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geographiclib" ];

  meta = with lib; {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
