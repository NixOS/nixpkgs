{
  lib,
  buildPythonPackage,
  fetchPypi,
  h5py,
  hdf5plugin,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nexusformat";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mIGbmpT9+ZPD3X999fhZSdSg/XgI/SdbEoE/oarjuS0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    h5py
    hdf5plugin
    numpy
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
