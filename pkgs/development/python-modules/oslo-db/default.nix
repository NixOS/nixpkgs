{ lib
, buildPythonPackage
, fetchPypi
, alembic
, oslo-config
, oslo-context
, oslo-utils
, oslotest
, pbr
, setuptools
, sqlalchemy
, sqlalchemy-migrate
, stestr
, testresources
, testscenarios
}:

buildPythonPackage rec {
  pname = "oslo-db";
  version = "14.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.db";
    inherit version;
    hash = "sha256-UFilywqwhXaGnle8K5VNdZqMvhklkTMdHPMDMvz62h8=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

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
