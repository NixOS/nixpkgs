{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mcp,
  python-dotenv,
  requests,
}:

buildPythonPackage {
  pname = "mcp-obsidian";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarkusPfundstein";
    repo = "mcp-obsidian";
    rev = "4aac5c2b874a219652e783b13fde2fb89e9fb640";
    hash = "sha256-CWY4rgJZ8T6zRmJy8ueAk4Dg5QE7+BUSPamUuyAuXpw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mcp
    python-dotenv
    requests
  ];

  # pythonImportsCheck disabled because the module requires OBSIDIAN_API_KEY
  # environment variable to be set at import time
  pythonImportsCheck = [ ];

  # No tests included in PyPI package
  doCheck = false;

  meta = {
    description = "MCP server to work with Obsidian via the remote REST plugin";
    homepage = "https://github.com/MarkusPfundstein/mcp-obsidian";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
