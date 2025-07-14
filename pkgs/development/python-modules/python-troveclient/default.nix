{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httplib2,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-utils,
  pbr,
  prettytable,
  python-mistralclient,
  python-openstackclient,
  python-swiftclient,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-troveclient";
  version = "8.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-troveclient";
    tag = version;
    hash = "sha256-WBMXSZhkrKlEkVpy56zdBRzspUjUsj0dQ4OR250Fo+s=";
  };

  env.PBR_VERSION = version;

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
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-utils
    prettytable
    python-mistralclient
    python-openstackclient
    python-swiftclient
    requests
    stevedore
  ];

  nativeCheckInputs = [
    httplib2
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "troveclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-troveclient";
    description = "Client library for OpenStack Trove API";
    license = lib.licenses.asl20;
    mainProgram = "trove";
    teams = [ lib.teams.openstack ];
  };
}
