{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  numpy,
  poetry-core,
  pytestCheckHook,
  scikit-learn,
  scipy,
  torch,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytorch-tabnet";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dreamquark-ai";
    repo = "tabnet";
    tag = "v${version}";
    hash = "sha256-WyNGgAkNn5CaEuHWQ6Fjnvnrp+KONnxUQudd5ckvcsM=";
  };

  # Modernize poetry build setup
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core"]' \
      --replace-fail 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    scikit-learn
    scipy
    torch
    tqdm
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fsspec
  ];

  pythonImportsCheck = [ "pytorch_tabnet" ];

  meta = {
    description = "PyTorch implementation of TabNet";
    homepage = "https://github.com/dreamquark-ai/tabnet";
    changelog = "https://github.com/dreamquark-ai/tabnet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
