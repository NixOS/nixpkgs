{ lib
, isPy3k
, fetchPypi
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "0.8.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "468c6a42fd98b85e05b318033f63d76e02712e1ea1328a7ebcba7e47fb6f1e41";
  };

  meta = with lib; {
    description = "A fast, extensible Markdown parser in pure Python.";
    homepage = "https://github.com/miyuchina/mistletoe";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
