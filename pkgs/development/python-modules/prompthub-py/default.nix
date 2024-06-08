{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  format = "pyproject";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "deepset-ai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FA4IfhHViSL1u4pgd7jh40rEcS0BldSFDwCPG5irk1g=";
  };

  disabled = pythonOlder "3.8";

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pyyaml
    requests
  ];

  meta = with lib; {
    description = "A simple client to fetch prompts from Prompt Hub using its REST API.";
    homepage = "https://github.com/deepset-ai/prompthub-py";
    changelog = "https://github.com/deepset-ai/prompthub-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
