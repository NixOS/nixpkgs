{ lib
, buildPythonPackage
, dotmap
, fetchFromGitHub
, pexpect
, protobuf
, pygatt
, pypubsub
, pyqrcode
, pyserial
, pytestCheckHook
, pythonOlder
, pyyaml
, tabulate
, pytap2
, timeago
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "1.2.75";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "Meshtastic-python";
    rev = version;
    sha256 = "sha256-VIeW7RloEIBU7YNG7f2e8PdFR+FauIwKLkd7v4qRCOA=";
  };

  propagatedBuildInputs = [
    dotmap
    pexpect
    protobuf
    pygatt
    pypubsub
    pyqrcode
    pyserial
    pyyaml
    tabulate
    timeago
  ];

  checkInputs = [
    pytap2
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "meshtastic"
  ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://meshtastic.github.io/Meshtastic-python/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
