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
  version = "6.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lovesegfault";
    repo = "beautysh";
    tag = "v${version}";
    hash = "sha256-B+1qwivb9MZ+W0u7hccDt3aTjDOcbEQ89Alc8mWd2Sg=";
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
    changelog = "https://github.com/lovesegfault/beautysh/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "beautysh";
  };
}
