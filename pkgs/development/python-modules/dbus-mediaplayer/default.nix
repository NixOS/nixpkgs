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
  pname = "dbus-mediaplayer";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dbus_mediaplayer";
    inherit (finalAttrs) version;
    hash = "sha256-LKr/DdnceXfmS7V03HoiOEWshRdFJltoDetYap31ZOU=";
  };

  build-system = [ setuptools ];

  dependencies = [ jeepney ];

  # Upstream ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "dbus_mediaplayer" ];

  meta = {
    description = "Currently playing media using DBus";
    homepage = "https://github.com/bkbilly/dbus_mediaplayer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
