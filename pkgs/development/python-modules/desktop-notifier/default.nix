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
  version = "3.4.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cqPLnahs3fT6AfQQkS5azh4/cHzaexytg78RsJG5c6U=";
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
