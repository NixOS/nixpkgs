{
  lib,
  buildPythonPackage,
  fetchPypi,
  gevent,
  gunicorn,
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fq7zKWgpDJEh98Nblz4swwL/sHbQGMkGjS9cqLLYX7A=";
  };

  propagatedBuildInputs = [
    gevent
    gunicorn
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "geventwebsocket" ];

  meta = {
    description = "Websocket handler for the gevent pywsgi server";
    homepage = "https://www.gitlab.com/noppo/gevent-websocket";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
