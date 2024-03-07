{ lib
, buildPythonApplication
, fetchPypi
, pyserial
, pyudev
, pythonOlder
}:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.31";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7942b758a9ae5c6ff46516b0317f437dfce9f0721f3a3b635ebd501c9cd38fb9";
  };

  propagatedBuildInputs = [
    pyserial
    pyudev
  ];

  meta = with lib; {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
