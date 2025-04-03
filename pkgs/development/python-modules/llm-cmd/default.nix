{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  llm,
  # dependencies
  prompt-toolkit,
  pygments,
  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "llm-cmd";
  version = "0.2a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-cmd";
    tag = version;
    hash = "sha256-RhwQEllpee/XP1p0nrgL4m+KjSZzf61J8l1jJGlg94E=";
  };

  # Only needed until https://github.com/simonw/llm-cmd/pull/18 is merged and released
  patches = [ ./fix-test.patch ];
  build-system = [
    setuptools
    # Follows the reasoning from https://github.com/NixOS/nixpkgs/pull/327800#discussion_r1681586659 about including llm in build-system
    llm
  ];

  dependencies = [
    prompt-toolkit
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llm_cmd"
  ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "Use LLM to generate and execute commands in your shell";
    homepage = "https://github.com/simonw/llm-cmd";
    changelog = "https://github.com/simonw/llm-cmd/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
  };
}
