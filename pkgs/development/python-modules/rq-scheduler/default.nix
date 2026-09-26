{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  freezegun,
  parse-crontab,
  python-dateutil,
  rq,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "rq-scheduler";
  version = "0.14.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LVoUoashf4aTGE66of4Dg47cvHC092VychwLMwWM0CM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    freezegun
    parse-crontab
    python-dateutil
    rq
  ];

  # tests require a running Redis server
  doCheck = false;

  pythonImportsCheck = [ "rq_scheduler" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Job scheduling capabilities for RQ (Redis Queue)";
    homepage = "https://github.com/rq/rq-scheduler";
    changelog = "https://github.com/rq/rq-scheduler/releases/tag/v${lib.versions.majorMinor finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ denzonl ];
  };
})
