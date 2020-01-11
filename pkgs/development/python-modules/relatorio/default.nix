{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q93sl7ppfvjxylgq9m5n4xdgv4af7d69yxd84zszq10vjmpsg6k";
  };

  propagatedBuildInputs = [
    genshi
    lxml
    python_magic
  ];

  meta = {
    homepage = https://relatorio.tryton.org/;
    description = "A templating library able to output odt and pdf files";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.gpl3;
  };
}
