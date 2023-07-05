{ buildPythonPackage
, python-manilaclient
, stestr
, ddt
, tempest
, mock
, python-openstackclient
}:

buildPythonPackage rec {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version;

  src = python-manilaclient.src;

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
