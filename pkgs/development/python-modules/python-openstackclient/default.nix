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
  version = "7.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hLbxcm/LkqMU2dyTMYhIB12iR7eYMUhC0bFS8zZEGl0=";
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

  pythonImportsCheck = [ "openstackclient" ];

  passthru = {
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
