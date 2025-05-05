{
  lib,
  buildPythonPackage,
  fetchPypi,
  keystoneauth1,
  openssl,
  oslo-config,
  oslo-serialization,
  pbr,
  pythonOlder,
  requests-mock,
  setuptools,
  stestr,
  testresources,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "5.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "python_keystoneclient";
    inherit version;
    hash = "sha256-ch3irsdxAHY4nGdO4ntnEul9hsfg/0h7C0QJyPzuEOc=";
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

  meta = with lib; {
    description = "Client Library for OpenStack Identity";
    homepage = "https://github.com/openstack/python-keystoneclient";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
