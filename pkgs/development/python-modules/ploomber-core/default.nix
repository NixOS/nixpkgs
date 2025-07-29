{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  posthog,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ploomber-core";
  version = "0.2.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "core";
    tag = version;
    hash = "sha256-4lAsO+igyb/JXmZsgDgUUrgw3EyhdrliD9LlQqxhBMM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    posthog
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "telemetry" # requires network
    "exceptions" # requires stderr capture
  ];

  pythonImportsCheck = [ "ploomber_core" ];

  meta = {
    description = "Core module shared across Ploomber projects";
    homepage = "https://github.com/ploomber/core";
    changelog = "https://github.com/ploomber/core/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
