{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "imap-tools";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lPVluJCxW5skrgT6Ih23pbRSkfH7+6KuYXk773EVj3w=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # tests require a network connection
    "test_action"
    "test_attributes"
    "test_connection"
    "test_folders"
    "test_idle"
    "test_live"
    # broken on Python 3.14.7
    # reported upstream: https://github.com/ikvk/imap_tools/issues/271
    "test_login_quotes_plain_username"
    "test_login_quotes_username_with_special_chars"
  ];

  pythonImportsCheck = [ "imap_tools" ];

  meta = {
    description = "Work with email and mailbox by IMAP";
    homepage = "https://github.com/ikvk/imap_tools";
    changelog = "https://github.com/ikvk/imap_tools/blob/${finalAttrs.src.tag}/docs/release_notes.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
