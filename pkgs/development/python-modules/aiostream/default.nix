{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiostream";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = "aiostream";
    tag = "v${version}";
    hash = "sha256-eO1vcLH+WICMDzm6tSEOxQXNS3KBIW1x0M/0fKkrRUE=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiostream" ];

  meta = {
    description = "Generator-based operators for asynchronous iteration";
    homepage = "https://aiostream.readthedocs.io";
    changelog = "https://github.com/vxgmichel/aiostream/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rmcgibbo ];
  };
}
