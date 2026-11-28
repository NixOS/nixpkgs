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
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = "aiostream";
    tag = "v${version}";
    hash = "sha256-7tAezAg6Utqgl++yt1ksz1aZRe0XMtu+Jv7y+t1+wKQ=";
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
