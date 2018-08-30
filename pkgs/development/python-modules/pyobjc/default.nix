{ stdenv, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "4.2.2";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "24be63e394e8e66c1131e2b8e67e44f6c28ceb4329af01e9c10824044be8adbc";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = https://pythonhosted.org/pyobjc/;
  };
}
