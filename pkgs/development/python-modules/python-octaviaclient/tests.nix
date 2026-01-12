{
  buildPythonPackage,
  python-octaviaclient,
  python-openstackclient,
  hacking,
  requests-mock,
  doc8,
  docutils,
  pygments,
  subunit,
  oslotest,
  stestr,
  testscenarios,
}:

buildPythonPackage {
  pname = "python-octaviaclient-tests";
  inherit (python-octaviaclient) version src;
  format = "other";

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
}
