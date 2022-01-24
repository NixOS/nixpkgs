{ lib
, buildPythonPackage
, fetchPypi
, mock
, nose
, pep8
, pylint
, mccabe
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4f0886d72c6166637a5513626148bf5a7e818073a558980e9aaed8b4ccf30da";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = "https://pypi.python.org/pypi/pamqp";
    license = licenses.bsd3;
  };

}
