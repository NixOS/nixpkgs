{
  lib,
  buildPythonPackage,
  fetchPypi,
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

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "7.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_openstackclient";
    inherit version;
    hash = "sha256-6BfhGgHLK1FvvZnc5FwJnI5BxD0RuxHmZycDqDhEnZ8=";
  };

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

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "openstackclient" ];

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

  meta = with lib; {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://github.com/openstack/python-openstackclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
