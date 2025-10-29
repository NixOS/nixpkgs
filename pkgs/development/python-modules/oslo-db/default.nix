{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiosqlite,
  alembic,
  debtcollector,
  oslo-config,
  oslo-context,
  oslo-i18n,
  oslo-utils,
  oslotest,
  pbr,
  psycopg2,
  setuptools,
  sqlalchemy,
  stevedore,
  stestr,
  testresources,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "oslo-db";
  version = "17.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_db";
    inherit version;
    hash = "sha256-FLYvWMQWMwy7GIpTKbFNlQF2Ye+K6h1yoP+STuz5EKk=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    alembic
    debtcollector
    oslo-config
    oslo-i18n
    oslo-utils
    sqlalchemy
    stevedore
  ];

  nativeCheckInputs = [
    aiosqlite
    oslo-context
    oslotest
    stestr
    psycopg2
    testresources
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck
    stestr run -e <(echo "oslo_db.tests.sqlalchemy.test_utils.TestModelQuery.test_project_filter_allow_none")
    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_db" ];

  meta = with lib; {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
