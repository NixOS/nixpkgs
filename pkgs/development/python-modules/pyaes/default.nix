{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pyaes";
  version = "1.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AsGxQFw408NwsIX7lS3YvqP63O5kEa2Z8xLMEpxTbY8=";
  };

  meta = {
    description = "Pure-Python AES";
    license = lib.licenses.mit;
    homepage = "https://github.com/ricmoo/pyaes";
  };
}
