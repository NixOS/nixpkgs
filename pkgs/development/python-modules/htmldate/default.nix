{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, charset-normalizer
, dateparser
, lxml
, pytestCheckHook
, python-dateutil
, urllib3
, backports-datetime-fromisoformat
}:

buildPythonPackage rec {
  pname = "htmldate";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Ux9AX9Coc9CLlp8XvEMrLridohjFPJ6mGRkYn8wuxU=";
  };

  propagatedBuildInputs = [
    charset-normalizer
    dateparser
    lxml
    python-dateutil
    urllib3
  ] ++ lib.optionals (pythonOlder "3.7") [
    backports-datetime-fromisoformat
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # disable tests that require an internet connection
  disabledTests = [
    "test_input"
    "test_cli"
    "test_download"
  ];

  pythonImportsCheck = [ "htmldate" ];

  meta = with lib; {
    description = "Fast and robust extraction of original and updated publication dates from URLs and web pages";
    mainProgram = "htmldate";
    homepage = "https://htmldate.readthedocs.io";
    changelog = "https://github.com/adbar/htmldate/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jokatzke ];
  };
}
