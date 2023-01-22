{ lib
, buildPythonPackage
, fetchPypi
, serpent
, dill
, cloudpickle
, msgpack
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyro4";
  version = "4.82";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    pname = "Pyro4";
    inherit version;
    hash = "sha256-UR9bCATpLdd9wzrfnJR3h+P56cWpaxIWLwVXp8TOIfs=";
  };

  propagatedBuildInputs = [
    serpent
  ];

  buildInputs = [
    dill
    cloudpickle
    msgpack
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # add testsupport.py to PATH
  preCheck = "PYTHONPATH=tests/PyroTests:$PYTHONPATH";


  pytestFlagsArray = [
    # ignore network related tests, which fail in sandbox
    "--ignore=tests/PyroTests/test_naming.py"
  ];

  disabledTests = [
    "StartNSfunc"
    "Broadcast"
    "GetIP"
  ];

  # otherwise the tests hang the build
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "Pyro4"
  ];

  meta = with lib; {
    description = "Distributed object middleware for Python (RPC)";
    homepage = "https://github.com/irmen/Pyro4";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
