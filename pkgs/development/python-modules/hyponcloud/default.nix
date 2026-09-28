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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcisio";
    repo = "hyponcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QbUE/mbF9h1d9441EyUC/5CIB76dDRBq+iMpdqmDS+w=";
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
