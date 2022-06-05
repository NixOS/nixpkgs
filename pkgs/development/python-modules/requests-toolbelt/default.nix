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

  patches = [
    (fetchpatch {
      # Fix collections.abc deprecation warning, https://github.com/requests/toolbelt/pull/246
      name = "fix-collections-abc-deprecation.patch";
      url = "https://github.com/requests/toolbelt/commit/7188b06330e5260be20bce8cbcf0d5ae44e34eaf.patch";
      sha256 = "sha256-pRkG77sNglG/KsRX6JaPgk4QxmmSBXypFRp/vNA3ot4=";
    })
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
