{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  gql,
  oathtool,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "monarchmoney";
  version = "0.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hammem";
    repo = "monarchmoney";
    tag = "v${version}";
    hash = "sha256-I5YCINwJqzdntVGn8T8Yx/cfWOtwgwvyt30swBLQHDo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
    oathtool
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "monarchmoney" ];

  meta = {
    description = "Python API for Monarch Money";
    homepage = "https://github.com/hammem/monarchmoney";
    changelog = "https://github.com/hammem/monarchmoney/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
