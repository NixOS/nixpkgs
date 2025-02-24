{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  anthropic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "llm-anthropic";
  version = "0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-7+5j5jZBFfaaqnfjvLTI+mz1PUuG8sB5nD59UCpJuR4=";
  };

  build-system = [
    setuptools
    llm
  ];
  dependencies = [ anthropic ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
  ];

  pythonImportsCheck = [ "llm_anthropic" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
