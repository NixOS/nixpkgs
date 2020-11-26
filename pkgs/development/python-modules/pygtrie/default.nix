{ lib, fetchPypi, buildPythonPackage, ... }:
buildPythonPackage rec {
  pname = "pygtrie";
  version = "2.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "00x7q4p9r75zdnw3a8vd0d0w0i5l28w408g5bsfl787yv6b1h9i8";
  };
  meta = {
    homepage = "https://github.com/mina86/pygtrie";
    description = "Trie data structure implementation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
