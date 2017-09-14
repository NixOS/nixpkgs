{ lib, fetchurl, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  name = "${pname}-${version}";
  version = "0.7.0";
  src = fetchurl {
    url = "mirror://pypi/r/relatorio/${name}.tar.gz";
    sha256 = "efd68d96573b15c59c24a8f420ed14210ce51de535a8470d14381f2bed69d845";
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
