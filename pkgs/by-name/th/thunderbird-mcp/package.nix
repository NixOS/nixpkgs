{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "thunderbird-mcp";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "TKasperczyk";
    repo = "thunderbird-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OH8uAy9ka2ao/7UF2Bi4dfhOa0IZz+z2Bm6MpfBF1Gk=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  forceEmptyCache = true;
  dontNpmBuild = true;

  npmDepsHash = "sha256-cngbvIIP7lgwuXhIM6CA7oNlg9ctj9I2AA3SMKxk54g=";

  doCheck = true;

  # Tests use local mock servers.
  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  preCheck = ''
    # This is a test for the project's CI
    rm test/release-workflow.test.cjs
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "MCP server for Thunderbird - enables AI assistants to access email, contacts, and calendars";
    homepage = "https://github.com/TKasperczyk/thunderbird-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "thunderbird-mcp";
    platforms = lib.platforms.all;
  };
})
