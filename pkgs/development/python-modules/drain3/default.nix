{
  lib,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  jsonpickle,
  kafka-python,
  nix-update-script,
  pytestCheckHook,
  redis,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "drain3";
  version = "0.9.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "logpai";
    repo = "Drain3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WLsBoCAW7g4Ofoo88u3wncb9AtohKwLzGR50sVVKd/M=";
  };

  pythonRelaxDeps = [
    "cachetools"
    "jsonpickle"
  ];

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    jsonpickle
    kafka-python
    redis
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "drain3" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Robust streaming log template miner based on the Drain algorithm";
    homepage = "https://github.com/logpai/Drain3";
    changelog = "https://github.com/logpai/Drain3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
