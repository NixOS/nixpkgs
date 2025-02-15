{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "2.14.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = "emoji";
    tag = "v${version}";
    hash = "sha256-Q1zvPL2kpG0tKsFFumoA+I0NwtqDLczYLL5skZ6g810=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_emojize_name_only" ];

  pythonImportsCheck = [ "emoji" ];

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    changelog = "https://github.com/carpedm20/emoji/blob/${src.tag}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
