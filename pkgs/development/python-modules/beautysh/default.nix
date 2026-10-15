{
  lib,
  buildPythonPackage,
  colorama,
  editorconfig,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pytestCheckHook,
  pyyaml,
  types-colorama,
}:

buildPythonPackage (finalAttrs: {
  pname = "beautysh";
  version = "6.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lovesegfault";
    repo = "beautysh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P2oF6Sb7CBsZGSOXifxgCtJdY50YUJF3tKihp3v1cK4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    colorama
    editorconfig
    types-colorama
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "beautysh" ];

  meta = {
    description = "Tool for beautifying Bash scripts";
    homepage = "https://github.com/lovesegfault/beautysh";
    changelog = "https://github.com/lovesegfault/beautysh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "beautysh";
  };
})
