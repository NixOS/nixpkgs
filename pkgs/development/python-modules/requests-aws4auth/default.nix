{ lib, buildPythonPackage, fetchPypi, requests }:
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g52a1pm53aqkc9qb5q1m918c1qy6q47c1qz63p5ilynfbs3m5y9";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    description = "Amazon Web Services version 4 authentication for the Python Requests library.";
    homepage = https://github.com/sam-washington/requests-aws4auth;
    license = licenses.mit;
    maintainers = [ maintainers.basvandijk ];
  };
}
