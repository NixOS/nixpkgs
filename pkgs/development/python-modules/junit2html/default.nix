{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  jinja2,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "junit2html";
  version = "31.1.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "inorton";
    repo = "junit2html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TF+ifAFPn3PQwYQFruP++bWo6/6J8LEmDJYXDYSwcq0=";
  };

  build-system = [ setuptools ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "junit2htmlreport" ];

  meta = {
    description = "Generate HTML reports from Junit results";
    homepage = "https://gitlab.com/inorton/junit2html";
    changelog = "https://gitlab.com/inorton/junit2html/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "junit2html";
  };
})
