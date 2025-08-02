{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
  cffi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lqOOgSP02J+IILQ2QPH2I9aETx+X7qCcRmDwMXgKn/g=";
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
