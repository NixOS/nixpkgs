{
  buildPythonPackage,
  lib,
  versionCheckHook,

  # build-system
  hatchling,

  # dependencies
  logfire-sdk,
}:

buildPythonPackage (finalAttrs: {
  pname = "logfire";
  inherit (logfire-sdk) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/logfire";

  build-system = [ hatchling ];

  dependencies = [ logfire-sdk ];

  optional-dependencies = logfire-sdk.passthru.optional-dependencies;

  pythonImportsCheck = [ "logfire" ];

  # This distribution only provides the console script; the SDK runs the tests.
  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://logfire.pydantic.dev/docs/release-notes";
    description = "Uncomplicated Observability for Python and beyond";
    downloadPage = "https://github.com/pydantic/logfire/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://logfire.pydantic.dev";
    mainProgram = "logfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
