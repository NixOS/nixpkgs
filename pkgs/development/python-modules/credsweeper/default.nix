{
  lib,
  stdenv,
  base58,
  beautifulsoup4,
  bech32,
  brotli,
  buildPythonPackage,
  colorama,
  cryptography,
  deepdiff,
  fetchFromGitHub,
  gitpython,
  hatchling,
  humanfriendly,
  hypothesis,
  lxml,
  numpy,
  odfpy,
  onnxruntime,
  openpyxl,
  pandas,
  pdfminer-six,
  psutil,
  pybase62,
  pygments,
  pyjks,
  pysquashfsimage,
  pytestCheckHook,
  python-dateutil,
  python-docx,
  python-pptx,
  pythonOlder,
  pyxlsb,
  pyyaml,
  rpmfile,
  striprtf,
  tqdm,
  versionCheckHook,
  whatthepatch,
  xlrd,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "credsweeper";
  version = "1.18.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "CredSweeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JurMfb4CZGDUDmjkd+dKngoOnv9u2VU8rAst2HijZh0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    base58
    beautifulsoup4
    bech32
    brotli
    colorama
    cryptography
    gitpython
    humanfriendly
    lxml
    numpy
    odfpy
    onnxruntime
    openpyxl
    pandas
    pdfminer-six
    pybase62
    pygments
    pyjks
    pysquashfsimage
    python-dateutil
    python-docx
    python-pptx
    pyxlsb
    pyyaml
    rpmfile
    striprtf
    tqdm
    whatthepatch
    xlrd
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    zstandard
  ];

  nativeCheckInputs = [
    deepdiff
    hypothesis
    psutil
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "credsweeper" ];

  disabledTests = [
    # Probability tests
    "test_data_p"
    "test_data_scan_depth_3_pedantic_p"
    "test_data_scan_doc_p"
    "test_data_scan_no_filters_p"
    "test_data_scan_output_p"
    "test_depth_n"
    "test_depth_p"
    "test_match_n"
    "test_multi_jobs_p"
    "test_rules_ml_p"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_external_ml_n"
    "test_external_ml_p"
    "test_import_config_n"
    "test_import_config_p"
    "test_it_works_n"
    "test_log_n"
    "test_log_p"
  ];

  meta = {
    description = "Tool to detect credentials in any directories or files";
    homepage = "https://github.com/Samsung/CredSweeper";
    changelog = "https://github.com/Samsung/CredSweeper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "credsweeper";
  };
})
