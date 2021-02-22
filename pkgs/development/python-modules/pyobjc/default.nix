{ lib, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "7.0";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b6c3e98f1408564ace1df36927154d7827c8e2f382386ab5d2db95c891e35a0";
  };

  meta = with lib; {
    description = "A bridge between the Python and Objective-C programming languages";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    homepage = "https://pythonhosted.org/pyobjc/";
  };
}
