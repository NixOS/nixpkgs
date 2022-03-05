{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, h5py
, nibabel
, numpy
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "nitransforms";
  version = "22.0.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iV9TEIGogIfbj+fmOGftoQqEdtZiewbHEw3hYlMEP4c=";
  };

  buildInputs = [ setuptools-scm toml ];
  propagatedBuildInputs = [ h5py nibabel numpy ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
