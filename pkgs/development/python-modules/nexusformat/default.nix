{
  lib,
  buildPythonPackage,
  fetchPypi,
  colored,
  h5py,
  hdf5plugin,
  numpy,
  pytestCheckHook,
  python-dateutil,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nexusformat";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FeAM5iwTfC/EcVl/L/1l7NTuZcVnZISQppTKaRqWldA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    colored
    h5py
    hdf5plugin
    numpy
    python-dateutil
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nexusformat.nexus" ];

  meta = {
    description = "Python API to open, create, and manipulate NeXus data written in the HDF5 format";
    homepage = "https://github.com/nexpy/nexusformat";
    changelog = "https://github.com/nexpy/nexusformat/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oberth-effect ];
  };
}
