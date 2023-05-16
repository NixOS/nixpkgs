{ buildPythonPackage
, python-manilaclient
, stestr
, ddt
, tempest
, mock
, python-openstackclient
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "python-manilaclient-tests";
  inherit (python-manilaclient) version;

  src = python-manilaclient.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
