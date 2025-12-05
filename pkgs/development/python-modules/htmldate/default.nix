{
  lib,
  buildPythonPackage,
  charset-normalizer,
  dateparser,
  faust-cchardet,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "htmldate";
  version = "1.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "htmldate";
    tag = "v${version}";
    hash = "sha256-ZSHQgj6zXmLdqDQWGnh2l70iXzdohsxdAIQGDSBufIA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    dateparser
    lxml
    python-dateutil
    urllib3
  ];

  pythonRelaxDeps = [ "lxml" ];

  optional-dependencies = {
    speed = [
      faust-cchardet
      urllib3
    ]
    ++ urllib3.optional-dependencies.brotli;
    all = [
      faust-cchardet
      urllib3
    ]
    ++ urllib3.optional-dependencies.brotli;
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests that require an internet connection
    "test_input"
    "test_cli"
    "test_download"
    "test_readme_examples"
  ];

  pythonImportsCheck = [ "htmldate" ];

  meta = with lib; {
    description = "Module for the extraction of original and updated publication dates from URLs and web pages";
    homepage = "https://htmldate.readthedocs.io";
    changelog = "https://github.com/adbar/htmldate/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jokatzke ];
    mainProgram = "htmldate";
  };
}
