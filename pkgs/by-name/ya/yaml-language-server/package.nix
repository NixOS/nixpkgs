{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "yaml-language-server";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    tag = finalAttrs.version;
    hash = "sha256-tahzUtzi+p8SPivvVl5txUjnVCGTjGT6nuS+kLMAuEw=";
  };

  npmDepsHash = "sha256-firOmhVhj0vc3MI8gC5Yq/cx2WYTIjzExhbN5bH8vKg=";

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
