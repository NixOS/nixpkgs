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
  version = "2.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-m9V9ryIE2U+KsyzFhAoMCGYMkPCBUl/ex1Ue5OUwslc=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_emojize_name_only" ];

  pythonImportsCheck = [ "emoji" ];

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    changelog = "https://github.com/carpedm20/emoji/blob/v${version}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
