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
, torch
, pythonOlder
, torchvision
}:

buildPythonPackage rec {
  pname = "boxx";
  version = "0.10.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OPbqCsTZZskZOJMcK1OJsG3Qgx4K0X217g5pNWQZDAM=";
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
    torch
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
