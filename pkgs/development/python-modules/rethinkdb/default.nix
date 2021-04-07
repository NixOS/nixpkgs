{ lib
, buildPythonPackage
, fetchPypi
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f75a72bcd899ab0f6b0677873b89fba99c512bc7895eb5fbc1dc9a228b8aaee";
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
