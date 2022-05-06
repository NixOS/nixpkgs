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
, pythonOlder
, torchvision
}:

buildPythonPackage rec {
  pname = "boxx";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1Q6wCloOCfyDmvC8VbK6GgfnxuliJ6Ze7UEvsNFBVa0=";
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

  checkInputs = [
    xvfb-run
    pytorch
    torchvision
  ];

  pythonImportsCheck = [
    "boxx"
  ];

  checkPhase = ''
    xvfb-run ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "Tool-box for efficient build and debug for Scientific Computing and Computer Vision";
    homepage = "https://github.com/DIYer22/boxx";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
