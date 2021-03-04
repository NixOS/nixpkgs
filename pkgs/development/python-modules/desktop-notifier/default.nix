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
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b333594af6e54677f9620480226dbc88ec6dd7c004352de9268d01aa49467f4";
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
  };
}
