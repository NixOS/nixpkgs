{
  lib,
  buildPythonPackage,
  celery,
  fakeredis,
  fetchPypi,
  pbr,
  pytestCheckHook,
  python-dateutil,
  pytz,
  redis,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "celery-redbeat";
  version = "2.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "celery_redbeat";
    inherit version;
    hash = "sha256-9SZktJCykjp4fZ80jykSQ2AUML+Ow4O255hwoXMe6So=";
  };

  env.PBR_VERSION = version;

  build-system = [ setuptools ];
  nativeBuildInputs = [ pbr ];

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
    description = "Celery Beat scheduler backed by Redis";
    homepage = "https://github.com/sibson/redbeat";
    changelog = "https://github.com/sibson/redbeat/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
