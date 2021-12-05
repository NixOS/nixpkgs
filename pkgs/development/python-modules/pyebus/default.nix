{ lib, anytree, buildPythonPackage, fetchPypi, pytestCheckHook, poetry-core
, pythonOlder }:

buildPythonPackage rec {
  pname = "pyebus";
  version = "1.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "i+p40s9SXey1lfXWW+PiXsA1kUF4o6Rk7QLmQ2ljN6g=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ anytree ];

  # https://github.com/c0fec0de/pyebus/issues/3
  doCheck = false;

  pythonImportsCheck = [ "pyebus" ];

  meta = with lib; {
    description = "Pythonic Interface to EBUS Daemon (ebusd)";
    homepage = "https://github.com/c0fec0de/pyebus";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
