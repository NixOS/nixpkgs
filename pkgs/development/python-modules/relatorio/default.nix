{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.8.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "bddf85d029c5c85a0f976d73907e14e4c3093065fe8527170c91abf0218546d9";
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
