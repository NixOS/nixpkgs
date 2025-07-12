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
  version = "6.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "desktop-notifier";
    tag = "v${version}";
    hash = "sha256-COPJHMURwb76p5a5w1/i1xL7B8f2GWGfXXeWW/GUxeY=";
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
    changelog = "https://github.com/samschott/desktop-notifier/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sfrijters ];
  };
}
