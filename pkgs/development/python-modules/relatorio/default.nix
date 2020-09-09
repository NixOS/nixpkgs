{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0753e78b235b1e8da275509351257a861cf2cf9fafe1b414f8c1deb858a4f94e";
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
