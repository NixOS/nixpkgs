{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  fetchpatch,
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
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-mistralclient";
    tag = version;
    hash = "sha256-FNfee7d8gTcsTdv7lxqDbniUiKQvUXHRSkAlNOCn/k4=";
  };

  patches = [
    # Fix unit test failure caused by osprofiler 4.4.0
    (fetchpatch {
      url = "https://github.com/openstack/python-mistralclient/commit/4cee2bb25a4d15e7dd1802f3e7e75520177446db.patch";
      hash = "sha256-H8JSvPFcHZJsnIWpV0WPvkqyvmg8SBbpsUzqcZeFBwA=";
    })
  ];

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

  meta = {
    description = "OpenStack Mistral Command-line Client";
    homepage = "https://github.com/openstack/python-mistralclient";
    license = lib.licenses.asl20;
    mainProgram = "mistral";
    teams = [ lib.teams.openstack ];
  };
}
