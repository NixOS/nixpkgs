{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "py4j";

  version = "0.10.9.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9pTK0Z76W9He5PPlJw60BmE8l0OUA15b/E7Bq6hwuHk=";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Py4J enables Python programs running in a Python interpreter to dynamically access Java objects in a Java Virtual Machine. Methods are called as if the Java objects resided in the Python interpreter and Java collections can be accessed through standard Python collection methods. Py4J also enables Java programs to call back Python objects";
    homepage = "https://www.py4j.org/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.bsd3;
    maintainers = [ maintainers.shlevy ];
  };
}
