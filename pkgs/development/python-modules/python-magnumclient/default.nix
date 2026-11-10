{
  lib,
  buildPythonPackage,
  cryptography,
  decorator,
  fetchFromGitHub,
  fixtures,
  keystoneauth1,
  openstacksdk,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  oslotest,
  osprofiler,
  pbr,
  prettytable,
  python-openstackclient,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestrCheckHook,
  stevedore,
  testtools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-magnumclient";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-magnumclient";
    tag = finalAttrs.version;
    hash = "sha256-ZEDGXpXrTHcEzbRZF3cFVMVt8UN+x5jNCFHWJfL1M0o=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include magnumclient *" > MANIFEST.in
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    decorator
    keystoneauth1
    openstacksdk
    osc-lib
    oslo-i18n
    oslo-log
    oslo-serialization
    oslo-utils
    prettytable
    requests
    stevedore
  ];

  nativeCheckInputs = [
    fixtures
    python-openstackclient
    osprofiler
    oslotest
    requests-mock
    stestrCheckHook
    testtools
  ];

  pythonImportsCheck = [
    "magnumclient"
    "magnumclient.common"
    "magnumclient.v1"
  ];

  meta = {
    homepage = "https://github.com/openstack/python-magnumclient";
    description = "Client library for OpenStack Magnum API";
    license = lib.licenses.asl20;
    mainProgram = "magnum";
    teams = [ lib.teams.openstack ];
  };
})
