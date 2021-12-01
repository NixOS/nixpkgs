{ lib, fetchPypi, buildPythonPackage, ... }:
buildPythonPackage rec {
  pname = "pygtrie";
  version = "2.4.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "43205559d28863358dbbf25045029f58e2ab357317a59b11f11ade278ac64692";
  };
  meta = {
    homepage = "https://github.com/mina86/pygtrie";
    description = "Trie data structure implementation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
