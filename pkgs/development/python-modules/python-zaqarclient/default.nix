{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-utils,
  pbr,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-zaqarclient";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-zaqarclient";
    tag = version;
    hash = "sha256-SYHFzl7av/D4/2Ovnv95Ed4vaTxv/ke6FKVg+MWlGBI=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    jsonschema
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-log
    oslo-utils
    requests
    stevedore
  ];

  nativeCheckInputs = [
    ddt
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "zaqarclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-zaqarclient";
    description = "Client library for OpenStack Zaqar API";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
