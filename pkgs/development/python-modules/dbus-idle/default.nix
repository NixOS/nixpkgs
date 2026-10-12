{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "dbus_idle";
    tag = finalAttrs.version;
    hash = "sha256-0ONEXtITw8DKjngPYvC0kMCK8CVHSOAU85wPMsFPQRs=";
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
