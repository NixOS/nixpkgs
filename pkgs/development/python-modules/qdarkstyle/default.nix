{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.6.5";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "96b14cd0440a0f73db4e14c5accdaa08072625d0395ae011d444508cbd73eb9e";
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
