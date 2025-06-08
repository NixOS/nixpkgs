{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "task-master-ai";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "eyaltoledano";
    repo = "claude-task-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u9gLwYGRNwkyIOS8zf0nSJfrUDs7ib3Vbm0awtskpSg=";
  };

  npmDepsHash = "sha256-PjnyCqYKj1alnm1gOMSnIeGtg3pJcZ5A8ThxOQZMSF4=";

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
