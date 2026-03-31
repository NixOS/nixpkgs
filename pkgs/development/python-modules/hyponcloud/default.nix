{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyponcloud";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcisio";
    repo = "hyponcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EfAML6n/dhvpRVjghJUoAV3deP4YcMFon01UCwhT7Oc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hyponcloud" ];

  meta = {
    description = "Python library for Hypontech Cloud API for solar inverter monitoring";
    homepage = "https://github.com/jcisio/hyponcloud";
    changelog = "https://github.com/jcisio/hyponcloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
