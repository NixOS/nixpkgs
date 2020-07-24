{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae70396ad1a434f9c7046fd2dd196fc04b12f9e91ffb859164193be8b6168a7a";
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
