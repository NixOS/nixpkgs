{ lib
, isPy3k
, fetchPypi
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "0.9.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PLlteCJtCPDTvwnvyvMw0jkCSSAG4YssBlWOi4a/f68=";
  };

  meta = with lib; {
    description = "A fast, extensible Markdown parser in pure Python.";
    homepage = "https://github.com/miyuchina/mistletoe";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
