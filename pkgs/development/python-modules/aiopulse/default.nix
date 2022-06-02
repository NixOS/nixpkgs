{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopulse";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Wp8NUjRlO+6ASqIt3C0YJRh0EKcEukXVMp4I+TCTElo=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

  # tests are not present
  doCheck = false;

  pythonImportsCheck = [
    "aiopulse"
  ];

  meta = with lib; {
    description = "Python Rollease Acmeda Automate Pulse hub protocol implementation";
    longDescription = ''
      The Rollease Acmeda Pulse Hub is a WiFi hub that communicates with
      Rollease Acmeda Automate roller blinds via a proprietary RF protocol.
      This module communicates over a local area network using a propriatery
      binary protocol to issues commands to the Pulse Hub.
    '';
    homepage = "https://github.com/atmurray/aiopulse";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
