{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  h5py,
  numpy,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  scipy,
  tables,
}:

buildPythonPackage rec {
  pname = "h5io";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h5io";
    repo = "h5io";
    tag = "h5io-${version}";
    hash = "sha256-ZkG9e7KtDvoRq9XCExYseE+Z7tMQTWcSiwsSrN5prdI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    h5py
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    scipy
    tables
  ];

  disabledTests = [
    # See https://github.com/h5io/h5io/issues/86
    "test_state_with_pathlib"
  ];

  pythonImportsCheck = [ "h5io" ];

  meta = {
    description = "Read and write simple Python objects using HDF5";
    homepage = "https://github.com/h5io/h5io";
    changelog = "https://github.com/h5io/h5io/releases/tag/h5io-${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mbalatsko ];
  };
}
