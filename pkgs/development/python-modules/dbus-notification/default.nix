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
  pname = "dbus-notification";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dbus_notification";
    inherit (finalAttrs) version;
    hash = "sha256-W/503FQPlOdV7gXOCn8obpSGhXmrIeGzScZfeKNk30g=";
  };

  build-system = [ setuptools ];

  dependencies = [ jeepney ];

  # Upstream ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "dbus_notification" ];

  meta = {
    description = "Sends notifications using DBus";
    homepage = "https://github.com/bkbilly/dbus_notification";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
