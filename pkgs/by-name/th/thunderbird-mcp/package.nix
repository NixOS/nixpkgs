{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "thunderbird-mcp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "TKasperczyk";
    repo = "thunderbird-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+m54jF39SoViHxDI18ewtVjeVUdRximJ6Ozcv1HVdiU=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  preInstall = "mkdir node_modules/";
  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-LbEnmABmAoTCTPNNbocl+n2TtFC3FOFwwTnyATxvM3k=";

  meta = {
    description = "MCP server for Thunderbird - enables AI assistants to access email, contacts, and calendars";
    homepage = "https://github.com/TKasperczyk/thunderbird-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "thunderbird-mcp";
    platforms = lib.platforms.all;
  };
})
