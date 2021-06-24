{ lib, buildPythonPackage, fetchPypi, python, requests, six }:

with lib;
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a4a5f4a61c49f098f5f669410308ac5b0ea2682fd511ee3a4f9ff73b5bb275a";
  };

  propagatedBuildInputs = [ requests six ];

  # pypi package no longer contains tests
  doCheck = false;
  checkPhase = ''
    cd requests_aws4auth
    ${python.interpreter} test/requests_aws4auth_test.py
  '';

  pythonImportsCheck = [ "requests_aws4auth" ];

  meta = {
    description = "Amazon Web Services version 4 authentication for the Python Requests library.";
    homepage = "https://github.com/sam-washington/requests-aws4auth";
    license = licenses.mit;
    maintainers = [ maintainers.basvandijk ];
  };
}
