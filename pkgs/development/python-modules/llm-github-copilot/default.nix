{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  llm,
  llm-github-copilot,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-github-copilot";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmdaly";
    repo = "llm-github-copilot";
    tag = version;
    hash = "sha256-BKbDhsW6gIZVcQvkUB5TKmNqQzIjQTMMhNZiO9VWO3s=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Remove this patch on the next upstream releease
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/jmdaly/llm-github-copilot/pull/26.patch";
      name = "remove-duplicate-test-hook-and-stop-removing-all-env-vars";
      hash = "sha256-+A/JhHMzLWH/BYN5kYGuDUnosDUwqPjRPYYSgrx/4M0=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_github_copilot" ];

  passthru.tests = llm.mkPluginTest llm-github-copilot;

  meta = {
    description = "LLM plugin providing access to GitHub Copilot";
    homepage = "https://github.com/jmdaly/llm-github-copilot";
    changelog = "https://github.com/jmdaly/llm-github-copilot/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ afh ];
  };
}
