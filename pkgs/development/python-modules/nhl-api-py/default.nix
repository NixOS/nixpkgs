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
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coreyjs";
    repo = "nhl-api-py";
    tag = finalAttrs.version;
    hash = "sha256-dPwezkUU/0n8JwvCqdNt1LgrbgO6x7M4bqO8G8IzKlw=";
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
