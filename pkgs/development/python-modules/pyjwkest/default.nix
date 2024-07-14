{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  pycryptodomex,
  pytest,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "pyjwkest";
  version = "1.4.2";
  format = "setuptools";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = "https://github.com/rohe/pyjwkest";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VWD9W6CGVfKf9q0d8eFdwFq8nZdvy87I0rUWf0m3AiI=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [
    future
    pycryptodomex
    requests
    six
  ];
}
