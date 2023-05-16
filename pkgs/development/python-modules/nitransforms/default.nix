{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, h5py
, nibabel
, numpy
, scipy
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "nitransforms";
<<<<<<< HEAD
  version = "23.0.1";
=======
  version = "22.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Lty4aPzSlwRJSqCXeIVICF+gudYqto1OS4cVZyrB2nY=";
=======
    hash = "sha256-iV9TEIGogIfbj+fmOGftoQqEdtZiewbHEw3hYlMEP4c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  buildInputs = [ setuptools-scm toml ];
  propagatedBuildInputs = [ h5py nibabel numpy scipy ];

  pythonRelaxDeps = [ "scipy" ];

  doCheck = false;
  # relies on data repo (https://github.com/nipreps-data/nitransforms-tests);
  # probably too heavy
  pythonImportsCheck = [
    "nitransforms"
    "nitransforms.base"
    "nitransforms.io"
    "nitransforms.io.base"
    "nitransforms.linear"
    "nitransforms.manip"
    "nitransforms.nonlinear"
    "nitransforms.patched"
  ];

  meta = with lib; {
    homepage = "https://nitransforms.readthedocs.io";
    description = "Geometric transformations for images and surfaces";
    changelog = "https://github.com/nipy/nitransforms/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
