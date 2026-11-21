{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  debtcollector,
  pbr,
  eventlet,
  coverage,
  oslotest,
  stestr,
  testscenarios,
  testtools,
  prettytable,
}:

buildPythonPackage rec {
  pname = "futurist";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "futurist";
    tag = "${version}";
    hash = "sha256-IrISdaVykQsRnfPk9bu1FpYtbyvMxzWm39FLpQmrFAM=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
  ];

  dependencies = [ debtcollector ];

  pythonImportsCheck = [ "futurist" ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  nativeCheckInputs = [
    eventlet
    coverage
    oslotest
    stestr
    testscenarios
    testtools
    prettytable
  ];

  meta = {
    homepage = "https://opendev.org/openstack/futurist";
    description = "Collection of async functionality and additions from the future";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members;
  };
}
