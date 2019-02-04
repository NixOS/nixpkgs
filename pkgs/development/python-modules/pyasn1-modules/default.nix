{ stdenv, buildPythonPackage, fetchPypi, pyasn1, isPyPy }:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a52090e8c5841ebbf08ae455146792d9ef3e8445b21055d3a3b7ed9c712b7c7c";
  };

  propagatedBuildInputs = [ pyasn1 ];

  meta = with stdenv.lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = https://pypi.python.org/pypi/pyasn1-modules;
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
