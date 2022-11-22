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
  version = "3.4.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-OujBpq3SBDKw9Jgb9MD200Rp0fD0OJRw90flxS22I2s=";
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
  pythonImportsCheck = [ "desktop_notifier" ];

  meta = with lib; {
    homepage = "https://github.com/samschott/desktop-notifier";
    description = "A Python library for cross-platform desktop notifications";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
    platforms = platforms.linux;
  };
}
