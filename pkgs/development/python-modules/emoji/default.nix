{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "emoji";
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = "emoji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sDQ4KE9J7/0hlmXxyploRYGkIzj3YIFrxzq7yA5NFp0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_emojize_name_only" ];

  pythonImportsCheck = [ "emoji" ];

  meta = {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    changelog = "https://github.com/carpedm20/emoji/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
