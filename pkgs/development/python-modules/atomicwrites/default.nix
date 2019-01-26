{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec9ae8adaae229e4f8446952d204a3e4b5fdd2d099f9be3aaf556120135fb3ee";
  };

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = https://pypi.python.org/pypi/atomicwrites;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
