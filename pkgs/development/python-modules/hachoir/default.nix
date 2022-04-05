{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, urwid
}:

buildPythonPackage rec {
  pname = "hachoir";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    sha256 = "sha256-iTYW1jrbrpwPABpID6E/D558056kHCu8jdb8XqKvHK4=";
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
