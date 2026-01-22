{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "chacha20poly1305";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8vAFx89GOP+k/wbALHh0gGi2QpFnlcbRbHzF41XnDt8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "chacha20poly1305" ];

  meta = {
    description = "Module that implements ChaCha20Poly1305";
    homepage = "https://github.com/ph4r05/py-chacha20poly1305";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
