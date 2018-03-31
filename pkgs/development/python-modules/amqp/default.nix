{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ybywzkd840v1qvb1p2bs08js260vq1jscjg8182hv7bmwacqy0k";
  };

  buildInputs = [ pytest case ];
  propagatedBuildInputs = [ vine ];

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/py-amqp;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
