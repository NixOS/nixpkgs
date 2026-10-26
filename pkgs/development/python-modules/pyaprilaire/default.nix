{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  crc,
  setuptools,
  pytest-asyncio_0,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaprilaire";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chamberlain2007";
    repo = "pyaprilaire";
    tag = finalAttrs.version;
    hash = "sha256-5f/vo8aDQ0HVKXW/yiNYyH3zFnwvP5kv0ZEglvB5quo=";
  };

  build-system = [ setuptools ];

  dependencies = [ crc ];

  pythonImportsCheck = [ "pyaprilaire" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio_0
  ];

  meta = {
    changelog = "https://github.com/chamberlain2007/pyaprilaire/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for interacting with Aprilaire thermostats";
    homepage = "https://github.com/chamberlain2007/pyaprilaire";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
