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
  version = "2.0.0";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "701b0c41b68eb86bad6f111658917992780d56a3f094a6cad87ef217afa8296d";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with stdenv.lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = https://pypi.python.org/pypi/pamqp;
    license = licenses.bsd3;
  };

}
