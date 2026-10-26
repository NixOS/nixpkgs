{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "npyscreen";
  version = "4.10.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Yi7g+aXa6UbmNbfG4PbWXh7TyeoNILidq39Y1YDlEm4=";
  };

  # Tests are outdated
  doCheck = false;

  meta = {
    description = "Framework for developing console applications using Python and curses";
    homepage = "https://www.npcole.com/npyscreen/";
    maintainers = with lib.maintainers; [ dump_stack ];
    license = lib.licenses.bsd3;
  };
})
