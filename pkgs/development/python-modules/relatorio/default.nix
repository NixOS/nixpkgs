{ lib, fetchurl, buildPythonPackage, genshi, lxml }:

buildPythonPackage rec {
  pname = "relatorio";
  name = "${pname}-${version}";
  version = "0.6.4";
  src = fetchurl {
    url = "mirror://pypi/r/relatorio/${name}.tar.gz";
    sha256 = "0lincq79mzgazwd9gh41dybjh9c3n87r83pl8nk3j79aihyfk84z";
  };
  propagatedBuildInputs = [
    genshi
    lxml
  ];
  meta = {
    homepage = http://relatorio.tryton.org/;
    description = "A templating library able to output odt and pdf files";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl3;
  };
}
