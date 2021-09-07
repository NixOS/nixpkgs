{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67731d050472923581c43a39a8f01567468e8b3c8e83465b762c99eb0e5e23bc";
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
