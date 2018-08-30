{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, amqp }:

buildPythonPackage rec {
    pname = "kombu";
    version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86adec6c60f63124e2082ea8481bbe4ebe04fde8ebed32c177c7f0cd2c1c9082";
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
