{
  lib,
  base58,
  beautifulsoup4,
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
  nix-update-script,
  numpy,
  odfpy,
  onnxruntime,
  openpyxl,
  pandas,
  pdfminer-six,
  pybase62,
  pyjks,
  pytestCheckHook,
  python-dateutil,
  python-docx,
  python-pptx,
  pyxlsb,
  pyyaml,
  rpmfile,
  striprtf,
  whatthepatch,
  xlrd,
}:

buildPythonPackage (finalAttrs: {
  pname = "credsweeper";
  version = "1.16.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "CredSweeper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DiIT7DzH6ut/Ax2qgga5vKjeXocROGbHdARLWJijejY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    base58
    beautifulsoup4
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
    python-dateutil
    python-docx
    python-pptx
    pyxlsb
    pyyaml
    rpmfile
    striprtf
    whatthepatch
    xlrd
  ];

  nativeCheckInputs = [
    deepdiff
    hypothesis
    pytestCheckHook
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
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to detect credentials in any directories or files";
    homepage = "https://github.com/Samsung/CredSweeper";
    changelog = "https://github.com/Samsung/CredSweeper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "credsweeper";
  };
})
