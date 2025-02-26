{
  runCommand,
  mcp-server-fetch,
}:
runCommand "mcp-server-fetch-help"
  {
    nativeBuildInputs = [ mcp-server-fetch ];
  }
  ''
    mcp-server-fetch --help
    touch "$out"
  ''
