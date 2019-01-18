{ stdenv, buildPythonPackage, fetchPypi, pyasn1, isPyPy }:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d14fcb29dabecba3d7b360bf72327c26c385248a5d603cf6be5f566ce999b261";
  };

  propagatedBuildInputs = [ pyasn1 ];

  meta = with stdenv.lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = https://pypi.python.org/pypi/pyasn1-modules;
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
