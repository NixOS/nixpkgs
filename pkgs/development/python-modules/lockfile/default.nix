{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  nose,
}:

buildPythonPackage rec {
  pname = "lockfile";
  version = "0.12.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799";
  };

  build-system = [
    pbr
    setuptools
  ];

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
