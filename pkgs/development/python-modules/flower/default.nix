{
  lib,
  buildPythonPackage,
  fetchPypi,
  celery,
  humanize,
  pytz,
  tornado,
  prometheus-client,
  pytestCheckHook,
  redis,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "flower";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xPR1GUL/i1Bp5mBKE24HO4YJcbdliFm9xh2h3BekuzI=";
  };

  postPatch = ''
    # rely on using example programs (flowers/examples/tasks.py) which
    # are not part of the distribution
    rm tests/load.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    celery
    humanize
    prometheus-client
    pytz
    tornado
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    redis
  ];

  pythonImportsCheck = [ "flower" ];

  meta = {
    changelog = "https://github.com/mher/flower/releases/tag/v${finalAttrs.version}";
    description = "Real-time monitor and web admin for Celery distributed task queue";
    homepage = "https://github.com/mher/flower";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
})
