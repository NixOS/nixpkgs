{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, Pyro4, amqp }:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9078124ce2616b29cf6607f0ac3db894c59154252dee6392cdbbe15e5c4b566";
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
