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
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chamberlain2007";
    repo = "pyaprilaire";
    rev = "refs/tags/${version}";
    hash = "sha256-+/yQO0JF2nkxaM71iNj6ODB8raM9s4qiLLi6/borcr4=";
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
