{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyyaml,
  requests,
}:
let
  pname = "prompthub-py";
  version = "4.0.0";
in
buildPythonPackage {
  inherit version pname;
  pyproject = true;

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = "prompthub-py";
    rev = "v${version}";
    hash = "sha256-FA4IfhHViSL1u4pgd7jh40rEcS0BldSFDwCPG5irk1g=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  meta = {
    description = "Simple client to fetch prompts from Prompt Hub using its REST API";
    homepage = "https://github.com/deepset-ai/prompthub-py";
    changelog = "https://github.com/deepset-ai/prompthub-py/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
