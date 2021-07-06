{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, urwid
}:

buildPythonPackage rec {
  pname = "hachoir";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    sha256 = "06544qmmimvaznwcjs8wwfih1frdd7anwcw5z07cf69l8p146p0y";
  };

  propagatedBuildInputs = [
    urwid
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hachoir" ];

  meta = with lib; {
    description = "Python library to view and edit a binary stream";
    homepage = "https://hachoir.readthedocs.io/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
