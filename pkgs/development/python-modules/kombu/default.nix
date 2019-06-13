{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, Pyro4, amqp }:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "389ba09e03b15b55b1a7371a441c894fd8121d174f5583bbbca032b9ea8c9edd";
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
