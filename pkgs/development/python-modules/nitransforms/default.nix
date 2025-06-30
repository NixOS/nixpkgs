{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  h5py,
  nibabel,
  numpy,
  scipy,
  setuptools-scm,
  toml,
}:

buildPythonPackage rec {
  pname = "nitransforms";
  version = "24.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JKlKM9bd3pTTBp/xVj9Ywd/+Ok7lxo05AF01eeOBeoE=";
  };

  build-system = [
    setuptools-scm
    toml
  ];

  dependencies = [
    h5py
    nibabel
    numpy
    scipy
  ];

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
    mainProgram = "nb-transform";
    changelog = "https://github.com/nipy/nitransforms/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
