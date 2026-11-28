{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx2,
  nix-update-script,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "pagerduty";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PagerDuty";
    repo = "python-pagerduty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ljhl1/uWpdCXK1CoiEo6KDYPxh/KbI5hxEAHs2rQbM4=";
  };

  build-system = [ uv-build ];

  dependencies = [ httpx2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pagerduty" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library supplying client classes for PagerDuty's public APIs";
    homepage = "https://github.com/PagerDuty/python-pagerduty";
    changelog = "https://github.com/PagerDuty/python-pagerduty/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
