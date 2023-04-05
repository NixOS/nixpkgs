{ lib
, buildPythonPackage
, fetchPypi
, alembic
, oslo-config
, oslo-context
, oslo-utils
, oslotest
, pbr
, sqlalchemy
, sqlalchemy-migrate
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "oslo-db";
  version = "12.3.1";

  src = fetchPypi {
    pname = "oslo.db";
    inherit version;
    hash = "sha256-Gd7FAkDwj7q1rnZzVOtZF1oUdz8CcdeDpX/KxJ5KbaE=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    alembic
    oslo-config
    oslo-context
    oslo-utils
    sqlalchemy
    sqlalchemy-migrate
    testresources
    testscenarios
  ];

  nativeCheckInputs = [
    oslotest
    stestr
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
