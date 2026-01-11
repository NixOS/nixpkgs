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
    sha256 = "3e8cd5058b651e625702cba53e3b1fb76d7a5ec07ab69c52a167a9f784e3306c";
  };

  meta = {
    description = "Watchdog that interrupts long running code";
    homepage = "https://bitbucket.org/evzijst/interruptingcow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benley ];
  };
}
