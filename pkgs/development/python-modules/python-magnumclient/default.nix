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
  stestr,
  stevedore,
  testtools,
}:

buildPythonPackage rec {
  pname = "python-magnumclient";
  version = "4.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-magnumclient";
    tag = version;
    hash = "sha256-kOnx2Fsx6WK7Z3z7O6so1LOjjyPiEB0jDFzOl7WlMS0=";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

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
    stestr
    testtools
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "magnumclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-magnumclient";
    description = "Client library for OpenStack Magnum API";
    license = lib.licenses.asl20;
    mainProgram = "magnum";
    teams = [ lib.teams.openstack ];
  };
}
