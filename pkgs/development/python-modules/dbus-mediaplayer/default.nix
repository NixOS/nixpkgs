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
  pname = "dbus-mediaplayer";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "dbus_mediaplayer";
    tag = finalAttrs.version;
    hash = "sha256-9T6eiszbBjKwxDS+s3SiCz413a6gS7t6oZzetUyRKxA=";
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
