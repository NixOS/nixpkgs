{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, stdenv
, packaging
, setuptools
<<<<<<< HEAD
=======
, importlib-resources
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dbus-next
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
<<<<<<< HEAD
  version = "3.5.6";
=======
  version = "3.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-txUWRCWLQ6jWrdEJ/D5+CsflNad5Onr/wLycENri1z8=";
=======
    hash = "sha256-IZY5vGQoJHcnMBcPjsrYYyuBI4WWyLCRZ/PC3TeVX9k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
