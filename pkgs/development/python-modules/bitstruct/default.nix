{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e7b8769c0f09fee403d0a5f637f8b575b191a79a92e140811aa109ce7461f0c";
  };

  meta = with lib; {
    homepage = "https://github.com/eerimoq/bitstruct";
    description = "Python bit pack/unpack package";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
