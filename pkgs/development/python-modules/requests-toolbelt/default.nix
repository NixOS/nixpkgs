{ lib
, betamax
, buildPythonPackage
, fetchpatch
, fetchPypi
, mock
, pyopenssl
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "requests-toolbelt";
  version = "0.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YuCff/XMvakncqKfOUpJw61ssYHVaLEzdiayq7Yopj0=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    betamax
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/requests/toolbelt/issues/306
    "test_no_content_length_header"
    "test_read_file"
    "test_reads_file_from_url_wrapper"
    "test_x509_der"
    "test_x509_pem"
  ];

  pythonImportsCheck = [
    "requests_toolbelt"
  ];

  meta = with lib; {
    description = "Toolbelt of useful classes and functions to be used with requests";
    homepage = "http://toolbelt.rtfd.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
