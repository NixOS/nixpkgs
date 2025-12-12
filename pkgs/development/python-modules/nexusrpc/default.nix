{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "nexus-rpc";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nexus-rpc";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-AHyue0s0bb28WoUnSghpYI3Sh/FyS6FFSM9g0ElYs4I=";
    fetchSubmodules = true;
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "nexusrpc"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nexus Python SDK";
    homepage = "https://temporal.io/";
    changelog = "https://github.com/nexus-rpc/sdk-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
    ];
  };
}
