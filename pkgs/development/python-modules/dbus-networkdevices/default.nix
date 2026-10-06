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
  pname = "dbus-networkdevices";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dbus_networkdevices";
    inherit (finalAttrs) version;
    hash = "sha256-SrKC+KZsgrOQ18WO8PfTk6GObObM2KJNN6ppJr32EIU=";
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
