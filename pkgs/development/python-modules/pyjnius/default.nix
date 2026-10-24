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
  version = "1.9.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-A4URhIyKTGqFuHiCdLfuxLLHjs1WUc0FuOqGSkLCLWQ=";
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
