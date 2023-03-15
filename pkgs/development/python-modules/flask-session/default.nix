{ lib, fetchPypi, buildPythonPackage, pytestCheckHook, flask, cachelib }:

buildPythonPackage rec {
  pname = "Flask-Session";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ye1UMh+oxMoBMv/TNpWCdZ7aclL7SzvuSA5pDRukH0Y=";
  };

  propagatedBuildInputs = [ flask cachelib ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The rest of the tests require database servers and optional db connector dependencies
  pytestFlagsArray = [ "-k" "'null_session or filesystem_session'" ];

  pythonImportsCheck = [ "flask_session" ];

  meta = with lib; {
    description = "A Flask extension that adds support for server-side sessions";
    homepage = "https://github.com/fengsp/flask-session";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
