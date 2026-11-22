{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chardet,
  colored,
  h5py,
  hdf5plugin,
  lxml,
  numpy,
  pytestCheckHook,
  python-dateutil,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "nexusformat";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    tag = "v${finalAttrs.version}";
    owner = "nexpy";
    repo = "nexusformat";
    hash = "sha256-WuGVJsjw7gekNxz+3O33dG7JLC6ee6BuIT9u7lvhAhw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    chardet
    colored
    h5py
    hdf5plugin
    lxml
    numpy
    python-dateutil
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nexusformat.nexus" ];

  meta = {
    description = "Python API to open, create, and manipulate NeXus data written in the HDF5 format";
    homepage = "https://github.com/nexpy/nexusformat";
    changelog = "https://github.com/nexpy/nexusformat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oberth-effect ];
  };
})
