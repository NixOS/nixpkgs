{
  buildPythonPackage,
  bytestruct,
  click,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  termcolor,
}:

buildPythonPackage (finalAttrs: {
  pname = "pykdebugparser";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matan1008";
    repo = "pykdebugparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yu0QOZVwRnY/aA4Q6eWqgr1y3QuIRuUEfjXLC7jIKPk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    bytestruct
    click
    termcolor
  ];

  pythonImportsCheck = [ "pykdebugparser" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/matan1008/pykdebugparser/releases/tag/${finalAttrs.src.tag}";
    description = "Kdebug events and ktraces parser";
    homepage = "https://github.com/matan1008/pykdebugparser";
    license = lib.licenses.mit;
    mainProgram = "pykdebugparser";
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
