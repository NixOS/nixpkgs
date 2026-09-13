{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  rich,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "rich-click";
  version = "1.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ewels";
    repo = "rich-click";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vFwsaqgue5IKBnBeHMa4jXFPqT7kI/WT0NieaAgtUjM=";
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
    changelog = "https://github.com/ewels/rich-click/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rich-click";
  };
})
