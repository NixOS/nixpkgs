{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2024.2.26";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-1CLkTFR+/XQ428WjMF7wliyAG6CB+n8JSsLDdLHPO7I=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html2text" ];

  meta = with lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    mainProgram = "html2text";
    homepage = "https://github.com/Alir3z4/html2text/";
    license = licenses.gpl3Only;
  };
}
