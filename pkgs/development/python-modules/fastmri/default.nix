{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  scikit-image,
  torchvision,
  torch,
  runstats,
  pytorch-lightning,
  h5py,
  pyyaml,
  torchmetrics,
  pandas,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastmri";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastMRI";
    tag = "v${version}";
    hash = "sha256-0IJV8OhY5kPWQwUYPKfmdI67TyYzDAPlwohdc0jWcV4=";
  };

  # banding_removal folder also has a subfolder named "fastmri"
  # and np.product is substituted with np.prod in new numpy versions
  postPatch = ''
    substituteInPlace tests/test_math.py \
      --replace-fail "np.product" "np.prod"
    substituteInPlace tests/conftest.py \
      --replace-fail "np.product" "np.prod"

    rm -rf banding_removal
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scikit-image
    torchvision
    torch
    runstats
    pytorch-lightning
    h5py
    pyyaml
    torchmetrics
    pandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # much older version of pytorch-lightning is used
    "tests/test_modules.py"
  ];

  pythonImportsCheck = [ "fastmri" ];

  meta = {
    description = "Pytorch-based MRI reconstruction tooling";
    homepage = "https://github.com/facebookresearch/fastMRI";
    changelog = "https://github.com/facebookresearch/fastMRI/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
