{
  lib,
  buildPythonPackage,
  cliff,
<<<<<<< HEAD
  fetchPypi,
=======
  doc8,
  docutils,
  fetchPypi,
  hacking,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  keystoneauth1,
  makePythonPath,
  openstackdocstheme,
  installer,
  osc-lib,
<<<<<<< HEAD
  oslo-serialization,
  oslo-utils,
  pbr,
  python-neutronclient,
  requests,
  setuptools,
  sphinx,
  sphinxcontrib-apidoc,
  callPackage,
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # NOTE(vinetos): This explicit dependency is removed to avoid infinite recursion
  pythonRemoveDeps = [ "python-openstackclient" ];
=======
  # somehow python-neutronclient cannot be found despite it being supplied
  pythonRemoveDeps = [ "python-neutronclient" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
    python-openstackclient
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

<<<<<<< HEAD
  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "octaviaclient" ];

  meta = {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://github.com/openstack/python-octaviaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
