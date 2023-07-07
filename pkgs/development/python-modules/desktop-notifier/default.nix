{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, stdenv
, packaging
, setuptools
, importlib-resources
, dbus-next
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
  version = "3.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rMbXGkI6nVgMPzD/vSbAjfouFb4sQkoBFrLxe7vlcDg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
    importlib-resources
  ] ++ lib.optionals stdenv.isLinux [
    dbus-next
  ];

  # no tests available, do the imports check instead
  doCheck = false;

  pythonImportsCheck = [
    "desktop_notifier"
  ];

  meta = with lib; {
    description = "Python library for cross-platform desktop notifications";
    homepage = "https://github.com/samschott/desktop-notifier";
    changelog = "https://github.com/samschott/desktop-notifier/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
    platforms = platforms.linux;
  };
}
