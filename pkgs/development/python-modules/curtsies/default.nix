{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, blessed
, backports-cached-property
, pyte
, pytestCheckHook
, cwcwidth
}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YtEPNJxVOEUwZVan8mY86WsJjYxbvEDa7Hpu7d4WIrA=";
  };

  propagatedBuildInputs = [
    backports-cached-property
    blessed
    cwcwidth
  ];

  checkInputs = [
    pyte
    pytestCheckHook
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
