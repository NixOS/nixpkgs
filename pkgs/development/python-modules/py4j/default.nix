{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "624f97c363b8dd84822bc666b12fa7f7d97824632b2ff3d852cc491359ce7615";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Py4J enables Python programs running in a Python interpreter to dynamically access Java objects in a Java Virtual Machine. Methods are called as if the Java objects resided in the Python interpreter and Java collections can be accessed through standard Python collection methods. Py4J also enables Java programs to call back Python objects.";
    homepage = "https://www.py4j.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.shlevy ];
  };
}
