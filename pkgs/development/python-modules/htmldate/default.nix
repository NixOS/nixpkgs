{ lib
, backports-datetime-fromisoformat
, buildPythonPackage
, charset-normalizer
, dateparser
, faust-cchardet
, fetchPypi
, lxml
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "htmldate";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Ux9AX9Coc9CLlp8XvEMrLridohjFPJ6mGRkYn8wuxU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    charset-normalizer
    dateparser
    lxml
    python-dateutil
    urllib3
  ] ++ lib.optionals (pythonOlder "3.7") [
    backports-datetime-fromisoformat
  ];

  passthru.optional-dependencies = {
    speed = [
      faust-cchardet
      urllib3
    ] ++ lib.optionals (pythonOlder "3.11") [
      backports-datetime-fromisoformat
    ] ++ urllib3.optional-dependencies.brotli;
    all = [
      faust-cchardet
      urllib3
    ] ++ lib.optionals (pythonOlder "3.11") [
      backports-datetime-fromisoformat
    ] ++ urllib3.optional-dependencies.brotli;
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # disable tests that require an internet connection
  disabledTests = [
    "test_input"
    "test_cli"
    "test_download"
  ];

  pythonImportsCheck = [
    "htmldate"
  ];

  meta = with lib; {
    description = "Module for the extraction of original and updated publication dates from URLs and web pages";
    homepage = "https://htmldate.readthedocs.io";
    changelog = "https://github.com/adbar/htmldate/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jokatzke ];
    mainProgram = "htmldate";
  };
}
