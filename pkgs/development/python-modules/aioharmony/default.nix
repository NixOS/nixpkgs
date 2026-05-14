{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  slixmpp,
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Harmony-Libs";
    repo = "aioharmony";
    tag = "v${version}";
    hash = "sha256-H5zVY7LvTP8/CQtUGtXCXxOfG8GFQgdp7BY8jl9X+Gc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    slixmpp
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = {
    homepage = "https://github.com/Harmony-Libs/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    mainProgram = "aioharmony";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oro ];
  };
}
