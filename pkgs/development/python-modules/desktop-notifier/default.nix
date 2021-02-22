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
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D8/amC6SwXkm8Ao8G2Vn9FNpbqyFJFBUVcngkW5g8k0=";
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
