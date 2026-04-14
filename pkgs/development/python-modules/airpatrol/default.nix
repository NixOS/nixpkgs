{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "airpatrol";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "antondalgren";
    repo = "airpatrol";
    tag = "v${version}";
    hash = "sha256-KPch1GsJ5my43d9SVpwGA2EmrkmeBGJWAkY51rDofTk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "airpatrol" ];

  meta = {
    description = "Python package for interacting with AirPatrol devices";
    homepage = "https://github.com/antondalgren/airpatrol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
