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
  version = "17.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.db";
    inherit version;
    hash = "sha256-icREZ/qY8yRTWtqohONRdudB3kogJcvfO6zQFFdNoH8=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
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
    stestr run -e <(echo "oslo_db.tests.sqlalchemy.test_utils.TestModelQuery.test_project_filter_allow_none")
  '';

  pythonImportsCheck = [ "oslo_db" ];

  meta = with lib; {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
