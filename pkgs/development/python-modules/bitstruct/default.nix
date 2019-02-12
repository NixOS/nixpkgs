{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1znqgy2ikdqn6n6mv1ccfbl0q7x65bh3i9ph0yjl4rihwvxyg9fg";
  };

  meta = with lib; {
    homepage = https://github.com/eerimoq/bitstruct;
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
