{
  lib,
  buildPythonApplication,
  fetchPypi,
  pyserial,
  pyudev,
}:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.36";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SmbYNSB0eVUOWdDdPoMAPQTE7KeKTkklD4h+0t1LC/U=";
  };

  propagatedBuildInputs = [
    pyserial
    pyudev
  ];

  meta = {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0deaddict ];
  };
}
