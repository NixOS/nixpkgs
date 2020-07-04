{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36ec57f43ff8ced260a18aa9a4e46c3500a730cac8860e259cbaa546c2b9db2f";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Py4J enables Python programs running in a Python interpreter to dynamically access Java objects in a Java Virtual Machine. Methods are called as if the Java objects resided in the Python interpreter and Java collections can be accessed through standard Python collection methods. Py4J also enables Java programs to call back Python objects.";
    homepage = "https://www.py4j.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.shlevy ];
  };
}
