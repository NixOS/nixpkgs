{ buildPythonPackage
, fetchPypi
, lib
, serpent
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pyro5";
  version = "5.11";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "867cdd291d85560373e0c468da7fd18754f2568ef60e0bc504af42f391d7a3e5";
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
