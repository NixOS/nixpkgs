{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  gevent,
}:

buildPythonPackage (finalAttrs: {
  pname = "grequests";
  version = "0.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "grequests";
    inherit (finalAttrs) version;
    hash = "sha256-XDPxQmjfW4+hEH2FN4Fb5v67rW7FYFJNakBLd3jPa6Y=";
  };

  build-system = [ setuptools ];

  # No tests in archive
  doCheck = false;

  dependencies = [
    requests
    gevent
  ];

  pythonImportsCheck = [ "grequests" ];

  meta = {
    description = "Asynchronous HTTP requests";
    homepage = "https://github.com/kennethreitz/grequests";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ matejc ];
  };
})
