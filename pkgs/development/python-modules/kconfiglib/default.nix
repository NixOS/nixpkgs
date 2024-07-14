{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "14.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vtLMIhb1OOykJVqDpFiNiCNWPN1QEU+GzxomdOYCyTw=";
  };

  # doesnt work out of the box but might be possible
  doCheck = false;

  meta = with lib; {
    description = "Flexible Python 2/3 Kconfig implementation and library";
    homepage = "https://github.com/ulfalizer/Kconfiglib";
    license = licenses.isc;
    maintainers = with maintainers; [ teto ];
  };
}
