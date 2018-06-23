{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    extension= "zip";
    sha256 = "721189616b3a7d28212dfb2e7c6a1dd5147b03105f1fc37ff2432acd0e863fa5";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Py4J enables Python programs running in a Python interpreter to dynamically access Java objects in a Java Virtual Machine. Methods are called as if the Java objects resided in the Python interpreter and Java collections can be accessed through standard Python collection methods. Py4J also enables Java programs to call back Python objects.";
    homepage = https://www.py4j.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.shlevy ];
  };
}
