{ buildPythonPackage
, python-manilaclient
, stestrCheckHook
, ddt
, tempest
, mock
, python-openstackclient
}:

buildPythonPackage {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    python-manilaclient
    stestrCheckHook
    ddt
    tempest
    mock
    python-openstackclient
  ];
}
