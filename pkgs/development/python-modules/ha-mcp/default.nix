{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  fastmcp,
  httpx,
  packaging,
  pydantic,
  pydantic-monty,
  python-dotenv,
  truststore,
  tzdata,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-mcp";
  version = "8.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JjZyHfqSbo3T6uMd8JVvEDVpYIDpJQcd4fViNo5wrY8=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = true;

  dependencies = [
    cryptography
    fastmcp
    httpx
    packaging
    pydantic
    pydantic-monty
    python-dotenv
    truststore
    tzdata
  ]
  ++ httpx.optional-dependencies.socks;

  # Tests require a running Home Assistant instance
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  pythonImportsCheck = [ "ha_mcp" ];

  meta = {
    description = "MCP server for controlling Home Assistant via natural language";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "ha-mcp";
  };
})
