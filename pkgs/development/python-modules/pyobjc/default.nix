{ stdenv, fetchPypi, isPy3k, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyobjc";
  version = "4.2.1";

  # Gives "No matching distribution found for
  # pyobjc-framework-Collaboration==4.0b1 (from pyobjc==4.0b1)"
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b156abab60da3f3c4bc65a919eabb2c98539a94163a277efba5828358396d23e";
  };

  meta = {
    description = "A bridge between the Python and Objective-C programming languages";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = https://pythonhosted.org/pyobjc/;
  };
}
