{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  packaging,
  pydantic,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-rs";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-project-templates";
    repo = "hatch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sElwrsaLqnk12YvQxffg8S5ThhZNe5VsbfS2S9GdUxI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    hatchling
    packaging
    pydantic
  ];

  pythonImportsCheck = [
    "hatch_rs"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Tests require pip/network access
    "hatch_rs/tests/test_projects.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hatch plugin for Rust";
    homepage = "https://github.com/python-project-templates/hatch-rs";
    changelog = "https://github.com/python-project-templates/hatch-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
