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
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58bd62089741ef689f845d6ca826ab50e39b9a0a8ae3bd7a84dc167c1a4ec8fa";
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
