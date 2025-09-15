{
  lib,
  buildPythonPackage,
  cliff,
  doc8,
  docutils,
  fetchPypi,
  hacking,
  keystoneauth1,
  makePythonPath,
  openstackdocstheme,
  installer,
  osc-lib,
  oslotest,
  oslo-serialization,
  oslo-utils,
  pbr,
  pygments,
  python-neutronclient,
  python-openstackclient,
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
  version = "3.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_octaviaclient";
    inherit version;
    hash = "sha256-5brfxkpJQousEcXl0YerzYDjrfl0XyWV0RXPTz146Y4=";
  };

  # somehow python-neutronclient cannot be found despite it being supplied
  pythonRemoveDeps = [ "python-neutronclient" ];

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
    python-openstackclient
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  preInstall = ''
    # TODO: I have really no idea why installer is missing...
    export PYTHONPATH=$PYTHONPATH:${makePythonPath [ installer ]}
  '';

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

    # TODO: no idea why PYTHONPATH is broken here
    export PYTHONPATH=$PYTHONPATH:${makePythonPath nativeCheckInputs}

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "octaviaclient" ];

  meta = with lib; {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://github.com/openstack/python-octaviaclient";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
