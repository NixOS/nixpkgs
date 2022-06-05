{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70ee413cae8717416f5add1be7647158d8ff4303942dafccac0792ef44336cdf";
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
