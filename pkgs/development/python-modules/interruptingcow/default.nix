{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "interruptingcow";
  version = "0.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PozVBYtlHmJXAsulPjsft216XsB6tpxSoWep94TjMGw=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Watchdog that interrupts long running code";
    homepage = "https://bitbucket.org/evzijst/interruptingcow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benley ];
  };
})
