{ lib, fetchPypi, buildPythonPackage, ... }:
buildPythonPackage rec {
  pname = "pygtrie";
  version = "2.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IDUUrYJutAPasdLi3dA04NFTS75NvgITuwWT9mvrpOI=";
  };
  meta = {
    homepage = "https://github.com/mina86/pygtrie";
    description = "Trie data structure implementation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
