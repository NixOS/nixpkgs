{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,

  # dependencies
  h5py,
  hdf5plugin,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "nexusformat";
  version = "1.0.7";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SSS6LTOdqLTHNGpBRO7UELF9qJb/sG8EwrE/azxk7wM=";
  };

  pyproject = true;

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

  pythonImportsCheck = [ "nexusformat.nexus" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python API to open, create, and manipulate NeXus data written in the HDF5 format";
    homepage = "https://github.com/nexpy/nexusformat";
    changelog = "https://github.com/nexpy/nexusformat/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oberth-effect ];
  };
}
