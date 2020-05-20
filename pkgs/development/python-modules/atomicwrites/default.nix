{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yla2svfhfqrcj8qbyqzx7wi4jy0dwcxvlkg0k3zjd54s5m3jw5f";
  };

  # Tests depend on pytest but atomicwrites is a dependency of pytest
  doCheck = false;
  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = "https://pypi.python.org/pypi/atomicwrites";
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
