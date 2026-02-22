{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyotgw";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = "pyotgw";
    tag = finalAttrs.version;
    hash = "sha256-0F+UBIPk+A9z0YJtLVlJAqzMre8GZAio720SCi2dorE=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial-asyncio-fast ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyotgw" ];

  disabledTests = [
    # Tests require network access
    "connect_timeouterror"
  ];

  meta = {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    changelog = "https://github.com/mvn23/pyotgw/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
