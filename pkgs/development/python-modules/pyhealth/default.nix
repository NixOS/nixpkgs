{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  accelerate,
  dask,
  einops,
  #linear-attention-transformer,
  litdata,
  mne,
  more-itertools,
  narwhals,
  networkx,
  numpy,
  ogb,
  pandas,
  peft,
  polars,
  pyarrow,
  pydantic,
  rdkit,
  scikitlearn,
  torch,
  torchvision,
  tqdm,
  transformers,
  urllib3,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pyhealth";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunlabuiuc";
    repo = "PyHealth";
    rev = "6053b552d217f2f704dca6247ab1b8c6c914cd86";
    hash = "sha256-1111J1VDe3xc4/ar12cQdbDiglun6gxh7D/QrFckxDI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    accelerate
    dask
    einops
    #linear-attention-transformer
    litdata
    mne
    more-itertools
    narwhals
    networkx
    numpy
    ogb
    pandas
    peft
    polars
    pyarrow
    pydantic
    rdkit
    scikitlearn
    torch
    torchvision
    tqdm
    transformers
    urllib3
  ]
  ++ dask.optional-dependencies.complete;

  pythonRelaxDeps = [
    "pandas"
    "urllib3"
  ];

  # Nixpkgs rdkit does not create a -dist-info directory site-packages:
  pythonRemoveDeps = [ "rdkit" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlagsArray = [ "pyhealth" ];

  disabledTestPaths = [
    # try to download data:
    "pyhealth/unittests/test_datasets"
    "pyhealth/unittests/test_medcode.py"
  ];

  pythonImportsCheck = [
    "pyhealth"
  ];

  meta = {
    description = "Deep learning toolkit for healthcare applications";
    homepage = "https://pyhealth.readthedocs.io";
    changelog = "https://github.com/sunlabuiuc/PyHealth/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
