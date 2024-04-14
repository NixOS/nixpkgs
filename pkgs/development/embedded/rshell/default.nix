{ lib
, buildPythonApplication
, fetchPypi
, pyserial
, pyudev
, pythonOlder
}:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.32";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-frIwZ21JzVgxRS+KouBjDShHCP1lCoUwwySy2oFGcJ8=";
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
