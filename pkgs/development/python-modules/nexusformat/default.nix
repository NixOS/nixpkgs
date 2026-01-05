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
  version = "1.0.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zsIOnWgMbUaJl3tHnpQiF3+Qy48dwKDAvFlg6z8hW/M=";
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
