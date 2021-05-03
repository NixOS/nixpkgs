{ lib, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "7.1";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dfce78545df1af25d1dcd710309dd243083d90c977a8c84c483f8254967417b";
  };

  meta = with lib; {
    description = "A bridge between the Python and Objective-C programming languages";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    homepage = "https://pythonhosted.org/pyobjc/";
  };
}
