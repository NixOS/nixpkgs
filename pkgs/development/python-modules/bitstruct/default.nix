{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45b2b932ce6681f5c6ce8cba39abdd423b579b0568c76fa48b1e09c88368ede7";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
