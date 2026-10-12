{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jeepney,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbus-notification";
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "dbus_notification";
    tag = finalAttrs.version;
    hash = "sha256-/lEaaWSqWtWZ1cJKkYQkMBUAw9VaUM+wNzjNHeQGNqU=";
  };

  build-system = [ setuptools ];

  dependencies = [ jeepney ];

  nativeCheckInputs = [ pytestCheckHook ];

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
