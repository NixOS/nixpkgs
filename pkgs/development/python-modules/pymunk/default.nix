{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
  cffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "7.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ed50/c5o9HUUwubljvVQKgu2i6HDx35ONZuqRm6dTBY=";
  };

  nativeBuildInputs = [ cffi ];

  build-system = [ setuptools ];

  dependencies = [ cffi ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "pymunk/tests" ];

  pythonImportsCheck = [ "pymunk" ];

  meta = {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    changelog = "https://github.com/viblo/pymunk/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
}
