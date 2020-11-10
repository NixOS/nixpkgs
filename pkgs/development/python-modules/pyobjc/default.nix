{ stdenv, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "6.2.2";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5b87e9fa4cc9b51bf37f9a461887e2d8b9ae7e6bb45675f8edbe35ea6770455";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    homepage = "https://pythonhosted.org/pyobjc/";
  };
}
