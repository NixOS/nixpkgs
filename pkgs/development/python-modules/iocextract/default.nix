{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  regex,
  requests,
}:

buildPythonPackage rec {
  pname = "iocextract";
  version = "1.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "InQuest";
    repo = "python-iocextract";
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Module to extract Indicator of Compromises (IOC)";
    mainProgram = "iocextract";
    homepage = "https://github.com/InQuest/python-iocextract";
    changelog = "https://github.com/InQuest/python-iocextract/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
