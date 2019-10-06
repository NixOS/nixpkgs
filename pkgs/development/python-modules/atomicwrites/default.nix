{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75a9445bac02d8d058d5e1fe689654ba5a6556a1dfd8ce6ec55a0ed79866cfa6";
  };

  # Tests depend on pytest but atomicwrites is a dependency of pytest
  doCheck = false;
  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = https://pypi.python.org/pypi/atomicwrites;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
