{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  setuptools,

  # direct
  keystoneauth1,
  iso8601,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  prettytable,
  stevedore,

  # tests
  stestrCheckHook,
  versionCheckHook,
  coverage,
  fixtures,
  requests-mock,
  openstacksdk,
  osprofiler,
  openssl,
  testscenarios,
  testtools,
  tempest,

  # docs
  sphinxHook,
  openstackdocstheme,
  sphinxcontrib-apidoc,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-novaclient";
  version = "18.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-novaclient";
    tag = finalAttrs.version;
    hash = "sha256-ZVJXGGceY7tnD/rkMkZjn5zifATeLYRGEVI2iLKERJ8=";
  };

  patches = [
    ./fix-setup-cfg.patch
  ];

  env.PBR_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxcontrib-apidoc
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    keystoneauth1
    iso8601
    oslo-i18n
    oslo-serialization
    oslo-utils
    pbr
    prettytable
    stevedore
  ];

  nativeCheckInputs = [
    stestrCheckHook
    coverage
    fixtures
    requests-mock
    openstacksdk
    osprofiler
    openssl
    testscenarios
    testtools
    tempest
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  pythonImportsCheck = [
    "novaclient"
    "novaclient.v2"
    "novaclient.tests"
    "novaclient.tests.functional"
    "novaclient.tests.functional.api"
    "novaclient.tests.functional.v2"
    "novaclient.tests.functional.v2.legacy"
    "novaclient.tests.unit"
    "novaclient.tests.unit.fixture_data"
    "novaclient.tests.unit.v2"
  ];

  meta = {
    description = "Client library for OpenStack Compute API";
    mainProgram = "nova";
    homepage = "https://docs.openstack.org/python-novaclient/latest/";
    downloadPage = "https://github.com/openstack/python-novaclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
