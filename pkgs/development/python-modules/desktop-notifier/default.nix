{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  bidict,
  packaging,
  typing-extensions,
  dbus-fast,
  rubicon-objc,
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "desktop-notifier";
    tag = "v${version}";
    hash = "sha256-cSeEekjX9NeoEoe9mDokCanK5zrawyvdHK1c4RJ9kSk=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      bidict
      packaging
      typing-extensions
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ dbus-fast ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rubicon-objc ];

  # no tests available, do the imports check instead
  doCheck = false;

  pythonImportsCheck = [ "desktop_notifier" ];

  meta = {
    description = "Python library for cross-platform desktop notifications";
    homepage = "https://github.com/samschott/desktop-notifier";
    changelog = "https://github.com/samschott/desktop-notifier/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
}
