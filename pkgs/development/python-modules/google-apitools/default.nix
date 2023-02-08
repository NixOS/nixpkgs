{ lib
, buildPythonPackage
, fasteners
, fetchFromGitHub
, gflags
, httplib2
, mock
, oauth2client
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "google-apitools";
  version = "0.5.32";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "apitools";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z9BTDU6KKCcjspVLi5mJqVZMYEapnMXLPL5BXsIKZAw=";
  };

  propagatedBuildInputs = [
    fasteners
    httplib2
    oauth2client
    six
  ];

  passthru.optional-dependencies = {
    cli = [
      gflags
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "apitools"
  ];

  disabledTests = [
    # AttributeError: 'FieldList' object has no attribute '_FieldList__field'
    "testPickle"
    "testDecodeBadBase64BytesField"
    "testConvertIdThatNeedsEscaping"
    "testGeneration"
  ];

  disabledTestPaths = [
    # Samples are partially postfixed with test
    "samples"
  ];

  meta = with lib; {
    description = "Collection of utilities to make it easier to build client-side tools";
    homepage = "https://github.com/google/apitools";
    changelog = "https://github.com/google/apitools/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
