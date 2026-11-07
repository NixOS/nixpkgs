{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  go_1_27,
}:

# go.mod requires go >= 1.27.3; nixpkgs' default `go` hasn't caught up yet.
# Drop this override once nixpkgs' default go is >= 1.27.3.
(buildGoModule.override { go = go_1_27; }) (finalAttrs: {
  __structuredAttrs = true;

  pname = "web-researcher-mcp";
  version = "1.50.4";

  src = fetchFromGitHub {
    owner = "zoharbabin";
    repo = "web-researcher-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAx4aBBUQcnFYhU0uNF4so+cAtSLkJudmaTyggDaL9o=";
  };

  # CGO_ENABLED=0 — pure Go, no C deps. No test network access needed.
  env.CGO_ENABLED = 0;

  # vendor hash: run `nix build` with lib.fakeHash first, then paste the real
  # hash reported in the error. Or run: nix-prefetch-github --nix zoharbabin
  # web-researcher-mcp --rev v<VERSION> then compute vendorHash separately.
  vendorHash = "sha256-DNcVCMRf9MICWTGXujT384tF0Z0Cw7A4X6aIkyHr67s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # go-rod launches a headless browser in tests; skip those — they require
  # network access and a display, neither of which is available in the sandbox.
  # The non-browser tests (unit + integration) all pass without network.
  checkFlags = [
    "-skip"
    "TestBrowserScrape|TestHeadless|TestRod"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # Lens JSON files enable site-restricted search across 20+ domain categories.
    # The binary looks for them at $out/share/web-researcher-mcp/lenses/ when the
    # WEB_RESEARCHER_MCP_LENSES_DIR env var is unset, so we install them there.
    if [ -d lenses ]; then
      install -dm755 "$out/share/web-researcher-mcp/lenses"
      install -Dm644 lenses/*.json "$out/share/web-researcher-mcp/lenses/"
    fi
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server that gives AI assistants web search, content extraction, and multi-source research with verifiable citations";
    longDescription = ''
      web-researcher-mcp is a Model Context Protocol (MCP) server that gives AI
      assistants web search, content extraction, academic/patent/SEC filing/
      case-law/economic data lookup, and multi-step research with real, verifiable
      citations. Supports DuckDuckGo (zero-config), Google Custom Search, Brave,
      Exa, Tavily, and more. Runs over STDIO or HTTP transport.
    '';
    homepage = "https://github.com/zoharbabin/web-researcher-mcp";
    changelog = "https://github.com/zoharbabin/web-researcher-mcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zoharbabin ];
    mainProgram = "web-researcher-mcp";
    platforms = lib.platforms.unix;
  };
})
