{ lib
, stdenv
, backports-cached-property
, blessed
, buildPythonPackage
, cwcwidth
, fetchPypi
, pyte
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YtEPNJxVOEUwZVan8mY86WsJjYxbvEDa7Hpu7d4WIrA=";
  };

  propagatedBuildInputs = [
    blessed
    cwcwidth
  ] ++ lib.optionals (pythonOlder "3.8") [
    backports-cached-property
  ];

  nativeCheckInputs = [
    pyte
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    broken = stdenv.isDarwin;
  };
}
