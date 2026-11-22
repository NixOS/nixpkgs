{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  keystoneauth1,
  openssl,
  oslo-config,
  oslo-serialization,
  pbr,
  requests-mock,
  setuptools,
  stestrCheckHook,
  testresources,
  testscenarios,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-keystoneclient";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-keystoneclient";
    tag = finalAttrs.version;
    hash = "sha256-sUul9gleUEO+0uRdogti9QgmrZY4W6w/BUkIiAr1uK4=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
    stestrCheckHook
    testresources
    testscenarios
  ];

  pythonImportsCheck = [ "keystoneclient" ];

  meta = {
    description = "Client Library for OpenStack Identity";
    homepage = "https://github.com/openstack/python-keystoneclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
