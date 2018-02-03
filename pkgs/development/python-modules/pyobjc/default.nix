{ stdenv, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyobjc";
  version = "4.1";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "287db11f912ac7d05c4907dbf6e74abaa475e36368f7c92e05aca2886a94562c";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = https://pythonhosted.org/pyobjc/;
  };
}
