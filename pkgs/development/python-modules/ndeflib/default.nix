{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ndeflib";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nfcpy";
    repo = "ndeflib";
    tag = "v${version}";
    hash = "sha256-cpfztE+/AW7P0J7QeTDfVGYc2gEkr7gzA352hC9bdTM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ndef" ];

  disabledTests = [
    # AssertionError caused due to wrong size
    "test_decode_error"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ "test_encode_error" ];

  meta = with lib; {
    description = "Python package for parsing and generating NFC Data Exchange Format messages";
    homepage = "https://github.com/nfcpy/ndeflib";
    changelog = "https://github.com/nfcpy/ndeflib/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
