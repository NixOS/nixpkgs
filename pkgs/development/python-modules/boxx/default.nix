{
  lib,
  buildPythonPackage,
  fetchPypi,
  imageio,
  matplotlib,
  numpy,
  pandas,
  pyopengl,
  scikit-image,
  seaborn,
  snakeviz,
}:

buildPythonPackage rec {
  pname = "boxx";
  version = "0.10.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-unGnmPksEuqFXHTWJkj9Gv2G/qPDgT6AZXYiG2gtkEA=";
  };

  propagatedBuildInputs = [
    imageio
    matplotlib
    numpy
    pandas
    pyopengl
    scikit-image
    seaborn
    snakeviz
  ];

  pythonImportsCheck = [ "boxx" ];

  meta = with lib; {
    description = "Tool-box for efficient build and debug for Scientific Computing and Computer Vision";
    homepage = "https://github.com/DIYer22/boxx";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
