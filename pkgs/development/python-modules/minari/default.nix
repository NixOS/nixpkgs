{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gymnasium,
  numpy,
  packaging,
  typer,
  typing-extensions,

  # optional-dependencies
  pyarrow,
  jax,
  google-cloud-storage,
  tqdm,
  h5py,
  mktestdocs,
  pytest,

  # tests
  jaxlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "minari";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Minari";
    rev = "refs/tags/v${version}";
    hash = "sha256-SVt93d0GbCxeZXhh5vMPvnsBAeJAfGWNceFi0W9RgeM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gymnasium
    numpy
    packaging
    typer
    typing-extensions
  ];

  optional-dependencies = {
    arrow = [ pyarrow ];
    create = [ jax ];
    gcs = [
      google-cloud-storage
      tqdm
    ];
    hdf5 = [ h5py ];
    testing = [
      # gymnasium-robotics
      mktestdocs
      pytest
    ];
  };

  pythonImportsCheck = [ "minari" ];

  nativeCheckInputs = [
    jaxlib
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # Require internet access
    "test_download_namespace_dataset"
    "test_download_namespace_metadata"
    "test_markdown"

    # Attempts at installing minari using pip (impossible in the sandbox)
    "test_readme"
  ];

  disabledTestPaths = [
    # Require internet access
    "tests/dataset/test_dataset_download.py"
    "tests/test_cli.py"
  ];

  meta = {
    description = "Standard format for offline reinforcement learning datasets, with popular reference datasets and related utilities";
    homepage = "https://github.com/Farama-Foundation/Minari";
    changelog = "https://github.com/Farama-Foundation/Minari/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "minari";
  };
}
