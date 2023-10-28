{ lib
, buildPythonPackage
, cython
, fetchPypi
, jdk
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjnius";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C32+PY9Yu7e+wwyFjz+nibzBwexJMZWOn3uH9F6hQDM=";
  };

  nativeBuildInputs = [
    jdk
    cython
  ];

  pythonImportsCheck = [
    "jnius"
  ];

  meta = with lib; {
    description = "A Python module to access Java classes as Python classes using the Java Native Interface (JNI)";
    homepage = "https://github.com/kivy/pyjnius";
    changelog = "https://github.com/kivy/pyjnius/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
