{ lib
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
=======
, isPy27
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imap-tools";
<<<<<<< HEAD
  version = "1.2.0";

  disabled = pythonOlder "3.5";
=======
  version = "1.0.0";

  disabled = isPy27;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-FC4uvBqQ9Lqpvj94ByM7LYiqqjAQQljYduBxwum49lI=";
=======
    hash = "sha256-JAMEJv0Vc5iunuKusyD+rxLiubEIDgHsr7FrMZgLy9Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
