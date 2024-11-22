{ lib
, buildPythonApplication
, fetchPypi
, pyserial
, pyudev
}:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.33";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yD4F4xZpHaID5aXZ5tbCZB24a/+FtyobmAOV5GOJMMU=";
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
