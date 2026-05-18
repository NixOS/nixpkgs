{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonOlder,

  hatchling,

  packaging,
  platformdirs,
  pydantic,
  pyyaml,
  tomlkit,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "dagster-shared";
  version = "1.13.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dagster-io";
    repo = "dagster";
    tag = finalAttrs.version;
    hash = "sha256-I/yve9ztaaV9AXnWkocFplgrhxCm6KI7bd/W9TawQOM=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_modules/libraries/dagster-shared";

  build-system = [ hatchling ];

  dependencies = [
    packaging
    platformdirs
    pydantic
    pyyaml
    tomlkit
    typing-extensions
  ];

  doCheck = false;

  pythonImportsCheck = [ "dagster_shared" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Shared utilities for the Dagster ecosystem";
    homepage = "https://github.com/dagster-io/dagster";
    changelog = "https://github.com/dagster-io/dagster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ silky ];
  };
})
