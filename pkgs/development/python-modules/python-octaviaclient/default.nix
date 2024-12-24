{
  lib,
  buildPythonPackage,
  cliff,
  doc8,
  docutils,
  fetchPypi,
  hacking,
  keystoneauth1,
  openstackclient,
  openstackdocstheme,
  osc-lib,
  oslotest,
  oslo-serialization,
  oslo-utils,
  pbr,
  pygments,
  python-neutronclient,
  requests,
  requests-mock,
  setuptools,
  sphinx,
  sphinxcontrib-apidoc,
  stestr,
  subunit,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-octaviaclient";
  version = "3.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wrYhCY3gqcklSK8lapsgFq25Yi3awEGgarW2a7W1kO4=";
  };

  build-system = [
    setuptools
    pbr
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  dependencies = [
    cliff
    keystoneauth1
    python-neutronclient
    openstackclient
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  nativeCheckInputs = [
    hacking
    requests-mock
    doc8
    docutils
    pygments
    subunit
    oslotest
    stestr
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "octaviaclient" ];

  meta = with lib; {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://opendev.org/openstack/python-octaviaclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
