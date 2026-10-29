{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lockfile";
  version = "0.12.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-au0C3gPLok76vNYAswVAFAY0/AbPpgOCLVCNU2Hp95k=";
  };

  patches = [ ./fix-tests.patch ];

  build-system = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://launchpad.net/pylockfile";
    description = "Platform-independent advisory file locking capability for Python applications";
    license = lib.licenses.asl20;
  };
}
