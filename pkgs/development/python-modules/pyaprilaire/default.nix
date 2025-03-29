{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  crc,
  setuptools,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyaprilaire";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chamberlain2007";
    repo = "pyaprilaire";
    tag = version;
    hash = "sha256-wkeaGd76OoXF18lP+N9a2hu7KjPPg88V0S2yEQoft5g=";
  };

  build-system = [ setuptools ];

  dependencies = [ crc ];

  pythonImportsCheck = [ "pyaprilaire" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = {
    changelog = "https://github.com/chamberlain2007/pyaprilaire/releases/tag/${version}";
    description = "Python library for interacting with Aprilaire thermostats";
    homepage = "https://github.com/chamberlain2007/pyaprilaire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
