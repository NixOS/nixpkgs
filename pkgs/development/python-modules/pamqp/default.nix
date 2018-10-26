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
  version = "1.6.1";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vmyvynqzx5zvbipaxff4fnzy3h3dvl3zicyr15yb816j93jl2ca";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with stdenv.lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = https://pypi.python.org/pypi/pamqp;
    license = licenses.bsd3;
  };

}
