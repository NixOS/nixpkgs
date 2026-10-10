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

  patches = [
    # https://github.com/ricmoo/pyaes/issues/56
    # https://blog.trailofbits.com/2026/02/18/carelessness-versus-craftsmanship-in-cryptography/
    ./default-iv.patch
  ];

  meta = {
    description = "Pure-Python AES";
    license = lib.licenses.mit;
    homepage = "https://github.com/ricmoo/pyaes";
  };
}
