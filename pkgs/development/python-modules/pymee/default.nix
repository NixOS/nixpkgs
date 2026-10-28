{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  websockets,
  regex,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymee";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreshlyBrewedCode";
    repo = "pymee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VNKIA/1juhkn11nkW52htvE4daXJoySeEyevWbboUek=";
  };

  build-system = [ setuptools ];
  dependencies = [
    aiohttp
    websockets
    regex
  ];

  pythonImportsCheck = [ "pymee" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Python library to interact with homee";
    homepage = "https://github.com/FreshlyBrewedCode/pymee";
    changelog = "https://github.com/FreshlyBrewedCode/pymee/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
