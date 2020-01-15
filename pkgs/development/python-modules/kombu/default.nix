{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, Pyro4, amqp }:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb365ea795cd7e629ba2f1f398e0c3ba354b91ef4de225ffdf6ab45fdfc7d581";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt --replace "pytest-sugar" ""
  '';

  checkInputs = [ pytest case pytz Pyro4 ];

  propagatedBuildInputs = [ amqp ];

  meta = with lib; {
    description = "Messaging library for Python";
    homepage    = https://github.com/celery/kombu;
    license     = licenses.bsd3;
  };
}
