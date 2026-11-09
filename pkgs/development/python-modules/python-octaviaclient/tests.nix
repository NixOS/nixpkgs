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
  stestrCheckHook,
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
    stestrCheckHook
    testscenarios
  ];
}
