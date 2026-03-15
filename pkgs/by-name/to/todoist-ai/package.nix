{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "todoist-ai";
  version = "7.11.2";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WEJSVFduzeVEQ0LUOMu6hqYViixU/qSv/GSYLs98qNY=";
  };

  npmDepsHash = "sha256-fKxhiIaO3RTWUvr9d7GUz4MBjE1NM/qXxDpe5dUT7Rg=";
  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    runHook preBuild
    npx vite build
    chmod +x dist/main.js dist/main-http.js
    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Todoist AI tools and MCP server";
    homepage = "https://github.com/Doist/todoist-ai";
    license = lib.licenses.mit;
    mainProgram = "todoist-ai";
    maintainers = with lib.maintainers; [ nadja-y ];
  };
})
