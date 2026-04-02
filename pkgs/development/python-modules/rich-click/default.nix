{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  rich,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ewels";
    repo = "rich-click";
    tag = "v${version}";
    hash = "sha256-VSaPSC49icIB4z3ZPHtedh2gXkYBIODrG362T++i0Eo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    rich
    typing-extensions
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "rich_click" ];

  meta = {
    description = "Module to format click help output nicely with rich";
    homepage = "https://github.com/ewels/rich-click";
    changelog = "https://github.com/ewels/rich-click/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rich-click";
  };
}
