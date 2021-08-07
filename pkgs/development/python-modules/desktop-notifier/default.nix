{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, stdenv
, packaging
, importlib-resources
, dbus-next
}:

buildPythonPackage rec {
  pname = "desktop-notifier";
  version = "3.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ROSZorkA2wAp2Ubh3B3KWIUxM/4r7cv/1aSJqeKnPqg=";
  };

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
