{ lib
, isPy3k
, fetchPypi
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "0.8.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ouNU5lPym8r1WZ2JSFEhGaxgN+nC+O53851VRQ59Gmw=";
  };

  meta = with lib; {
    description = "A fast, extensible Markdown parser in pure Python.";
    homepage = "https://github.com/miyuchina/mistletoe";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
