{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ddt,
  hacking,
  installShellFiles,
  openstackdocstheme,
  osc-lib,
  osc-placement,
  pbr,
  aodhclient,
  python-barbicanclient,
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
  stdenv,
  stestrCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-openstackclient";
  version = "10.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-openstackclient";
    tag = finalAttrs.version;
    hash = "sha256-xOvDAwnJGYbMJDG+lO1TCLRFavlciJRVmbjYqU/E1DY=";
  };

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
    python-manilaclient
    python-keystoneclient
    requests
  ]
  # to support proxy envs like ALL_PROXY in requests
  ++ requests.optional-dependencies.socks;

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    ddt
    hacking
    requests-mock
    stestrCheckHook
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
      aodhclient
      # gnocchiclient not packaged
      osc-placement
      python-barbicanclient
      # python-cyborgclient not packaged
      python-designateclient
      python-heatclient
      python-ironicclient
      # python-ironic-inspector-client not packaged
      python-magnumclient
      python-manilaclient
      python-mistralclient
      python-neutronclient
      python-octaviaclient
      # python-troveclient not packaged
      python-watcherclient
      python-zaqarclient
      python-zunclient
    ];
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd openstack \
      --bash <($out/bin/openstack complete)
  '';

  meta = {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://docs.openstack.org/python-openstackclient/latest/";
    downloadPage = "https://github.com/openstack/python-openstackclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
