{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ndeflib";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nfcpy";
    repo = "ndeflib";
    rev = "refs/tags/v${version}";
    hash = "sha256-cpfztE+/AW7P0J7QeTDfVGYc2gEkr7gzA352hC9bdTM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ndef"
  ];

  disabledTests = [
    # AssertionError caused due to wrong size
    "test_decode_error"
  ];

  meta = with lib; {
    description = "Python package for parsing and generating NFC Data Exchange Format messages";
    homepage = "https://github.com/nfcpy/ndeflib";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
