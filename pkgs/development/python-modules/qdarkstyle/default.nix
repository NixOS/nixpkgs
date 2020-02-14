{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.8";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "0xfllpwnnxdwvfzrrz3b317vb37n5h1x24nzv6zghij4cr5pr5ka";
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
