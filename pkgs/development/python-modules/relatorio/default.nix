{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d5d08f5323a1cdf6d860cd13c3408482a822d9924899927a8c7cd2ebeaa8699";
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
