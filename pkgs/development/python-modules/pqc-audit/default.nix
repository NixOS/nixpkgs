{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  mcp,
  nix-update-script,
  pytestCheckHook,
  rich,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pqc-audit";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rauleteee";
    repo = "pqc-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QzkytPYDVwoiISgsNhEbbWPLGRz9JKwiFbX2H5HtosI=";
  };

  build-system = [ setuptools ];

  dependencies = [ rich ];

  optional-dependencies = {
    mcp = [ mcp ];
  };

  nativeCheckInputs = [
    jsonschema
    mcp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pqc_scanner" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library to scan and audit PQC implementations for known vulnerabilities";
    homepage = "https://github.com/rauleteee/pqc-scanner";
    changelog = "https://github.com/rauleteee/pqc-scanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pqc-scanner";
  };
})
