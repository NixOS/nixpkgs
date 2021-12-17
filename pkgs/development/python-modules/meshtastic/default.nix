{ lib
, buildPythonPackage
, dotmap
, fetchPypi
, pexpect
, protobuf
, pygatt
, pypubsub
, pyqrcode
, pyserial
, pythonOlder
, tabulate
, timeago
}:

buildPythonPackage rec {
  pname = "meshtastic";
  version = "1.2.44";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f99e076dde0db86a5ba734b48257ffc7355a2b4729cea1ff5cd7638ca93dbd90";
  };

  propagatedBuildInputs = [
    dotmap
    pexpect
    protobuf
    pygatt
    pypubsub
    pyqrcode
    pyserial
    tabulate
    timeago
  ];

  # Project only provides PyPI releases which don't contain the tests
  # https://github.com/meshtastic/Meshtastic-python/issues/86
  doCheck = false;

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
