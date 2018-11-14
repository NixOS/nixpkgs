{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbfca99bd594a10f674d0cd97a3d802a1fdef635d4361e1a2658de47ed261e3a";
  };

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
