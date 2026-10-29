{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  cryptography,
  fastmcp,
  httpx,
  httpx2,
  packaging,
  psutil,
  pydantic,
  pydantic-monty,
  python-dotenv,
  truststore,
  tzdata,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-mcp";
  version = "8.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-UQ6mUpVYWnQCOav8zzjwArmeHfdeh1g5GNFKQHRrO9U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.17,<0.13" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonRelaxDeps = true;

  dependencies = [
    cryptography
    fastmcp
    httpx
    httpx2
    packaging
    psutil
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
