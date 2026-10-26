{
  lib,
  aesedb,
  aiosmb,
  aiowinreg,
  buildPythonPackage,
  fetchPypi,
  minidump,
  minikerberos,
  msldap,
  setuptools,
  winsspi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypykatz";
  version = "0.6.13";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+T1E/Dk4OcXa8vBhspuB/8V23TORsXXetZpylW25SJM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aesedb
    aiosmb
    aiowinreg
    minikerberos
    msldap
    winsspi
    minidump
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pypykatz" ];

  meta = {
    description = "Mimikatz implementation in Python";
    homepage = "https://github.com/skelsec/pypykatz";
    changelog = "https://github.com/skelsec/pypykatz/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pypykatz";
  };
})
