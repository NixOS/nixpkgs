{ lib
, anyascii
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flaky
, google-cloud-storage
, mock
, pillow
, pymongo
, pytestCheckHook
, pythonOlder
, requests
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "filedepot";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "depot";
    rev = "refs/tags/${version}";
    hash = "sha256-vPceky5cvmy3MooWz7dRdy68VoAHN7i3a7egBs4dPE8=";
  };

  patches = [
    # Add support for Pillow 10, https://github.com/amol-/depot/pull/84
    (fetchpatch {
      name = "support-pillow-10.patch";
      url = "https://github.com/amol-/depot/commit/bdb73d1b3898279068b421bc061ecc18c5108fa4.patch";
      hash = "sha256-7+VGrdJstkiy0bYAqA9FjF1NftZiurgyPd8Wlz6GUy8=";
    })
  ];

  propagatedBuildInputs = [
    anyascii
    google-cloud-storage
  ];

  nativeCheckInputs = [
    flaky
    mock
    pillow
    pymongo
    pytestCheckHook
    requests
    sqlalchemy
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'depot._pillow_compat'
    "tests/test_fields_sqlalchemy.py"
    # The examples have tests
    "examples"
    # Missing dependencies (TurboGears2 and ming)
    "tests/test_fields_ming.py"
    "tests/test_wsgi_middleware.py"
  ];

  pythonImportsCheck = [
    "depot"
  ];

  meta = with lib; {
    description = "Toolkit for storing files and attachments in web applications";
    homepage = "https://github.com/amol-/depot";
    changelog = "https://github.com/amol-/depot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
