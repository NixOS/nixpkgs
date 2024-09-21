{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  stdenv,
  bidict,
  packaging,
  setuptools,
  dbus-fast,
  rubicon-objc,
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "desktop-notifier";
    rev = "refs/tags/v${version}";
    hash = "sha256-HynREkiPxv/1y1/ICVwqANIe9tAkIvdpDy4oXxQarec=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      bidict
      packaging
    ]
    ++ lib.optionals stdenv.isLinux [ dbus-fast ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rubicon-objc ];

  # no tests available, do the imports check instead
  doCheck = false;

  pythonImportsCheck = [ "desktop_notifier" ];

  meta = with lib; {
    description = "Python library for cross-platform desktop notifications";
    homepage = "https://github.com/samschott/desktop-notifier";
    changelog = "https://github.com/samschott/desktop-notifier/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
