{ lib, fetchurl, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  name = "${pname}-${version}";
  version = "0.7.1";
  src = fetchurl {
    url = "mirror://pypi/r/relatorio/${name}.tar.gz";
    sha256 = "744f1e39313f037a0ab52a154338ece151d83e5442a9278db1f8ce450ce6c2cd";
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
