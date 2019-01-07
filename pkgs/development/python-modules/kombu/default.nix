{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, amqp }:

buildPythonPackage rec {
    pname = "kombu";
    version = "4.2.2.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y5zilg1zd9a6qyd69mli9s9c4dqpwlms7qm1krr7n6570iwm79w";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt --replace "pytest-sugar" ""
  '';

  checkInputs = [ pytest case pytz ];

  propagatedBuildInputs = [ amqp ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = https://github.com/celery/kombu;
    license     = licenses.bsd3;
  };
}
