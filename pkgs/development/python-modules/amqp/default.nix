{ stdenv, buildPythonPackage, fetchPypi, pytest, case, vine, pytest-sugar }:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j1046gcriidsfha0hvrw6hwcm0wrhbvg0prjjji5inaadyzidnb";
  };

  checkInputs = [ pytest case pytest-sugar ];
  propagatedBuildInputs = [ vine ];

  # Disable because pytest-sugar requires an old version of pytest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/celery/py-amqp;
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    license = licenses.lgpl21;
  };
}
