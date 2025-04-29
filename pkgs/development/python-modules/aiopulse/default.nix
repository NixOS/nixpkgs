{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "aiopulse";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DM/zDFoTYgaW+o2YYv4bDAja5iwabIBfFJ7Yep4Fywc=";
  };

  build-system = [ hatchling ];

  dependencies = [ async-timeout ];

  # Tests are not present
  doCheck = false;

  pythonImportsCheck = [ "aiopulse" ];

  meta = with lib; {
    description = "Python Rollease Acmeda Automate Pulse hub protocol implementation";
    longDescription = ''
      The Rollease Acmeda Pulse Hub is a WiFi hub that communicates with
      Rollease Acmeda Automate roller blinds via a proprietary RF protocol.
      This module communicates over a local area network using a propriatery
      binary protocol to issues commands to the Pulse Hub.
    '';
    homepage = "https://github.com/atmurray/aiopulse";
    changelog = "https://github.com/atmurray/aiopulse/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
