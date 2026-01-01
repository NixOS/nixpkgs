{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "chacha20poly1305";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8vAFx89GOP+k/wbALHh0gGi2QpFnlcbRbHzF41XnDt8=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "chacha20poly1305" ];

<<<<<<< HEAD
  meta = {
    description = "Module that implements ChaCha20Poly1305";
    homepage = "https://github.com/ph4r05/py-chacha20poly1305";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Module that implements ChaCha20Poly1305";
    homepage = "https://github.com/ph4r05/py-chacha20poly1305";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
