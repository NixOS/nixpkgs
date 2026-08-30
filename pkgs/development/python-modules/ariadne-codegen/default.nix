{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pyprojectVersionPatchHook,
  click,
  graphql-core,
  toml,
  httpx,
  pydantic,
  ruff,
}:
buildPythonPackage (finalAttrs: {
  pname = "ariadne-codegen";
  version = "0.19.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "ariadne-codegen";
    tag = "${finalAttrs.version}";
    hash = "sha256-Xo56rY9Vj2AIMC7o0+3eWQDiJhfVZ+LTr39lPUTW0yQ=";
  };
  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];
  dependencies = [
    click
    graphql-core
    toml
    httpx
    pydantic
    ruff
  ];
  # Upstream pins ruff>=0.15.0,<0.16.0, but only ever calls it as a `ruff
  # check`/`ruff format` subprocess with long-stable, basic CLI flags
  # (--isolated, --select, --target-version, --line-length); nixpkgs' ruff
  # (0.16.4) behaves identically for these.
  pythonRelaxDeps = [ "ruff" ];
  build-system = [ hatchling ];
  meta = {
    description = "Generate fully typed GraphQL client from schema, queries and mutations";
    homepage = "https://github.com/mirumee/ariadne-codegen";
    changelog = "https://github.com/mirumee/ariadne-codegen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
