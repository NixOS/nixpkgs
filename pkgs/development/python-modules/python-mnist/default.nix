{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-mnist";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oMztAeg7W4RM/4YQkoDfemcqjk44/Bn6aJmaF/ip+9g=";
  };

  meta = with lib; {
    homepage = "https://github.com/sorki/python-mnist";
    description = "Simple MNIST data parser written in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
