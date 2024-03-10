{ lib
, buildPythonPackage
, fetchPypi
, looseversion
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "rethinkdb";
  version = "2.4.10.post1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NjTgPuE91jf9cZa4BHS/RMZNProd0GnqkrlJJnAqYL0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    looseversion
    six
  ];

  doCheck = false;

  pythonImportsCheck = [ "rethinkdb" ];

  meta = with lib; {
    description = "Python driver library for the RethinkDB database server";
    homepage = "https://github.com/RethinkDB/rethinkdb-python";
    license = licenses.asl20;
  };

}
