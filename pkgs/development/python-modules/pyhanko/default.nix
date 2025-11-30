{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asn1crypto,
  cryptography,
  lxml,
  pyhanko-certvalidator,
  pyyaml,
  requests,
  tzlocal,

  # optional-dependencies
  fonttools,
  uharfbuzz,
  pillow,
  python-barcode,
  python-pkcs11,
  aiohttp,
  xsdata,
  qrcode,

  # tests
  certomancer,
  freezegun,
  pytest-aiohttp,
  pytestCheckHook,
  python-pae,
  requests-mock,
  signxml,
}:

buildPythonPackage rec {
  pname = "pyhanko";
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyHanko";
    tag = "v${version}";
    hash = "sha256-ZDHAcI2yoiVifYt05V85lz8mJmoyi10g4XoLQ+LhLHE=";
  };

  sourceRoot = "${src.name}/pkgs/pyhanko";

  postPatch = ''
    substituteInPlace src/pyhanko/version/__init__.py \
      --replace-fail "0.0.0.dev1" "${version}" \
      --replace-fail "(0, 0, 0, 'dev1')" "tuple(\"${version}\".split(\".\"))"
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0.dev1" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    cryptography
    pyhanko-certvalidator
    pyyaml
    requests
    tzlocal
    lxml
  ];

  optional-dependencies = {
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
    etsi = [
      xsdata
      signxml
    ];
    qr = [ qrcode ];
  };

  nativeCheckInputs = [
    aiohttp
    certomancer
    freezegun
    pytest-aiohttp
    pytestCheckHook
    python-pae
    requests-mock
    passthru.testData
    signxml
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'csc_dummy'
    "tests/test_csc.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: One or more parameters passed to a function were not valid.
    "tests/cli_tests"
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

    # https://github.com/MatthiasValvekens/pyHanko/pull/595
    "test_simple_text_stamp_on_page_with_leaky_graphics_state"
    "test_simple_text_stamp_on_page_with_leaky_graphics_state_without_coord_correction"
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

  passthru = {
    testData = buildPythonPackage {
      pname = "common-test-utils";
      inherit version pyproject src;

      sourceRoot = "${src.name}/internal/common-test-utils";
      # Include the test pdf/xml files etc. in the build output
      postPatch = ''
        echo "graft src/test_data" > MANIFEST.in
      '';

      build-system = [ setuptools ];

      dependencies = [
        certomancer
        pyhanko-certvalidator
      ];

      pythonRemoveDeps = [ "pyhanko" ];
    };
  };

  meta = {
    description = "Sign and stamp PDF files";
    homepage = "https://github.com/MatthiasValvekens/pyHanko";
    changelog = "https://github.com/MatthiasValvekens/pyHanko/blob/${src.tag}/docs/changelog.rst#pyhanko";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antonmosich ];
  };
}
