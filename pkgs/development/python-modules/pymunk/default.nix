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
  version = "7.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-028QrHg1W19HmNWxfjIQChoSMCWLHzcAj3eOznLdtxk=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
}
