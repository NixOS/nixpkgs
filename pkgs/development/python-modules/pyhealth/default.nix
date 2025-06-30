{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mne-python,
  networkx,
  numpy,
  pandarallel,
  pandas,
  rdkit,
  scikit-learn,
  torch,
  torchvision,
  tqdm,
  urllib3,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhealth";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunlabuiuc";
    repo = "PyHealth";
    tag = "v${version}";
    hash = "sha256-tXtiJ1VDe3xc4/ar12cQdbDiglun6gxh7D/QrFckxDI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mne-python
    networkx
    numpy
    pandarallel
    pandas
    rdkit
    scikit-learn
    torch
    torchvision
    tqdm
    urllib3
  ];

  pythonRelaxDeps = [
    "pandas"
    "urllib3"
  ];

  # Nixpkgs rdkit does not create a -dist-info directory site-packages:
  pythonRemoveDeps = [ "rdkit" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [ "pyhealth" ];

  disabledTestPaths = [
    # try to download data:
    "pyhealth/unittests/test_datasets"
    "pyhealth/unittests/test_medcode.py"
  ];

  # tries to write to $HOME
  #pythonImportsCheck = [
  #  "pyhealth"
  #];

  meta = {
    description = "Deep learning toolkit for healthcare applications";
    homepage = "https://pyhealth.readthedocs.io";
    changelog = "https://github.com/sunlabuiuc/PyHealth/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
