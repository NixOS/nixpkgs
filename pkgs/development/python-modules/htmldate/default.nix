{
  lib,
  backports-datetime-fromisoformat,
  buildPythonPackage,
  charset-normalizer,
  dateparser,
  faust-cchardet,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "htmldate";
  version = "1.9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adbar";
    repo = "htmldate";
    tag = "v${version}";
    hash = "sha256-9uFf/sx0AZdlvizU65H87hbtwDKf8Ykm67bKM9Oq//s=";
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
    ++ lib.optionals (pythonOlder "3.11") [ backports-datetime-fromisoformat ]
    ++ urllib3.optional-dependencies.brotli;
    all = [
      faust-cchardet
      urllib3
    ]
    ++ lib.optionals (pythonOlder "3.11") [ backports-datetime-fromisoformat ]
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
