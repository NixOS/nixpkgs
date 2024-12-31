{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  google-cloud-storage,
  gymnasium,
  h5py,
  numpy,
  packaging,
  portion,
  rich,
  tqdm,
  typer,
  typing-extensions,
  imageio,
  nbmake,
  pytest,
  pytest-markdown-docs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "minari";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Minari";
    rev = "refs/tags/v${version}";
    hash = "sha256-DwuANo0PCb2pPTVST8EwuJHe5HKRV8JIpFBpSqoJNh8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    google-cloud-storage
    gymnasium
    h5py
    numpy
    packaging
    portion
    rich
    tqdm
    typer
    typing-extensions
  ];

  passthru.optional-dependencies = {
    testing = [
      # gymnasium-robotics
      imageio
      nbmake
      pytest
      pytest-markdown-docs
    ];
  };

  pythonImportsCheck = [ "minari" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Require internet access
    "tests/dataset/test_dataset_download.py"
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Standard format for offline reinforcement learning datasets, with popular reference datasets and related utilities";
    homepage = "https://github.com/Farama-Foundation/Minari";
    changelog = "https://github.com/Farama-Foundation/Minari/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "minari";
  };
}
