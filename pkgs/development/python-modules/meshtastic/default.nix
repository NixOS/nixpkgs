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
  version = "1.2.40";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be8464037d0c8085350065b38e7a7b028db15f2524764dec0e3548ea5b53500f";
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

  postPatch = ''
    # https://github.com/meshtastic/Meshtastic-python/pull/87
    substituteInPlace setup.py \
      --replace 'with open("README.md", "r") as fh:' "" \
      --replace "long_description = fh.read()" "" \
      --replace "long_description=long_description," 'long_description="",'
  '';

  # Project only provides PyPI releases which don't contain the tests
  # https://github.com/meshtastic/Meshtastic-python/issues/86
  doCheck = false;
  pythonImportsCheck = [ "meshtastic" ];

  meta = with lib; {
    description = "Python API for talking to Meshtastic devices";
    homepage = "https://meshtastic.github.io/Meshtastic-python/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
