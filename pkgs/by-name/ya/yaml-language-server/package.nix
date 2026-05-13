{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "yaml-language-server";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "yaml-language-server";
    tag = finalAttrs.version;
    hash = "sha256-I9sLqujD0aTxMrqLziLgjoCLflNyphp2cdvYcAuzZ7s=";
  };

  npmDepsHash = "sha256-b9B6V17kNnKf3HHjEWzHGjKSeOJR17VEjp780Rq8BM0=";

  strictDeps = true;

  meta = {
    changelog = "https://github.com/redhat-developer/yaml-language-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Language Server for YAML Files";
    homepage = "https://github.com/redhat-developer/yaml-language-server";
    license = lib.licenses.mit;
    mainProgram = "yaml-language-server";
    maintainers = [ ];
  };
})
