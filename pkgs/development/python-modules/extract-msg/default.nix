{ lib
, beautifulsoup4
, buildPythonPackage
, compressed-rtf
, ebcdic
, fetchFromGitHub
, olefile
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, red-black-tree-mod
, rtfde
, setuptools
, tzlocal
}:

buildPythonPackage rec {
  pname = "extract-msg";
  version = "0.48.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TeamMsgExtractor";
    repo = "msg-extractor";
    rev = "refs/tags/v${version}";
    hash = "sha256-qCOi4CRBGF5MuGcHVUk+zb76pchZXbE1cBUIlzl9++w=";
  };

  pythonRelaxDeps = [
    "olefile"
    "red-black-tree-mod"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    compressed-rtf
    ebcdic
    olefile
    red-black-tree-mod
    rtfde
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "extract_msg"
  ];

  pytestFlagsArray = [
    "extract_msg_tests/*.py"
  ];

  meta = with lib; {
    description = "Extracts emails and attachments saved in Microsoft Outlook's .msg files";
    homepage = "https://github.com/TeamMsgExtractor/msg-extractor";
    changelog = "https://github.com/TeamMsgExtractor/msg-extractor/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
