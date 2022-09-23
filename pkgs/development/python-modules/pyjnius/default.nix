{ buildPythonPackage
, cython
, fetchPypi
, jdk
, lib
, six
}:

buildPythonPackage rec {
  pname = "pyjnius";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bc1a1b06fb11df8dd8b8d56f5ecceab614d4ba70cf559c64ae2f146423d53ce";
  };
  propagatedBuildInputs = [
    six
  ];

  nativeBuildInputs = [ jdk cython ];

  pythonImportsCheck = [ "jnius" ];

  meta = with lib; {
    description = "A Python module to access Java classes as Python classes using the Java Native Interface (JNI)";
    homepage = "https://github.com/kivy/pyjnius";
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
