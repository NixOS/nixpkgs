{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vez3RH3BH+wOLOmqxLpMC1f9xcnFfXfuZz1Z0kXHRmY=";
  };

  propagatedBuildInputs = [ six setuptools ];

  doCheck = false;
  pythonImportsCheck = [ "rethinkdb" ];

  meta = with lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://pypi.python.org/pypi/rethinkdb";
    license = licenses.asl20;
  };

}
