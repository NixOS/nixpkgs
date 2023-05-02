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
  version = "3.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-l7Ykja1LDtbRt65wI1LjGkxxs3oMvN3bKqveGNZ5Fgc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.9") [
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
