{
  lib,
  buildPythonPackage,
  ddt,
  fetchPypi,
  flake8,
  pbr,
  setuptools,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "hacking";
  version = "8.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PHjOx8Wkq7SQmlJS1mq5PpswayGthmV+LCA8eLUiQx8=";
  };

  postPatch = ''
    sed -i 's/flake8.*/flake8/' requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [
    ddt
    stestr
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "hacking" ];

  meta = {
    description = "OpenStack Hacking Guideline Enforcement";
    homepage = "https://github.com/openstack/hacking";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
