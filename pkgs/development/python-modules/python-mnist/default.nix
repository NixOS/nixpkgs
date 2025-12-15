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
    sha256 = "a0cced01e83b5b844cff86109280df7a672a8e4e38fc19fa68999a17f8a9fbd8";
  };

  meta = {
    homepage = "https://github.com/sorki/python-mnist";
    description = "Simple MNIST data parser written in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
}
