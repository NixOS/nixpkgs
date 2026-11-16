{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  setuptools,

  # direct
  cliff,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  osprofiler,
  keystoneauth1,
  pyparsing,

  # tests
  stestrCheckHook,
  versionCheckHook,
  openstacksdk,
  oslotest,
  tempest,
  testtools,
  pifpaf,

  # docs
  sphinxHook,
  openstackdocstheme,
}:

buildPythonPackage (finalAttrs: {
  pname = "aodhclient";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-aodhclient";
    tag = finalAttrs.version;
    hash = "sha256-hLdnyq0G/HKYsKna87PPD0nRuaK4nEtP9heerE+Z/sw=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  patches = [
    ./fix-pyproject.patch
  ];

  dependencies = [
    cliff
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    osprofiler
    pbr
    pyparsing
  ];

  nativeCheckInputs = [
    stestrCheckHook
    openstacksdk
    oslotest
    tempest
    testtools
    pifpaf
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  pythonImportsCheck = [
    "aodhclient"
    "aodhclient.v2"
    "aodhclient.tests"
    "aodhclient.tests.functional"
    "aodhclient.tests.unit"
  ];

  meta = {
    description = "Client library for OpenStack AOodh API";
    homepage = "https://docs.openstack.org/python-aodhclient/latest/";
    downloadPage = "https://github.com/openstack/python-aodhclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "aodh";
    teams = [ lib.teams.openstack ];
  };
})
