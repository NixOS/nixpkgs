{
  lib,
  buildPythonPackage,
  jinja2,
  setuptools,
  fetchFromGitHub,
  rich,
  versionCheckHook,
  pytestCheckHook,
  pytest-cov-stub,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "j2lint";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "j2lint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aT25Yq5GkQpZBgVNjYdV/afyqFanJkmqkDGMz2Yf+Ps=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    rich
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    versionCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "j2lint" ];

  meta = {
    description = "Jinja2 Linter CLI";
    homepage = "https://github.com/aristanetworks/j2lint";
    changelog = "https://github.com/aristanetworks/j2lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ polyfloyd ];
    mainProgram = "j2lint";
  };
})
