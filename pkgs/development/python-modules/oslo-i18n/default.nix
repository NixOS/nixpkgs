{
  lib,
  buildPythonPackage,
  fetchPypi,
  oslotest,
  pbr,
  setuptools,
  testscenarios,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-i18n";
  version = "6.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_i18n";
    inherit version;
    hash = "sha256-V0vPIYc7GFBovOyVHeHsCTFY/9/wWoBV/Rjdy2n2nmU=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    oslotest
    stestr
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
