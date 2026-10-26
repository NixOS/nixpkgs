{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  glibcLocales,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "junitparser";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "weiwei";
    repo = "junitparser";
    tag = finalAttrs.version;
    hash = "sha256-I/bQQPT6b6PTZ9bIlWCQmN/gUWnVIO42xtJh/g7L79A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    glibcLocales
  ];

  meta = {
    description = "Manipulates JUnit/xUnit Result XML files";
    mainProgram = "junitparser";
    license = lib.licenses.asl20;
    homepage = "https://github.com/weiwei/junitparser";
    maintainers = with lib.maintainers; [ multun ];
  };
})
