{ lib, buildPythonPackage, fetchPypi, python, requests, six }:

with lib;
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0883346ce30b5018903a67da88df72f73ff06e1a320845bba9cd85e811ba0ba";
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
