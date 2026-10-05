{
  lib,
  buildPythonPackage,
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
  huggingface-hub,
  mktestdocs,
  pytest,
  scikit-image,

  # tests
  jaxlib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "minari";
  version = "0.5.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Minari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bLOlhc87Ew1tq9bQA9nfTLznXuOogZoE4mcjJeMQbU0=";
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
    hf = [ huggingface-hub ];
    integrations = [
      # agilerl
      # d3rlpy
    ];
    testing = [
      # gymnasium-robotics
      mktestdocs
      pytest
      scikit-image
    ];
  };

  pythonImportsCheck = [ "minari" ];

  nativeCheckInputs = [
    jaxlib
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
    changelog = "https://github.com/Farama-Foundation/Minari/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "minari";
  };
})
