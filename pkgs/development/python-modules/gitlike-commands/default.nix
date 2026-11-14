{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "gitlike-commands";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "gitlike-commands";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7z6JJgTbELWor8GodtWRg51/oeakLcb9rAdT6K0/JQs=";
  };

  build-system = [ poetry-core ];

  # Module has no real tests
  doCheck = false;

  pythonImportsCheck = [ "gitlike_commands" ];

  meta = {
    description = "Easy python module for creating git-style subcommand handling";
    homepage = "https://github.com/unixorn/gitlike-commands";
    changelog = "https://github.com/unixorn/gitlike-commands/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
