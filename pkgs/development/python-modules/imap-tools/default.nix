{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "imap-tools";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-6Vhzwpb5DiSuF1LPUgkE+EfKMkAR4/Ld26zzj2r1/Ic=";
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
  ];

  pythonImportsCheck = [ "imap_tools" ];

  meta = with lib; {
    description = "Work with email and mailbox by IMAP";
    homepage = "https://github.com/ikvk/imap_tools";
    changelog = "https://github.com/ikvk/imap_tools/blob/v${version}/docs/release_notes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
