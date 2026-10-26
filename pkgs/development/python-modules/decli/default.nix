{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "decli";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "woile";
    repo = "decli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4GURqlkHzDwrPAlmiBjc2ZqN//nUK084uRMM7GIme0=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "decli" ];

  meta = {
    description = "Minimal, easy to use, declarative command line interface tool";
    homepage = "https://github.com/Woile/decli";
    changelog = "https://github.com/woile/decli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
