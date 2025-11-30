{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  h5py,
  nibabel,
  numpy,
  scipy,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nitransforms";
  version = "25.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wcs0iV/ENCLhsjH6hTDmxoAsNAN9qzd9n+wWbiA04aU=";
  };

  build-system = [
    setuptools
    setuptools-scm
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

  meta = {
    homepage = "https://nitransforms.readthedocs.io";
    description = "Geometric transformations for images and surfaces";
    mainProgram = "nb-transform";
    changelog = "https://github.com/nipy/nitransforms/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
