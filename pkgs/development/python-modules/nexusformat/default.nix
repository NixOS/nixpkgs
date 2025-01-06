{
  lib,
  buildPythonPackage,
  fetchPypi,
  h5py,
  hdf5plugin,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nexusformat";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SSS6LTOdqLTHNGpBRO7UELF9qJb/sG8EwrE/azxk7wM=";
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

  meta = with lib; {
    description = "Python API to open, create, and manipulate NeXus data written in the HDF5 format";
    homepage = "https://github.com/nexpy/nexusformat";
    changelog = "https://github.com/nexpy/nexusformat/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oberth-effect ];
  };
}
