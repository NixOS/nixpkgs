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
  version = "4.81";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e130da06478b813173b959f7013d134865e07fbf58cc5f1a2598f99479cdac5f";
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
