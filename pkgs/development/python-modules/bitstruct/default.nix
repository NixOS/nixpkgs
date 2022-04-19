{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IwwZHHXxUm9pIs2wjqtvUsBVRS4iOb9WOPAunP04LJE=";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
