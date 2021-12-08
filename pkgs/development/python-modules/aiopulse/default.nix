{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiopulse";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "atmurray";
     repo = "aiopulse";
     rev = "v0.4.3";
     sha256 = "15kwil3y3a0jlh01vm4bmrvxmxmhchqrpg01vv58x22ylli9j8ki";
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
