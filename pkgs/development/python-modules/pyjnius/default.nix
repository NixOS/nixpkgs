{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  jdk,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyjnius";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qfs5u15vx1/l6T21hMC2fHXZSGCo+TIpp267zE5bmA=";
  };

  nativeBuildInputs = [
    jdk
    cython
  ];

  pythonImportsCheck = [ "jnius" ];

  meta = with lib; {
    description = "Python module to access Java classes as Python classes using the Java Native Interface (JNI)";
    homepage = "https://github.com/kivy/pyjnius";
    changelog = "https://github.com/kivy/pyjnius/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
