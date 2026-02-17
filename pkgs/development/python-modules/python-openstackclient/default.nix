{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ddt,
  openstackdocstheme,
  osc-lib,
  osc-placement,
  pbr,
  python-aodhclient,
  python-barbicanclient,
  python-cinderclient,
  python-designateclient,
  python-heatclient,
  python-ironicclient,
  python-keystoneclient,
  python-magnumclient,
  python-manilaclient,
  python-mistralclient,
  python-neutronclient,
  python-octaviaclient,
  python-openstackclient,
  python-watcherclient,
  python-zaqarclient,
  python-zunclient,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-apidoc,
  stestr,
  testers,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-openstackclient";
  version = "8.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-openstackclient";
    tag = finalAttrs.version;
    hash = "sha256-CEz1v4e4NadSZ+qhotFtLB4y/KdhDZbDOohN8D9FB30=";
  };

  patches = [
    ./fix-pyproject.patch
  ];

  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
    sphinxcontrib-apidoc
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    osc-lib
    pbr
    python-cinderclient
    python-keystoneclient
    requests
  ]
  # to support proxy envs like ALL_PROXY in requests
  ++ requests.optional-dependencies.socks;

  nativeCheckInputs = [
    ddt
    requests-mock
    stestr
  ];

  # test_module failures under python 3.14: https://bugs.launchpad.net/python-openstackclient/+bug/2137223
  checkPhase = ''
    runHook preCheck
    stestr run -E \
      "openstackclient.tests.unit.common.test_module.TestModuleList.(test_module_list_no_options|test_module_list_all)"
    runHook postCheck
  '';

  pythonImportsCheck = [
    "openstackclient"
    "openstackclient.api"
    "openstackclient.common"
    "openstackclient.compute"
    "openstackclient.identity"
    "openstackclient.image"
    "openstackclient.network"
    "openstackclient.object"
    "openstackclient.volume"
    "openstackclient.tests"
  ];

  optional-dependencies = {
    # See https://github.com/openstack/python-openstackclient/blob/master/doc/source/contributor/plugins.rst
    cli-plugins = [
      osc-placement
      python-aodhclient
      python-barbicanclient
      python-designateclient
      python-heatclient
      python-ironicclient
      python-magnumclient
      python-manilaclient
      python-mistralclient
      python-neutronclient
      python-octaviaclient
      python-watcherclient
      python-zaqarclient
      python-zunclient
    ];
  };

  passthru = {
    tests.version = testers.testVersion {
      package = python-openstackclient;
      command = "openstack --version";
    };
  };

  meta = {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://docs.openstack.org/python-openstackclient/latest/";
    downloadPage = "https://github.com/openstack/python-openstackclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
