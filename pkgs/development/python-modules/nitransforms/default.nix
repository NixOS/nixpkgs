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
  version = "24.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7C0HaGmJhlABzGZ90glx865SnVNmt2wDlmOX3bnnJXI=";
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
