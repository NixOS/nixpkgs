{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e4fZ5B/1UqjK4G6iNow3crbzECvatLZeeTvnWQ1p8Ds=";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
