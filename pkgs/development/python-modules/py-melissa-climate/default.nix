{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-melissa-climate";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = "py-melissa-climate";
    tag = "v${version}";
    hash = "sha256-VSKSa7K2fF6NMLN39HzkqK7/9vGHmmmPFw6mIiJNZ84=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "melissa" ];

  meta = {
    changelog = "https://github.com/kennedyshead/py-melissa-climate/releases/tag/${src.tag}";
    description = "API wrapper for Melissa Climate";
    homepage = "https://github.com/kennedyshead/py-melissa-climate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
