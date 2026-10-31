{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cliff,
  dogpile-cache,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  openstacksdk,
  osc-lib,
  oslo-utils,
  oslotest,
  pbr,
  platformdirs,
  pyyaml,
  requests,
  requests-mock,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestrCheckHook,
  stevedore,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ironicclient";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-ironicclient";
    tag = finalAttrs.version;
    hash = "sha256-AbxzRpyfplR4Mk9CcaRXi+CNo08tlRIxAFxsJjrkxvY=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxcontrib-apidoc
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    dogpile-cache
    jsonschema
    keystoneauth1
    openstacksdk
    osc-lib
    oslo-utils
    pbr
    platformdirs
    pyyaml
    requests
    stevedore
  ];

  nativeCheckInputs = [
    stestrCheckHook
    requests-mock
    oslotest
  ];

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  pythonImportsCheck = [ "ironicclient" ];

  meta = {
    description = "Client for OpenStack bare metal provisioning API, includes a Python module (ironicclient) and CLI (baremetal)";
    mainProgram = "baremetal";
    homepage = "https://github.com/openstack/python-ironicclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
