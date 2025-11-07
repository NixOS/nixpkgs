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
  stestr,
  stevedore,
  tempest,
}:

buildPythonPackage rec {
  pname = "python-mistralclient";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-mistralclient";
    tag = version;
    hash = "sha256-8tB1QPaxdLdti96gOzaXuqLftmTJVM0bosJiKs+0CFs=";
  };

  env.PBR_VERSION = version;

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
    stestr
    tempest
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "mistralclient" ];

  meta = with lib; {
    description = "OpenStack Mistral Command-line Client";
    homepage = "https://opendev.org/openstack/python-mistralclient/";
    license = licenses.asl20;
    mainProgram = "mistral";
    teams = [ teams.openstack ];
  };
}
