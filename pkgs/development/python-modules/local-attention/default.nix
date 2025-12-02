{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hyper-connections,
  pytestCheckHook,
  setuptools,
  torch,
}:

buildPythonPackage rec {
  pname = "local-attention";
  version = "1.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "local-attention";
    tag = version;
    hash = "sha256-2gBPALJAflLf7Y8L5wnNw4fHcvIOKjOncLsebkhrYkU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    einops
    hyper-connections
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "local_attention" ];

  meta = {
    description = "Module for local windowed attention for language modeling";
    homepage = "https://github.com/lucidrains/local-attention";
    changelog = "https://github.com/lucidrains/local-attention/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
