{
  lib,
  buildPythonPackage,
  fetchPypi,
  ddt,
  openstackdocstheme,
  osc-lib,
  pbr,
  python-cinderclient,
  python-keystoneclient,
  python-novaclient,
  requests-mock,
  setuptools,
  sphinxHook,
  sphinxcontrib-apidoc,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "6.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u+8e00gpxBBSsuyiZIDinKH3K+BY0UMNpTQexExPKVw=";
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
    python-novaclient
  ];

  nativeCheckInputs = [
    ddt
    stestr
    requests-mock
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "openstackclient" ];

  meta = with lib; {
    description = "OpenStack Command-line Client";
    mainProgram = "openstack";
    homepage = "https://github.com/openstack/python-openstackclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
