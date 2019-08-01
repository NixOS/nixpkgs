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
  version = "2.3.0";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s4lwbsiikz3czqad7jarb7k303q0wamla0rirghvwl9bslgbl2w";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with stdenv.lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = https://pypi.python.org/pypi/pamqp;
    license = licenses.bsd3;
  };

}
