{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "thunderbird-mcp";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "TKasperczyk";
    repo = "thunderbird-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VIJUMMiJ2NCdMfxK4E/FAQ4P2ryS6KlxhPj749JH6sE=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-6irpujYRk/OvoTA43CvtoaOmHvK4coMFXRfXhGrjFNk=";

  doCheck = true;

  # Tests use local mock servers.
  __darwinAllowLocalNetworking = true;

  checkPhase = "npm test";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for Thunderbird - enables AI assistants to access email, contacts, and calendars";
    homepage = "https://github.com/TKasperczyk/thunderbird-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "thunderbird-mcp";
    platforms = lib.platforms.all;
  };
})
