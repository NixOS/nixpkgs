{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  jdk,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyjnius";
  version = "1.7.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n4FwhISwqE6tPrC6hOU6xXnkxDyhDHRvmJip891Q9U0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython~=3.1.2" "Cython"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    jdk
    cython
  ];

  pythonImportsCheck = [ "jnius" ];

  meta = {
    description = "Python module to access Java classes as Python classes using the Java Native Interface (JNI)";
    homepage = "https://github.com/kivy/pyjnius";
    changelog = "https://github.com/kivy/pyjnius/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
