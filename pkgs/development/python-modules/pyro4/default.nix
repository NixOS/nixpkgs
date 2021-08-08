{ lib
, buildPythonPackage
, fetchPypi
, python
, serpent
, dill
, cloudpickle
, msgpack
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Pyro4";
  version = "4.80";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "46847ca703de3f483fbd0b2d22622f36eff03e6ef7ec7704d4ecaa3964cb2220";
  };

  propagatedBuildInputs = [
    serpent
  ];

  buildInputs = [
    dill
    cloudpickle
    msgpack
  ];

  checkInputs = [ pytestCheckHook ];

  # add testsupport.py to PATH
  preCheck = "PYTHONPATH=tests/PyroTests:$PYTHONPATH";

  # ignore network related tests, which fail in sandbox
  pytestFlagsArray = [ "--ignore=tests/PyroTests/test_naming.py" ];

  disabledTests = [
    "StartNSfunc"
    "Broadcast"
    "GetIP"
  ];

  # otherwise the tests hang the build
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro4";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
