{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  nose,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lockfile";
  version = "0.12.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-au0C3gPLok76vNYAswVAFAY0/AbPpgOCLVCNU2Hp95k=";
  };

  build-system = [
    pbr
    setuptools
  ];

  # tests rely on nose
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postcheck
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/pylockfile";
    description = "Platform-independent advisory file locking capability for Python applications";
    license = licenses.asl20;
  };
}
