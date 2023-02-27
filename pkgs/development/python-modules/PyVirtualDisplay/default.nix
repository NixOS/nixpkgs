{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "3.0";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CXVbw86263JfsH7KVCX0PyNY078I4A0qm3kqGu3RYVk=";
  };

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = "https://github.com/ponty/pyvirtualdisplay";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
