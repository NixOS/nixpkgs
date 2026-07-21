{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "yaml-language-server";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    tag = finalAttrs.version;
    hash = "sha256-JIThwWGunUn4fHxPx7wBqi/F9aslNhWjcx11TvMyoDQ=";
  };

  npmDepsHash = "sha256-0jmq/4XpuZLjoRCxpGBZdGgfyvBTBBoT893o2mooCVw=";

  strictDeps = true;

  meta = {
    changelog = "https://github.com/redhat-developer/yaml-language-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Language Server for YAML Files";
    homepage = "https://github.com/redhat-developer/yaml-language-server";
    license = lib.licenses.mit;
    mainProgram = "yaml-language-server";
    maintainers = with lib.maintainers; [
      nick-linux
    ];
  };
})
