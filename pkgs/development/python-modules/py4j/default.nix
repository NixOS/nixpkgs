{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7605e512bf9b002245f5a9121a8c2df9bfd1a6004fe6dd3ff29d46f901719d53";
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
