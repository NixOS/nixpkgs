{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VpngJvm9eK60lPeFIbjnTwzWWoJ9tRBDYP5SghDMbAg=";
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
