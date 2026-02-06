{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  jinja2,
  python-dotenv,
  pyyaml,
  rich,
  pytest-cov-stub,
  pytestCheckHook,
  scikit-learn,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "agentic-threat-hunting-framework";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nebulock-Inc";
    repo = "agentic-threat-hunting-framework";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0IlDOS9qWl0F9h3xWDioK/GhZ3HanAQMdAkH6mvvQCQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    jinja2
    python-dotenv
    pyyaml
    rich
  ];

  optional-dependencies = {
    similarity = [ scikit-learn ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "athf" ];

  meta = {
    description = "Framework for agentic threat hunting";
    homepage = "https://github.com/Nebulock-Inc/agentic-threat-hunting-framework";
    changelog = "https://github.com/Nebulock-Inc/agentic-threat-hunting-framework/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
