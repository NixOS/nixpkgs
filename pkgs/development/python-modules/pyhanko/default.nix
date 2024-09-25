{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asn1crypto,
  click,
  cryptography,
  pyhanko-certvalidator,
  pyyaml,
  qrcode,
  requests,
  tzlocal,

  # optional-dependencies
  oscrypto,
  defusedxml,
  fonttools,
  uharfbuzz,
  pillow,
  python-barcode,
  python-pkcs11,
  aiohttp,
  xsdata,

  # tests
  certomancer,
  freezegun,
  pytest-aiohttp,
  pytestCheckHook,
  python-pae,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "pyhanko";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyHanko";
    rev = "refs/tags/v${version}";
    hash = "sha256-keWAiqwaMZYh92B0mlR4+jjxBKLOAJ9Kgc0l0GiIQbc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    click
    cryptography
    pyhanko-certvalidator
    pyyaml
    qrcode
    requests
    tzlocal
  ];

  optional-dependencies = {
    extra-pubkey-algs = [ oscrypto ];
    xmp = [ defusedxml ];
    opentype = [
      fonttools
      uharfbuzz
    ];
    image-support = [
      pillow
      python-barcode
    ];
    pkcs11 = [ python-pkcs11 ];
    async-http = [ aiohttp ];
    etsi = [ xsdata ];
  };

  nativeCheckInputs = [
    aiohttp
    certomancer
    freezegun
    pytest-aiohttp
    pytestCheckHook
    python-pae
    requests-mock
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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

  pythonImportsCheck = [ "pyhanko" ];

  meta = {
    description = "Sign and stamp PDF files";
    mainProgram = "pyhanko";
    homepage = "https://github.com/MatthiasValvekens/pyHanko";
    changelog = "https://github.com/MatthiasValvekens/pyHanko/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
    # Most tests fail with:
    # OSError: One or more parameters passed to a function were not valid.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
