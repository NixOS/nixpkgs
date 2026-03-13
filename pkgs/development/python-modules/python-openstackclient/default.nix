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
  python-watcherclient,
  python-zaqarclient,
  python-zunclient,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-apidoc,
  stestrCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-openstackclient";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-openstackclient";
    tag = finalAttrs.version;
    hash = "sha256-iqHm3vOENStdGI53Ggln/gWVnF3Lyomel9OFmwz2CJc=";
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
    stestrCheckHook
  ];

  disabledTestsRegex = [
    "openstackclient.tests.unit.common.test_module.TestModuleList*"
  ];

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://docs.openstack.org/python-openstackclient/latest/";
    downloadPage = "https://github.com/openstack/python-openstackclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
