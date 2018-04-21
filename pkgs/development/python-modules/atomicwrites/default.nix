{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585";
  };

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = https://pypi.python.org/pypi/atomicwrites;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
