{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geographiclib";
  version = "1.52";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rEANZyuJVLAwa8qJCwiLuLoqdX3IEzzKC4ePNLM7J0A=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geographiclib" ];

  meta = with lib; {
    homepage = "https://geographiclib.sourceforge.io";
    description = "Algorithms for geodesics (Karney, 2013) for solving the direct and inverse problems for an ellipsoid of revolution";
    license = licenses.mit;
  };
}
