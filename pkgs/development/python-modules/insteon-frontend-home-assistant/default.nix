{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "insteon-frontend-home-assistant";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AP8yf2eEBT8LWs03hKihCgbBkS9sEUg5NkYdagFiqwA=";
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
