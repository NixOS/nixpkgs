{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-aliases";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-aliases";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Km6rVAsdoctECEFxZG/gCnacmhdHQVJcVrOta6xh1XU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_aliases" ];

  meta = {
    description = "Enable aliases for click";
    homepage = "https://github.com/click-contrib/click-aliases";
    changelog = "https://github.com/click-contrib/click-aliases/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ panicgh ];
  };
})
