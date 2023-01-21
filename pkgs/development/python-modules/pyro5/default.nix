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
  version = "5.14";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZP3OE3sP5TLohhTSRrfJi74KT0JnhsUkU5rNxeaUCGo=";
  };

  propagatedBuildInputs = [ serpent ];

  nativeCheckInputs = [ pytestCheckHook ];

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
