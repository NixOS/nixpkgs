{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.6.6";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "1jbvvg36fnbvpzvg4ns7zx5jj8h1xsqdr05v5m98a0a9r8awdx3m";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = https://github.com/ColinDuquesnoy/QDarkStyleSheet;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
