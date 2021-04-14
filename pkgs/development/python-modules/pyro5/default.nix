{ buildPythonPackage
, fetchPypi
, lib
, serpent
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pyro5";
  version = "5.12";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "616e6957c341da0ca26f947805c9c97b42031941f59ca5613537d1420ff4f2e2";
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
