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
  version = "3.0.1";
  pname = "pamqp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a9b49bde3f554ec49b47ebdb789133979985f24d5f4698935ed589a2d4392a4";
  };

  buildInputs = [ mock nose pep8 pylint mccabe ];

  meta = with lib; {
    description = "RabbitMQ Focused AMQP low-level library";
    homepage = "https://pypi.python.org/pypi/pamqp";
    license = licenses.bsd3;
  };

}
