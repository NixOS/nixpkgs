{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "npyscreen";
  version = "4.10.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Yi7g+aXa6UbmNbfG4PbWXh7TyeoNILidq39Y1YDlEm4=";
  };

  # Tests are outdated
  doCheck = false;

  meta = with lib; {
    description = "Framework for developing console applications using Python and curses";
    homepage = "http://www.npcole.com/npyscreen/";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.bsd3;
  };
}
