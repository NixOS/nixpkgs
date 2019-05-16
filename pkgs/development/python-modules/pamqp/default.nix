{ stdenv
, buildPythonPackage
, fetchPypi
, mock
, nose
, pep8
, pylint
, mccabe
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1fa1107a195993fca6e04f1eb7286b60e223c958944d7808a501258ccc0ef8c";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with stdenv.lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = https://pypi.python.org/pypi/pamqp;
    license = licenses.bsd3;
  };

}
