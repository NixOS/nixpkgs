{ buildPythonPackage
, cython
, fetchPypi
, jdk
, lib
, six
}:

buildPythonPackage rec {
  pname = "pyjnius";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/AY3zaSuEo7EqWrDJ9NS6H6oZnZLAdliZyhwvlOana4=";
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
