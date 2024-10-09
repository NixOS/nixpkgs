{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  opencv4,
  pythonOlder,
  scikit-learn,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "qudida";
  version = "0.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2xmOKIerDJqgAj5WWvv/Qd+3azYfhf1eE/eA11uhjMg=";
  };


  pythonRemoveDeps = [ "opencv-python" ];

  propagatedBuildInputs = [
    numpy
    opencv4
    scikit-learn
    typing-extensions
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "qudida" ];

  meta = with lib; {
    description = "QUick and DIrty Domain Adaptation";
    homepage = "https://github.com/arsenyinfo/qudida";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
