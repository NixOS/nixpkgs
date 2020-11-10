{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p9d5242pkzag7ac5b5zdjyfqwxvj2jisyjghp6yhjbbwz1z44rb";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
