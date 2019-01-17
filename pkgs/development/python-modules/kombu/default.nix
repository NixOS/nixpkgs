{ lib, buildPythonPackage, fetchPypi, pytest, case, pytz, amqp }:

buildPythonPackage rec {
    pname = "kombu";
    version = "4.2.2.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c9dca2338c5d893f30c151f5d29bfb81196748ab426d33c362ab51f1e8dbf78";
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
