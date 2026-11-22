{
  lib,
  buildPythonPackage,
  debtcollector,
  fetchFromGitHub,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  oslotest,
  pbr,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-apidoc,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-designateclient";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-designateclient";
    tag = finalAttrs.version;
    hash = "sha256-cqMtXbmDuAUvBoBAMsHTSgb1G1a/cUYAnt7g4umAXZM=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
    sphinxcontrib-apidoc
  ];

  sphinxBuilders = [ "man" ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    debtcollector
    jsonschema
    keystoneauth1
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  nativeCheckInputs = [
    oslotest
    requests-mock
    stestrCheckHook
  ];

  pythonImportsCheck = [ "designateclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-designateclient";
    description = "Client library for OpenStack Designate API";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
