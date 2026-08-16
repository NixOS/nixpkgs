{
  lib,
  buildPythonPackage,
  charset-normalizer,
  dateparser,
  faust-cchardet,
  fetchFromGitHub,
  fetchpatch,
  lxml,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "htmldate";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "htmldate";
    tag = "v${version}";
    hash = "sha256-3qtksgzqcgWtUv81Aqeh0nTWYnH0PjPLG4NuYChbV0g=";
  };

  patches = [
    # https://github.com/adbar/htmldate/pull/199
    (fetchpatch {
      name = "fix-tests-with-dateparser-1.4.2.patch";
      url = "https://github.com/adbar/htmldate/commit/14c70c4944f1a6950bedaf8b6e46b6ec726984b8.patch";
      hash = "sha256-rtRUk9lGsNQyOZ5RAjvMP5JRa4WGWdo0Xzh0OvskYPs=";
    })
  ];

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

  meta = {
    description = "Module for the extraction of original and updated publication dates from URLs and web pages";
    homepage = "https://htmldate.readthedocs.io";
    changelog = "https://github.com/adbar/htmldate/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
    mainProgram = "htmldate";
  };
}
