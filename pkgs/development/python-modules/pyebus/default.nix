{ lib
, anytree
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyebus";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6ooOSJAIi8vYmCjDHnbMGQJfPqPmzA5thDSg+iM7T+8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anytree
  ];

  # https://github.com/c0fec0de/pyebus/issues/3
  doCheck = false;

  pythonImportsCheck = [
    "pyebus"
  ];

  meta = with lib; {
    description = "Pythonic Interface to EBUS Daemon (ebusd)";
    homepage = "https://github.com/c0fec0de/pyebus";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
