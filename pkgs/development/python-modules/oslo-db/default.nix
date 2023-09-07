{ lib
, buildPythonPackage
, fetchPypi
, alembic
, debtcollector
, oslo-config
, oslo-context
, oslo-i18n
, oslo-utils
, oslotest
, pbr
, psycopg2
, sqlalchemy
, stevedore
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "oslo-db";
  version = "14.0.0";

  src = fetchPypi {
    pname = "oslo.db";
    inherit version;
    hash = "sha256-nAipzYOOv/rSHrMBL64AKg93v5Vpb6RNBbG2OiJ+n8E=";
  };

  nativeBuildInputs = [ pbr ];

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
    oslo-context
    oslotest
    stestr
    psycopg2
    testresources
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_db" ];

  meta = with lib; {
    description = "Oslo Database library";
    homepage = "https://github.com/openstack/oslo.db";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
