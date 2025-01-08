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
  version = "0.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chamberlain2007";
    repo = "pyaprilaire";
    tag = version;
    hash = "sha256-1cTbmpRB4PzjqCPmHULLVEs7r7IWxIglnHkXsLksp0I=";
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
    description = "Python library for interacting with Aprilaire thermostats.";
    homepage = "https://github.com/chamberlain2007/pyaprilaire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
