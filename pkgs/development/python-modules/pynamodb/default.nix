{ lib
, buildPythonPackage
, botocore
, fetchPypi
, mock
, mypy
, python-dateutil
, pytest
, requests
}:

buildPythonPackage rec {
  pname = "pynamodb";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cwgqvpqn59y3zq4wv35m1v4jrh3ih6zbyv30g5nxbw13vddxr92";
  };

  propagatedBuildInputs = [ python-dateutil botocore ];
  checkInputs = [ requests mock pytest mypy ];

  meta = with lib; {
    description = "A Pythonic interface for Amazon’s DynamoDB that supports Python 2 and 3.";
    longDescription = ''
      DynamoDB is a great NoSQL service provided by Amazon, but the API is
      verbose. PynamoDB presents you with a simple, elegant API.
    '';
    homepage = "http://jlafon.io/pynamodb.html";
    license = licenses.mit;
  };
}
