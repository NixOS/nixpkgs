{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imap-tools";
  version = "0.41.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    rev = "v${version}";
    sha256 = "sha256-gtfVZTHeiYamKkcu9n/CJ4O4X1YneY2QB3XZnvtNL3U=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # tests require a network connection
    "test_action"
    "test_folders"
    "test_connectio"
    "test_attributes"
    "test_live"
  ];

  pythonImportsCheck = [ "imap_tools" ];

  meta = with lib; {
    description = "Work with email and mailbox by IMAP";
    homepage = "https://github.com/ikvk/imap_tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
