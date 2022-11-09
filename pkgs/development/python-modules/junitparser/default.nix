{ lib
, buildPythonPackage
, fetchPypi
, future
}:

buildPythonPackage rec {
  pname = "junitparser";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qNQpCrn7k/IBXg2+9h75O36hEOmQmQh6RT9VyOFIGt8=";
  };

  propagatedBuildInputs = [ future ];

  # Pypi release does not include the tests folder
  doCheck = false;

  meta = with lib; {
    description = "Manipulates JUnit/xUnit Result XML files";
    license = licenses.asl20;
    homepage = "https://github.com/weiwei/junitparser";
    maintainers = with maintainers; [ multun ];
  };
}