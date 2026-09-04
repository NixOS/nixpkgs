{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  httpx,

  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "nhl-api-py";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coreyjs";
    repo = "nhl-api-py";
    tag = finalAttrs.version;
    hash = "sha256-P2AQWPMuuzaE3k/xKnyR33kyLUaW8+h6lm1M8Wm8lyA=";
  };

  build-system = [ poetry-core ];
  dependencies = [ httpx ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Wrapper for NHL API: EDGE statistics, scores, schedules and more";
    homepage = "https://github.com/coreyjs/nhl-api-py";
    changelog = "https://github.com/coreyjs/nhl-api-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
