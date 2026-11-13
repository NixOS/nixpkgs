{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  openstacksdk,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  oslotest,
  osprofiler,
  pbr,
  pyyaml,
  requests-mock,
  requests,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestrCheckHook,
  stevedore,
  tempest,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mistralclient";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-mistralclient";
    tag = finalAttrs.version;
    hash = "sha256-Ohotgzzjs2N2U41re2dsK5FZ21uuPpBmiu86DPS9uYw=";
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
    setuptools
    pbr
  ];

  dependencies = [
    cliff
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    pbr
    pyyaml
    requests
    stevedore
  ];

  nativeCheckInputs = [
    openstacksdk
    oslotest
    osprofiler
    requests-mock
    stestrCheckHook
    tempest
  ];

  pythonImportsCheck = [ "mistralclient" ];

  meta = {
    description = "OpenStack Mistral Command-line Client";
    homepage = "https://github.com/openstack/python-mistralclient";
    license = lib.licenses.asl20;
    mainProgram = "mistral";
    teams = [ lib.teams.openstack ];
  };
})
