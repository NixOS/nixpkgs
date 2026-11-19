{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  python-gvm,
}:

buildPythonPackage (finalAttrs: {
  pname = "gvm-tools";
  version = "26.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pqhgfo0TaGZk9dz5yCQ3CP208rMKx/DxSIQdQ3I/Nvc=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ python-gvm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
    "HelpFormattingParserTestCase"
  ];

  pythonImportsCheck = [ "gvmtools" ];

  meta = {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
