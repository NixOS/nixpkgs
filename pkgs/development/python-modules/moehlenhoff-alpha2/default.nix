{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  xmltodict,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "moehlenhoff-alpha2";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "j-a-n";
    repo = "python-moehlenhoff-alpha2";
    tag = version;
    hash = "sha256-bvT7kWFPIEQUgUxLGydd2e7SBA7vPV+YAzDqYLE7X+o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "moehlenhoff_alpha2"
  ];

  meta = {
    description = "Python client for the Moehlenhoff Alpha2 underfloor heating system";
    homepage = "https://github.com/j-a-n/python-moehlenhoff-alpha2";
    changelog = "https://github.com/j-a-n/python-moehlenhoff-alpha2/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
