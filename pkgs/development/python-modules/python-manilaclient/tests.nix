{
  buildPythonPackage,
  ddt,
  fixtures,
  python-manilaclient,
  python-openstackclient,
  requests-mock,
  stestrCheckHook,
  tempest,
  testtools,
}:

buildPythonPackage {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    ddt
    fixtures
    python-manilaclient
    python-openstackclient
    requests-mock
    stestrCheckHook
    tempest
    testtools
  ];
}
