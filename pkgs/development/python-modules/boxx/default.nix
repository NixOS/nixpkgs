{ lib
, buildPythonPackage
, fetchPypi
, python
, xvfb-run
, matplotlib
, scikitimage
, numpy
, pandas
, imageio
, snakeviz
, fn
, pyopengl
, seaborn
, pytorch
, torchvision
}:

buildPythonPackage rec {
  pname = "boxx";
  version = "0.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xB/bCSIzT0JF5ZPWqSn3P8soBJnzDTfCyan+iOrfWzw=";
  };

  propagatedBuildInputs = [
    matplotlib
    scikitimage
    numpy
    pandas
    imageio
    snakeviz
    fn
    pyopengl
    seaborn
  ];

  pythonImportsCheck = [ "boxx" ];
  checkInputs = [
    xvfb-run
    pytorch
    torchvision
  ];

  checkPhase = ''
    xvfb-run ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "Tool-box for efficient build and debug in Python. Especially for Scientific Computing and Computer Vision.";
    homepage = "https://github.com/DIYer22/boxx";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
