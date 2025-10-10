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
    sha256 = "0vhjwn0dan3zmffvh80dxb4x67jysvvf1imp6pk4dsfslpwy0bk2";
  };

  # Tests are outdated
  doCheck = false;

  meta = with lib; {
    description = "Framework for developing console applications using Python and curses";
    homepage = "https://www.npcole.com/npyscreen/";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.bsd3;
  };
}
