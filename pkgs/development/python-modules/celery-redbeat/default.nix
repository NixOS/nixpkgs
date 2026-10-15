{
  lib,
  buildPythonPackage,
  celery,
  fakeredis,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pbr,
  redis,
  pytz,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "celery-redbeat";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "redbeat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dva4th7CAvVKA8UeIQdFsDd5xOFxsluVYDzvn5Y5Pi4=";
  };

  build-system = [ pbr ];

  env.PBR_VERSION = finalAttrs.version;

  dependencies = [
    celery
    python-dateutil
    redis
    tenacity
  ];

  nativeCheckInputs = [
    fakeredis
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "redbeat" ];

  meta = {
    description = "Database-backed Periodic Tasks";
    homepage = "https://github.com/sibson/redbeat";
    changelog = "https://github.com/sibson/redbeat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
})
