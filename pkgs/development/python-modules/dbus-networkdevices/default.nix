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
  pname = "dbus-networkdevices";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "dbus_networkdevices";
    tag = finalAttrs.version;
    hash = "sha256-NSV5RowDHd7EtTajmYs8VpBjI38hD8Fwhfpr1QQ2fbg=";
  };

  build-system = [ setuptools ];

  dependencies = [ jeepney ];

  # Upstream ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "dbus_networkdevices" ];

  meta = {
    description = "Connected network devices using DBus";
    homepage = "https://github.com/bkbilly/dbus_networkdevices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
