{ stdenv, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "5.1.1";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b094596e8bd36be1f63c8c0501dc4ac7899299224111a5877648774a92eec45";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = https://pythonhosted.org/pyobjc/;
  };
}
