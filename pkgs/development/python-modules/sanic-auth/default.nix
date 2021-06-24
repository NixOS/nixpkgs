{ lib, buildPythonPackage, fetchPypi, sanic, pytestCheckHook }:

buildPythonPackage rec {
  pname = "Sanic-Auth";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dc24ynqjraqwgvyk0g9bj87zgpq4xnssl24hnsn7l5vlkmk8198";
  };

  propagatedBuildInputs = [ sanic ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sanic_auth" ];

  meta = with lib; {
    description = "Simple Authentication for Sanic";
    homepage = "https://github.com/pyx/sanic-auth/";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
