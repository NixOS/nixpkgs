{
  lib,
  crownstone-core,
  buildPythonPackage,
  pyserial,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "crownstone-uart";
  version = "2.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-uart";
    tag = finalAttrs.version;
    hash = "sha256-Sc6BCIRbf1+GraTScmV4EAgwtSE/JXNe0f2XhKyACIY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    crownstone-core
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "crownstone_uart" ];

  meta = {
    description = "Python module for communicating with Crownstone USB dongles";
    homepage = "https://github.com/crownstone/crownstone-lib-python-uart";
    changelog = "https://github.com/crownstone/crownstone-lib-python-uart/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
