{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "087a7d5d2af9fd8ce5da70d29e4b456c6b8b0ea3cd16613ed50f6eb8ad6cdba6";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require nomad agent
  doCheck = false;

  pythonImportsCheck = [ "nomad" ];

  meta = with lib; {
    description = "Python client library for Hashicorp Nomad";
    homepage = "https://github.com/jrxFive/python-nomad";
    license = licenses.mit;
    maintainers = with maintainers; [ xbreak ];
  };
}
