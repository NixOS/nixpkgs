{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "amqplib";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tgz";
    hash = "sha256-hD1ptoGmCv0h+/UPMQQE7Gf8350T389unUHztFYhfls=";
  };

  # testing assumes network connection
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} tests/client_0_8/run_all.py
  '';

  meta = with lib; {
    homepage = "https://github.com/barryp/py-amqplib";
    description = "Python client for the Advanced Message Queuing Procotol (AMQP)";
    license = licenses.lgpl21;
  };
}
