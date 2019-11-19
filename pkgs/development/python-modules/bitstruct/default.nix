{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84893f90eb78f8179af24a87622ef964ede5c7e785562022917033987d6ce198";
  };

  meta = with lib; {
    homepage = https://github.com/eerimoq/bitstruct;
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
