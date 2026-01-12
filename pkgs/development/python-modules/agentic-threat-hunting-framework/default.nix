{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  jinja2,
  pyyaml,
  rich,
  pytest-cov-stub,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "agentic-threat-hunting-framework";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nebulock-Inc";
    repo = "agentic-threat-hunting-framework";
    tag = "v${version}";
    hash = "sha256-rt7WmBCbSqoZBpwGi7dzh8QDw8Iby3LSdavnCot1Hr0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    jinja2
    pyyaml
    rich
  ];

  optional-dependencies = {
    similarity = [ scikit-learn ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "athf" ];

  meta = {
    description = "Framework for agentic threat hunting";
    homepage = "https://github.com/Nebulock-Inc/agentic-threat-hunting-framework";
    changelog = "https://github.com/Nebulock-Inc/agentic-threat-hunting-framework/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
