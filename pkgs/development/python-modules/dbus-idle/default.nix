{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  jeepney,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-idle";
  version = "2026.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dbus_idle";
    inherit (finalAttrs) version;
    hash = "sha256-r7vIeB08DgcqsR3DQv+6ggJnxn9XGKCc52moVOhYbH0=";
  };

  build-system = [ setuptools ];

  dependencies = [ jeepney ];

  # Upstream ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "dbus_idle" ];

  meta = {
    description = "System idle time using DBus";
    homepage = "https://github.com/bkbilly/dbus_idle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
