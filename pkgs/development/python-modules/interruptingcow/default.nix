{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "interruptingcow";
  version = "0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PozVBYtlHmJXAsulPjsft216XsB6tpxSoWep94TjMGw=";
  };

  meta = with lib; {
    description = "Watchdog that interrupts long running code";
    homepage = "https://bitbucket.org/evzijst/interruptingcow";
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
  };
}
