{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "outspin";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "outspin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j+J3n/p+DcfnhGfC4/NDBDl5bF39L5kIPeGJW0Zm7ls=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "outspin" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/trag1c/outspin/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Conveniently read single char inputs in the console";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
