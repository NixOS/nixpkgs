{ lib, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "7.0.1";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4fd120683b19a2abeac351784204e6b092cf1fb94f597b6eb22f30c117b2ef0";
  };

  meta = with lib; {
    description = "A bridge between the Python and Objective-C programming languages";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    homepage = "https://pythonhosted.org/pyobjc/";
  };
}
