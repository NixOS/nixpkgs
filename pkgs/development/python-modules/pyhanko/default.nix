{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, asn1crypto
, click
, cryptography
, pyhanko-certvalidator
, pytz
, pyyaml
, qrcode
, requests
, tzlocal
, certomancer
, freezegun
, python-pae
, pytest-aiohttp
, requests-mock
, pytestCheckHook
# Flags to add to the library
, extraPubkeyAlgsSupport ? false
, oscrypto
, opentypeSupport ? false
, fonttools
, uharfbuzz
, imageSupport ? false
, pillow
, python-barcode
, pkcs11Support ? false
, python-pkcs11
, asyncHttpSupport ? false
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyhanko";
  version = "0.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyHanko";
    rev = version;
    sha256 = "sha256-W60NTKEtCqJ/QdtNiieKUsrl2jIjIH86Wych68R3mBc=";
  };

  propagatedBuildInputs = [
    click
    pyhanko-certvalidator
    pytz
    pyyaml
    qrcode
    tzlocal
  ] ++ lib.optionals (extraPubkeyAlgsSupport) [
    oscrypto
  ] ++ lib.optionals (opentypeSupport) [
    fonttools
    uharfbuzz
  ] ++ lib.optionals (imageSupport) [
    pillow
    python-barcode
  ] ++ lib.optionals (pkcs11Support) [
    python-pkcs11
  ] ++ lib.optionals (asyncHttpSupport) [
    aiohttp
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'pytest-runner'" "" \
      --replace "pytest-aiohttp~=0.3.0" "pytest-aiohttp~=1.0.3"
  '';

  checkInputs = [
    aiohttp
    certomancer
    freezegun
    python-pae
    pytest-aiohttp
    requests-mock
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals (!opentypeSupport) [
    "pyhanko_tests/test_stamp.py"
    "pyhanko_tests/test_text.py"
  ] ++ lib.optionals (!imageSupport) [
    "pyhanko_tests/test_barcode.py"
  ] ++ lib.optionals (!pkcs11Support) [
    "pyhanko_tests/test_pkcs11.py"
  ];

  disabledTests = [
    # Most of the test require working with local certificates,
    # contacting OSCP or performing requests
    "test_generic_data_sign_legacy"
    "test_generic_data_sign"
    "test_cms_v3_sign"
    "test_detached_cms_with_self_reported_timestamp"
    "test_detached_cms_with_tst"
    "test_detached_cms_with_content_tst"
    "test_detached_cms_with_wrong_content_tst"
    "test_detached_with_malformed_content_tst"
    "test_noop_attribute_prov"
    "test_detached_cades_cms_with_tst"
    "test_read_qr_config"
    "test_no_changes_policy"
    "test_bogus_metadata_manipulation"
    "test_tamper_sig_obj"
    "test_signed_file_diff_proxied_objs"
    "test_pades_revinfo_live"
    "test_diff_fallback_ok"
    "test_no_diff_summary"
    "test_ocsp_embed"
    "test_ts_fetch_aiohttp"
    "test_ts_fetch_requests"
  ];

  pythonImportsCheck = [
    "pyhanko"
  ];

  meta = with lib; {
    description = "Sign and stamp PDF files";
    homepage = "https://github.com/MatthiasValvekens/pyHanko";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
