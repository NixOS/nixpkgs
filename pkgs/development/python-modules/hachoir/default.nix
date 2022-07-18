{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, urwid
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hachoir";
  version = "3.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = version;
    hash = "sha256-HlxDwkU0GccO+IUzbtVpLbsAo+Mcacm4/WrXWCsmpBg=";
  };

  propagatedBuildInputs = [
    urwid
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hachoir"
  ];

  meta = with lib; {
    description = "Python library to view and edit a binary stream";
    homepage = "https://hachoir.readthedocs.io/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
