{ lib, fetchPypi, buildPythonPackage, isPy3k
, nbformat, nbconvert, pyyaml, fastscript, packaging }:

buildPythonPackage rec {
  pname = "nbdev";
  version = "0.2.12";
  disabled = !isPy3k;

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "0lp6f1z5l6lbbsi9fdgm10a942zjpj58l9g84w377fiaz3mn8yvn";

    python = "py3";
  };

  propagatedBuildInputs = [
    nbformat nbconvert pyyaml fastscript packaging
  ];

  meta = with lib; {
    description = "Converting Jupyter Notebooks";
    homepage = "https://nbdev.fast.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
