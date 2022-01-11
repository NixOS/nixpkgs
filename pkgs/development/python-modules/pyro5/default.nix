{ buildPythonPackage
, fetchPypi
, lib
, stdenv
, serpent
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pyro5";
  version = "5.13.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2be9da379ae0ec4cf69ffb3c5c589b698eea00e614a9af7945b87fa9bb09baf2";
  };

  propagatedBuildInputs = [ serpent ];

  checkInputs = [ pytestCheckHook ];

  # ignore network related tests, which fail in sandbox
  disabledTests = [ "StartNSfunc" "Broadcast" "GetIP" "TestNameServer" "TestBCSetup" ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "Socket"
  ];

  meta = with lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro5";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
