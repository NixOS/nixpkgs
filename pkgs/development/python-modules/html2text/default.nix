{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2024.2.26";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Alir3z4";
    repo = "html2text";
    rev = "refs/tags/${version}";
    sha256 = "sha256-1CLkTFR+/XQ428WjMF7wliyAG6CB+n8JSsLDdLHPO7I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html2text" ];

  meta = with lib; {
    changelog = "https://github.com/Alir3z4/html2text/blob/${src.rev}/ChangeLog.rst";
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = "https://github.com/Alir3z4/html2text/";
    license = licenses.gpl3Only;
    mainProgram = "html2text";
    maintainers = [ ];
  };
}
