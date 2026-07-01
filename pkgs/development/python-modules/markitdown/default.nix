{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  azure-ai-documentintelligence,
  azure-identity,
  beautifulsoup4,
  charset-normalizer,
  defusedxml,
  lxml,
  magika,
  mammoth,
  markdownify,
  olefile,
  openpyxl,
  pandas,
  pdfminer-six,
  pdfplumber,
  pydub,
  python-pptx,
  requests,
  speechrecognition,
  xlrd,
  youtube-transcript-api,

  # tests
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

let
  isNotAarch64Linux = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
in
buildPythonPackage (finalAttrs: {
  pname = "markitdown";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pLL44w2jVj5X5/TmPqSveQe/9WLj0ddDUYPoSQlz+9E=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/markitdown";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "magika"
    "mammoth"
    "youtube-transcript-api"
  ];

  optional-dependencies = {
    all = [
      python-pptx
      mammoth
      pandas
      openpyxl
      xlrd
      lxml
      pdfminer-six
      pdfplumber
      olefile
      pydub
      speechrecognition
      youtube-transcript-api
      azure-ai-documentintelligence
      azure-identity
    ];
    pptx = [ python-pptx ];
    docx = [
      mammoth
      lxml
    ];
    xlsx = [
      pandas
      openpyxl
    ];
    xls = [
      pandas
      xlrd
    ];
    pdf = [
      pdfminer-six
      pdfplumber
    ];
    outlook = [ olefile ];
    audio-transcription = [
      pydub
      speechrecognition
    ];
    youtube-transcription = [ youtube-transcript-api ];
    az-doc-intel = [
      azure-ai-documentintelligence
      azure-identity
    ];
  };

  dependencies = [
    beautifulsoup4
    requests
    markdownify
    magika
    charset-normalizer
    defusedxml
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  #
  # -> Skip all tests that require importing markitdown
  pythonImportsCheck = lib.optionals isNotAarch64Linux [ "markitdown" ];
  doCheck = isNotAarch64Linux;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require network access
    "test_markitdown_remote"
    "test_module_vectors"
    "test_cli_vectors"
    "test_module_misc"

    # Require optional azure-ai-contentunderstanding, unavailable in nixpkgs.
    # The fallback stubs hit `UserAgentPolicy() takes no arguments`.
    "test_nonexistent_analyzer_raises_value_error"
    "test_cu_registered_before_docintel"
  ];

  passthru.updateScript = gitUpdater {
    # Drop the "v" tag prefix before version comparison.
    rev-prefix = "v";
    # Skip PEP 440 pre-release tags.
    ignoredVersions = "(a|b|rc)[0-9]+$";
  };

  meta = {
    description = "Python tool for converting files and office documents to Markdown";
    homepage = "https://github.com/microsoft/markitdown";
    changelog = "https://github.com/microsoft/markitdown/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
  };
})
