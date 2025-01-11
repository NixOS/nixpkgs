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
  version = "5.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wvWTT5VXaTbJjkW/WZrUi8sKxFFZPl+DROv1LLD0EfU=";
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
    maintainers = teams.openstack.members;
  };
}
