{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9/Qchdw+HC09k17IZmDcOyyEjIPhf5qeUbqdUUahWFk=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "geographiclib" ];

  meta = {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
