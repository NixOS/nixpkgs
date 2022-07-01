{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s0MjB1dTsUy1cAMWo/0r+wTiO6/h0aOiPQ3d+1pHsyM=";
  };

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "insteon_frontend" ];

  meta = {
    description = "The Insteon frontend for Home Assistant";
    homepage = "https://github.com/teharris1/insteon-panel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
