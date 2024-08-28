{
  buildPythonPackage,
  python-manilaclient,
  stestr,
  ddt,
  tempest,
  mock,
  python-openstackclient,
}:

buildPythonPackage {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    python-manilaclient
    stestr
    ddt
    tempest
    mock
    python-openstackclient
  ];

  checkPhase = ''
    stestr run
  '';
}
