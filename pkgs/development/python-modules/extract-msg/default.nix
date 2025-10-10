{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  compressed-rtf,
  ebcdic,
  fetchFromGitHub,
  olefile,
  pytestCheckHook,
  pythonOlder,
  red-black-tree-mod,
  rtfde,
  setuptools,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "extract-msg";
  version = "0.55.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "TeamMsgExtractor";
    repo = "msg-extractor";
    tag = "v${version}";
    hash = "sha256-n/v3ubgzWlWqLXZfy1O7+FvTJoLMtgL7DFPL39SZnfM=";
  };

  pythonRelaxDeps = [
    "olefile"
    "red-black-tree-mod"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    beautifulsoup4
    compressed-rtf
    ebcdic
    olefile
    red-black-tree-mod
    rtfde
    tzlocal
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "extract_msg" ];

  enabledTestPaths = [ "extract_msg_tests/*.py" ];

  meta = with lib; {
    description = "Extracts emails and attachments saved in Microsoft Outlook's .msg files";
    homepage = "https://github.com/TeamMsgExtractor/msg-extractor";
    changelog = "https://github.com/TeamMsgExtractor/msg-extractor/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
