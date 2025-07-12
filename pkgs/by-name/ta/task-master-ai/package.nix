{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "task-master-ai";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "eyaltoledano";
    repo = "claude-task-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OxfY1F30MKrv6sv3ksEy6wMRpWAg5d47w62dA6IDul8=";
  };

  npmDepsHash = "sha256-GStmiG+ZwRQl4pQD3Q0lonCsnwB2ReoC5b9vEPGZ5+o=";

  dontNpmBuild = true;

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ nodejs ]}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Node.js agentic AI workflow orchestrator";
    homepage = "https://task-master.dev";
    changelog = "https://github.com/eyaltoledano/claude-task-master/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "task-master-ai";
    maintainers = [ maintainers.repparw ];
    platforms = platforms.all;
  };
})
