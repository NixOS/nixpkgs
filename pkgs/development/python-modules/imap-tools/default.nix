{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imap-tools";
  version = "0.52.0";

  disabled = isPy27;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ikvk";
    repo = "imap_tools";
    rev = "v${version}";
    hash = "sha256-la2+cpTnHZQn/FXtySp+3zDCBTONiLC16Tm+hDiIERc=";
  };

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
