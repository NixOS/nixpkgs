{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  base58,
  beautifulsoup4,
  bech32,
  brotli,
  colorama,
  cryptography,
  gitpython,
  humanfriendly,
  lxml,
  numpy,
  odfpy,
  onnxruntime,
  openpyxl,
  pandas,
  pdfminer-six,
  pybase62,
  pyjks,
  pysquashfsimage,
  python-dateutil,
  python-docx,
  python-pptx,
  pyxlsb,
  pyyaml,
  rpmfile,
  striprtf,
  whatthepatch,
  xlrd,
  # < python 3.14 only:
  zstandard,

  # tests
  deepdiff,
  hypothesis,
  psutil,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "credsweeper";
  version = "1.17.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "CredSweeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JsKwmzC9kMF3dkYVFrLDxYsxOc5X13pFN9aealZEgqY=";
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
    pyjks
    pysquashfsimage
    python-dateutil
    python-docx
    python-pptx
    pyxlsb
    pyyaml
    rpmfile
    striprtf
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
