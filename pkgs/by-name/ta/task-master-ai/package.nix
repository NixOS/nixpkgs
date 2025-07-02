{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "task-master-ai";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "eyaltoledano";
    repo = "claude-task-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RnbquGcanpBH5A++MZOVNLXEdn7qVJIVWxUOZEBpF/o=";
  };

  npmDepsHash = "sha256-GjRxjafbJ5DqikvO3Z7YPtuUHaG5ezxdrQq9f7WDEi4=";

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
