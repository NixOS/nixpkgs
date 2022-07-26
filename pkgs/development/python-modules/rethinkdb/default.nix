{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dV8I9xdTWlXAUSj2vmwoJI+pr/JningWqrh+H59YFcE=";
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
