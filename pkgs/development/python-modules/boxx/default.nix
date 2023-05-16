{ lib
, buildPythonPackage
, fetchPypi
, python
, xvfb-run
, matplotlib
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.10.10";
=======
  version = "0.10.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-7A5qFpISrjVrqQfKk6BPb7RhDWd9f90eF3bku+LsCcc=";
=======
    hash = "sha256-uk4DYmbV/4zSyL2QzlAJLvgC6ieBjP/xkuyDktUEmIo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    matplotlib
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    numpy
    pandas
    imageio
    snakeviz
    fn
    pyopengl
    seaborn
  ];

  nativeCheckInputs = [
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
