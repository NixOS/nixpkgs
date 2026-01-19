{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  compressed-rtf,
  ebcdic,
  olefile,
  red-black-tree-mod,
  rtfde,
  tzlocal,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "extract-msg";
  version = "0.55.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TeamMsgExtractor";
    repo = "msg-extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n/v3ubgzWlWqLXZfy1O7+FvTJoLMtgL7DFPL39SZnfM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "beautifulsoup4"
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

  meta = {
    description = "Extracts emails and attachments saved in Microsoft Outlook's .msg files";
    homepage = "https://github.com/TeamMsgExtractor/msg-extractor";
    changelog = "https://github.com/TeamMsgExtractor/msg-extractor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
