{ lib
, betamax
, buildPythonPackage
, fetchPypi
, mock
, pyopenssl
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
  version = "0.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-loCJ1FhK1K18FxRU8KXG2sI5celHJSHqO21J1hCqb8A=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    betamax
    mock
    pyopenssl
    pytestCheckHook
  ];

  disabledTests = [
    "test_no_content_length_header"
    "test_read_file"
    "test_reads_file_from_url_wrapper"
    "test_x509_der"
    "test_x509_pem"
  ];

  pythonImportsCheck = [
    "requests_toolbelt"
  ];

  meta = {
    description = "Toolbelt of useful classes and functions to be used with requests";
    homepage = "http://toolbelt.rtfd.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
