{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  pyprojectVersionPatchHook,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiohasupervisor";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-supervisor-client";
    tag = version;
    hash = "sha256-OAuLee6hbShgEDN/3oD7O6KzxylnfrJoCgMPjluYcG8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=68.0,<83.1" "setuptools"
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aiointercept
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohasupervisor" ];

  meta = {
    description = "Client for Home Assistant Supervisor";
    homepage = "https://github.com/home-assistant-libs/python-supervisor-client";
    changelog = "https://github.com/home-assistant-libs/python-supervisor-client/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
