{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, borgbackup
, appdirs
, arrow
, docopt
, inform
, nestedtext
, parametrize-from-file
, quantiphy
, requests
, shlib
, voluptuous
}:

buildPythonPackage rec {
  pname = "emborg";
  version = "1.34";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "emborg";
    rev = "v${version}";
    hash = "sha256-bnlELPZzTU9KyVsz5Q0aW9xWvVrgwpowQrjkQvX844g=";
  };

  propagatedBuildInputs = [
    appdirs
    arrow
    docopt
    inform
    quantiphy
    requests
  ];

  nativeCheckInputs = [
    nestedtext
    parametrize-from-file
    pytestCheckHook
    shlib
    voluptuous
    borgbackup
  ];

  # this disables testing fuse mounts
  MISSING_DEPENDENCIES = "fuse";

  postPatch = ''
    patchShebangs .
  '';

  # this patch fixes a whitespace issue in the message that a test is expecting, https://github.com/KenKundert/emborg/pull/67
  patches = [
    (fetchpatch {
      url = "https://github.com/KenKundert/emborg/commit/afac6d1ddcecdb4bddbec87b6c8eed4cfbf4ebf9.diff";
      sha256 = "3xg2z03FLKH4ckmiBZqE1FDjpgjgdO8OZL1ewrJlQ4o=";
    })
  ];

  pythonImportsCheck = [
    "emborg"
  ];

  meta = with lib; {
    description = "Interactive command line interface to Borg Backup";
    homepage = "https://github.com/KenKundert/emborg";
    changelog = "https://github.com/KenKundert/emborg/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
