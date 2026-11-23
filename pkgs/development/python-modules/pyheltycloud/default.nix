{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyheltycloud";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebaschiera";
    repo = "pyheltycloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jSDppVQ4biJfwrYTuFDHPskhIYUC3hdzB6Ya0GGdVA8=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyheltycloud" ];

  meta = {
    description = "Async client for the Helty cloud (hcloud) of Helty Flow VMC units";
    homepage = "https://github.com/ebaschiera/pyheltycloud";
    changelog = "https://github.com/ebaschiera/pyheltycloud/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
