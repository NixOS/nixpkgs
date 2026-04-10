{
  lib,
  anytree,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pyebus";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6ooOSJAIi8vYmCjDHnbMGQJfPqPmzA5thDSg+iM7T+8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ anytree ];

  # https://github.com/c0fec0de/pyebus/issues/3
  doCheck = false;

  pythonImportsCheck = [ "pyebus" ];

  meta = {
    description = "Pythonic Interface to EBUS Daemon (ebusd)";
    homepage = "https://github.com/c0fec0de/pyebus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
