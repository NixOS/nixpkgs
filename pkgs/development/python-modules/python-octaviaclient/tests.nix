{
  buildPythonPackage,
  python-octaviaclient,
  python-openstackclient,
  hacking,
  requests-mock,
  doc8,
  docutils,
  pygments,
  python-subunit,
  oslotest,
  stestr,
  testscenarios,
}:

buildPythonPackage {
  pname = "python-octaviaclient-tests";
  inherit (python-octaviaclient) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    python-octaviaclient
    python-openstackclient
    hacking
    requests-mock
    doc8
    docutils
    pygments
    python-subunit
    oslotest
    stestr
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';
}
