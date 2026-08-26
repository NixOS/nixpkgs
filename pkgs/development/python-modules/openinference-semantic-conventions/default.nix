{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "openinference-semantic-conventions";
  version = "0.1.32";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Arize-ai";
    repo = "openinference";
    tag = "python-openinference-semantic-conventions-v${finalAttrs.version}";
    hash = "sha256-rEF7Ijx3Zo3NHywFJFa5+QpXZjIWOvkQBie+54v/f8A=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/${finalAttrs.pname}";

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "openinference.semconv" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTelemetry Semantic Conventions for AI Observability";
    homepage = "https://github.com/Arize-ai/openinference";
    changelog = "https://github.com/Arize-ai/openinference/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
