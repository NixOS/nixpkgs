{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  posthog,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ploomber-core";
  version = "0.2.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "core";
    tag = version;
    hash = "sha256-QUEnWFhf42ppoXoz3H/2SHtoPZOi6lbopsrbmEAk+1U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    posthog
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
