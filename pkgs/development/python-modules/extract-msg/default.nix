{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  compressed-rtf,
  ebcdic,
  fetchFromGitHub,
  olefile,
  pypdf,
  pytestCheckHook,
  red-black-tree-mod,
  rtfde,
  setuptools,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "extract-msg";
  version = "0.58.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TeamMsgExtractor";
    repo = "msg-extractor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fXQ0PRk7Fndbxfl/swoNsKZH5uiJWLikdHD70M9c2u0=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "ebcdic"
  ];

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    compressed-rtf
    ebcdic
    olefile
    red-black-tree-mod
    rtfde
    tzlocal
  ];

  nativeCheckInputs = [
    pypdf
    pytestCheckHook
  ];

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
