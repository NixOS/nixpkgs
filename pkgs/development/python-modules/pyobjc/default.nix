{ lib, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "7.3";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "322b07420f91b2dd7f624823e53046b922cab4aad28baab01a62463728b7e0c5";
  };

  meta = with lib; {
    description = "A bridge between the Python and Objective-C programming languages";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    homepage = "https://pythonhosted.org/pyobjc/";
  };
}
