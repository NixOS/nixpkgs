{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = "emoji";
    tag = "v${version}";
    hash = "sha256-YHf5UIxbdBS4JEPrD4BWE+wzYkzAboMpGmuMbOgR7s0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_emojize_name_only" ];

  pythonImportsCheck = [ "emoji" ];

  meta = {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    changelog = "https://github.com/carpedm20/emoji/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ joachifm ];
  };
}
