{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ixia";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "ixia";
    tag = version;
    hash = "sha256-8STtLL63V+XnDqDNZOx7X9mkjUu176SSyQOL55LXFz0=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "ixia" ];

  meta = {
    changelog = "https://github.com/trag1c/ixia/blob/${src.rev}/CHANGELOG.md";
    description = "Connecting secrets' security with random's versatility";
    license = lib.licenses.mit;
    homepage = "https://trag1c.github.io/ixia";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
