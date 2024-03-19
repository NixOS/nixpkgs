{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imap-tools";
  version = "1.5.0";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-kY6Y8Uu1HwSkcmlKL5+zPh4n+4mofX2aoPVXAZvInlI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
