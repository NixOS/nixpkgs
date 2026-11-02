{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  jdk,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyjnius";
  version = "1.7.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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
    changelog = "https://github.com/kivy/pyjnius/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ifurther ];
  };
})
