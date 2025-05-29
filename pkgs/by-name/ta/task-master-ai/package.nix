{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "task-master-ai";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "eyaltoledano";
    repo = "claude-task-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cCfyQ9xU8axuZyTTVsrYVuic6DPHnAc4YX7aKj2MmSE=";
  };

  npmDepsHash = "sha256-UNGJ64E12ppo37gJBDNpyRFYfNEJMH5mRnK3HyWcy8E=";

  dontNpmBuild = true;

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
