{ lib, buildPythonApplication, fetchPypi, pyserial, pyudev }:

buildPythonApplication rec {
  pname = "rshell";
  version = "0.0.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2002d40d735204037d6142a6c2d51beecc763c124faaf759cabf7acd945be95";
  };

  propagatedBuildInputs = [ pyserial pyudev ];

  meta = with lib; {
    homepage = "https://github.com/dhylands/rshell";
    description = "Remote Shell for MicroPython";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
