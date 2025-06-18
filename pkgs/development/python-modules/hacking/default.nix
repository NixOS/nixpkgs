{
  lib,
  buildPythonPackage,
  ddt,
  fetchPypi,
  flake8,
  pbr,
  pythonOlder,
  setuptools,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "hacking";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ubbC5SgPfVT6gsWP4JmD9oxbb2NKw/ozn4uhalcVyrc=";
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

  meta = with lib; {
    description = "OpenStack Hacking Guideline Enforcement";
    homepage = "https://github.com/openstack/hacking";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
