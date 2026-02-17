{
  lib,
  buildPythonPackage,
  fetchPypi,
  keystoneauth1,
  openssl,
  oslo-config,
  oslo-serialization,
  pbr,
  requests-mock,
  setuptools,
  stestr,
  testresources,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "5.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_keystoneclient";
    inherit version;
    hash = "sha256-jOe/HIzdym1xQPx2kYtE7d8dZAQKYMuP9wWRNhBNTOs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    keystoneauth1
    oslo-config
    oslo-serialization
    pbr
  ];

  nativeCheckInputs = [
    openssl
    requests-mock
    stestr
    testresources
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "keystoneclient" ];

  meta = {
    description = "Client Library for OpenStack Identity";
    homepage = "https://github.com/openstack/python-keystoneclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
