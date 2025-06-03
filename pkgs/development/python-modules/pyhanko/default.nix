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
  version = "0.25.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyHanko";
    tag = "v${version}";
    hash = "sha256-HJkCQ5YDVr17gtY4PW89ep7GwFdP21/ruBEKm7j3+Qo=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "cryptography"
  ];

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

  disabledTestPaths =
    [
      # ModuleNotFoundError: No module named 'csc_dummy'
      "pyhanko_tests/test_csc.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # OSError: One or more parameters passed to a function were not valid.
      "pyhanko_tests/cli_tests"
    ];

  disabledTests =
    [
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # OSError: One or more parameters passed to a function were not valid.
      "test_detached_cms_with_duplicated_attr"
      "test_detached_cms_with_wrong_tst"
      "test_diff_analysis_add_extensions_dict"
      "test_diff_analysis_update_indirect_extensions_not_all_path"
      "test_no_certificates"
      "test_ocsp_without_nextupdate_embed"
    ];

  pythonImportsCheck = [ "pyhanko" ];

  meta = {
    description = "Sign and stamp PDF files";
    mainProgram = "pyhanko";
    homepage = "https://github.com/MatthiasValvekens/pyHanko";
    changelog = "https://github.com/MatthiasValvekens/pyHanko/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
