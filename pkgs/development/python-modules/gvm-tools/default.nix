{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  python-gvm,
}:

buildPythonPackage (finalAttrs: {
  pname = "gvm-tools";
  version = "25.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dt7njGUqi6zfwUz0gSdOHWnSUJ+yJ7qJ3RttoPweR3c=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

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
