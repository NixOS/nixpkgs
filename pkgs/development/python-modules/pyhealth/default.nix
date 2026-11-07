{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
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
  #ogb,
  orjson,
  pandas,
  peft,
  platformdirs,
  polars,
  pyarrow,
  pydantic,
  rdkit,
  scikit-learn,
  torch,
  torchvision,
  tqdm,
  transformers,
  urllib3,

  # checkInputs
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # optional-dependencies.nlp
  rapidfuzz,
  nltk,
  rouge-score,
}:

buildPythonPackage rec {
  pname = "pyhealth";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunlabuiuc";
    repo = "PyHealth";
    tag = "v${version}";
    hash = "sha256-8JpDwtMmfdDLegeq6jNiiTh0MmLjefsfshPHB8d5jyY=";
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
    #ogb
    orjson
    pandas
    peft
    platformdirs
    polars
    pyarrow
    pydantic
    rdkit
    scikit-learn
    torch
    torchvision
    tqdm
    transformers
    urllib3
  ] ++ dask.optional-dependencies.complete;

  passthru.optional-dependencies.nlp = [
    rapidfuzz
    nltk
    rouge-score
  ];

  pythonRelaxDeps = true;

  # Nixpkgs rdkit does not create a -dist-info directory site-packages:
  #pythonRemoveDeps = [ "rdkit" ];
  pythonRemoveDeps = [ "rdkit" "ogb" "linear-attention-transformer" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # tries to write to $HOME
  pythonImportsCheck = [
    "pyhealth"
  ];

  meta = {
    description = "Deep learning toolkit for healthcare applications";
    homepage = "https://pyhealth.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
