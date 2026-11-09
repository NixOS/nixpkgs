{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  opencv-python,
  scikit-learn,
  setuptools_80,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "qudida";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2xmOKIerDJqgAj5WWvv/Qd+3azYfhf1eE/eA11uhjMg=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [
    numpy
    opencv-python
    scikit-learn
    typing-extensions
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "qudida" ];

  meta = {
    description = "QUick and DIrty Domain Adaptation";
    homepage = "https://github.com/arsenyinfo/qudida";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
