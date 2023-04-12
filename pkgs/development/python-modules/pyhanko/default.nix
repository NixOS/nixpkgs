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

# optionals
, defusedxml
, oscrypto
, fonttools
, uharfbuzz
, pillow
, python-barcode
, python-pkcs11
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyhanko";
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # Tests are only available on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyHanko";
    rev = "refs/tags/${version}";
    hash = "sha256-tvb2zdmIN6MkezmLNkyCcP8EfqxrbPg/FEqgW16Ka6Q=";
  };

  propagatedBuildInputs = [
    asn1crypto
    click
    cryptography
    pyhanko-certvalidator
    pytz
    pyyaml
    qrcode
    requests
    tzlocal
  ];

  passthru.optional-dependencies = {
    extra_pubkey_algs = [
      oscrypto
    ];
    xmp = [
      defusedxml
    ];
    opentype = [
      fonttools
      uharfbuzz
    ];
    image-support = [
      pillow
      python-barcode
    ];
    pkcs11 = [
      python-pkcs11
    ];
    async_http = [
      aiohttp
    ];
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'pytest-runner'" "" \
  '';

  nativeCheckInputs = [
    aiohttp
    certomancer
    freezegun
    python-pae
    pytest-aiohttp
    requests-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'csc_dummy'
    "pyhanko_tests/test_csc.py"
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
