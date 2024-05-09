{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, stdenv
, packaging
, setuptools
, dbus-next
, rubicon-objc
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
  version = "3.5.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-txUWRCWLQ6jWrdEJ/D5+CsflNad5Onr/wLycENri1z8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals stdenv.isLinux [
    dbus-next
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rubicon-objc
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
  };
}
