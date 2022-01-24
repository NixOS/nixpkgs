{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b9390eab696bdf569639ff58794fb9ef8ff19f94feea5b505a6ba06d0cfd026";
  };

  propagatedBuildInputs = [
    genshi
    lxml
    python_magic
  ];

  meta = {
    homepage = "https://relatorio.tryton.org/";
    description = "A templating library able to output odt and pdf files";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl3;
  };
}
