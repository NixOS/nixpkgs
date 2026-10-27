{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-raises,
  pytestCheckHook,
  setuptools,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioemonitor";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aioemonitor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FjZQcsonRPvBWjBQtyq4hHgtMouojrsSdSGjjTzGH0E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-raises
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner>=5.2",' ""
  '';

  pythonImportsCheck = [ "aioemonitor" ];

  meta = {
    description = "Python client for SiteSage Emonitor";
    mainProgram = "my_example";
    homepage = "https://github.com/bdraco/aioemonitor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
