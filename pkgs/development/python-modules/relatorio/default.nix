{ lib, fetchPypi, buildPythonPackage, genshi, lxml, python_magic }:

buildPythonPackage rec {
  pname = "relatorio";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oMcjAtUNXfpDPdqxkWcu7B3eHG7SYzCjeLcg5aMBLiM=";
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
