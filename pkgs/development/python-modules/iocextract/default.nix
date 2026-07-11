{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  regex,
  requests,
}:

buildPythonPackage rec {
  pname = "iocextract";
  version = "1.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "InQuest";
    repo = "iocextract";
    tag = "v${version}";
    hash = "sha256-cCp9ug/TuVY1zL+kiDlFGBmfFJyAmVwxLD36WT0oRAE=";
  };

  propagatedBuildInputs = [
    regex
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iocextract" ];

  enabledTestPaths = [ "tests.py" ];

  disabledTests = [
    # AssertionError: 'http://exampledotcom/test' != 'http://example.com/test'
    "test_refang_data"
  ];

  meta = {
    description = "Module to extract Indicator of Compromises (IOC)";
    mainProgram = "iocextract";
    homepage = "https://github.com/InQuest/iocextract";
    changelog = "https://github.com/InQuest/iocextract/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
