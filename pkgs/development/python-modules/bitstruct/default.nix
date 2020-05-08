{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dncll29a0lx8hn1xlhr32abkvj1rh8xa6gc0aas8wnqzh7bvqqm";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
