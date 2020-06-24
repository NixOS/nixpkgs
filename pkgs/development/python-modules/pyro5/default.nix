{ buildPythonPackage
, fetchPypi
, lib
, serpent
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pyro5";
  version = "5.10";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e518e2a3375bc04c073f7c8c82509d314b00fa2f65cead9f134ebe42a922b360";
  };

  propagatedBuildInputs = [ serpent ];

  checkInputs = [ pytestCheckHook ];

  # ignore network related tests, which fail in sandbox
  disabledTests = [ "StartNSfunc" "Broadcast" "GetIP" "TestNameServer" "TestBCSetup" ];

  meta = with lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro5";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
