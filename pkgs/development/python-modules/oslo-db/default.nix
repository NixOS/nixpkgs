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
  version = "18.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_db";
    inherit version;
    hash = "sha256-B16GziPAwh2x01CR8dyyGwVEnInDpDJtpPLT+4MwIj8=";
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
  ]
  ++ sqlalchemy.optional-dependencies.asyncio;

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
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_db" ];

  meta = {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
