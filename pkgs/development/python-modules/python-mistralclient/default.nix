{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitea,
  keystoneauth1,
  openstackdocstheme,
  os-client-config,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  oslotest,
  osprofiler,
  pbr,
  pythonOlder,
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
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-mistralclient";
    rev = version;
    hash = "sha256-Vi56+OlFU2Aj7yJ/cH5y0ZbzPhglTciJcTnkbA0S7Qo=";
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
    os-client-config
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
    maintainers = teams.openstack.members;
  };
}
