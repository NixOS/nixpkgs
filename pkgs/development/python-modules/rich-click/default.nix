{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
  rich,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "rich-click";
  version = "1.8.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewels";
    repo = "rich-click";
    tag = "v${version}";
    hash = "sha256-938YQMpq7v2iGNVoaVU1H2nuTmteZwKDfZI3anfrpcw=";
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

  meta = with lib; {
    description = "Module to format click help output nicely with rich";
    homepage = "https://github.com/ewels/rich-click";
    changelog = "https://github.com/ewels/rich-click/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "rich-click";
  };
}
