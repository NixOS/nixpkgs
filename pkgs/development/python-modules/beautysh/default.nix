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

buildPythonPackage rec {
  pname = "beautysh";
  version = "6.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lovesegfault";
    repo = "beautysh";
    tag = "v${version}";
    hash = "sha256-wLqysNhkagZ+sphqMC78cLoKvsMJpJCJr16lgvU37JI=";
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

  meta = with lib; {
    description = "Tool for beautifying Bash scripts";
    homepage = "https://github.com/lovesegfault/beautysh";
    changelog = "https://github.com/lovesegfault/beautysh/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "beautysh";
  };
}
