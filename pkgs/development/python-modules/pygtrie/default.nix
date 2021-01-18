{ lib, fetchPypi, buildPythonPackage, ... }:
buildPythonPackage rec {
  pname = "pygtrie";
  version = "2.4.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "4367b87d92eaf475107421dce0295a9d4d72156702908c96c430a426b654aee7";
  };
  meta = {
    homepage = "https://github.com/mina86/pygtrie";
    description = "Trie data structure implementation";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
