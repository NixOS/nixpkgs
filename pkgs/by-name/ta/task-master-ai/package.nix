{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
  nodejs,
  nix-update-script,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "task-master-ai";
  version = "0.43.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/task-master-ai/-/task-master-ai-${finalAttrs.version}.tgz";
    hash = "sha256-W3kih+wuYdNCi/i/aA/m3w/s/ndVQ0LAGsD+660lxaU=";
  };

  postPatch = ''
    ${lib.getExe jq} 'del(.workspaces, .devDependencies, .scripts)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-yvFzWnjteHwWRQGGNBVkzcJ8NgMgNdbhw/YdpNvBEJQ=";

  nativeBuildInputs = [ jq ];

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ nodejs ]}" ];

  passthru.updateScript = nix-update-script { };

  env = {
    PUPPETEER_SKIP_DOWNLOAD = 1;
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/task-master";

  meta = {
    description = "Node.js agentic AI workflow orchestrator";
    homepage = "https://task-master.dev";
    changelog = "https://github.com/eyaltoledano/claude-task-master/blob/task-master-ai@${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "task-master-ai";
    maintainers = [ lib.maintainers.repparw ];
    platforms = lib.platforms.all;
  };
})
