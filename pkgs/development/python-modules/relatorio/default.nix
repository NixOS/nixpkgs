{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.8.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "149a1c4c2a35d9b9e634fe80cac405bc9b4c03a42f818302362183515e7e835d";
  };
  propagatedBuildInputs = [
    genshi
    lxml
    python_magic
  ];
  meta = {
    homepage = http://relatorio.tryton.org/;
    description = "A templating library able to output odt and pdf files";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl3;
  };
}
